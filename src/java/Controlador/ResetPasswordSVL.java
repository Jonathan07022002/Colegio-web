/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloDAO.PersonaDAO;
import ModeloBean.Persona;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import conexion.conexion;
import util.EmailUtil; // util centralizado para enviar correo

@WebServlet(name = "ResetPasswordSVL", urlPatterns = {"/ResetPassword"})
public class ResetPasswordSVL extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "inicio";

        switch (accion) {

            // === Paso 1: Solicitar envío de código ===
            case "enviarCodigo": {
                response.setContentType("application/json;charset=UTF-8");
                String dni = trim(request.getParameter("dni"));
                String correo = trim(request.getParameter("correo"));

                Map<String, Object> out = new HashMap<>();
                out.put("ok", false);

                try (Connection con = conexion.getConexion()) {
                    PersonaDAO pdao = new PersonaDAO();
                    Persona p = pdao.buscarPorDni(dni);

                    if (p == null || p.getCorreo() == null || !p.getCorreo().equalsIgnoreCase(correo)) {
                        out.put("msg", "El DNI y el correo no coinciden.");
                        response.getWriter().write(new Gson().toJson(out));
                        return;
                    }

                    long idPersona = p.getId();
                    long idUsuario = getUsuarioIdPorPersona(idPersona);
                    if (idUsuario == 0L) {
                        out.put("msg", "La persona no tiene usuario registrado.");
                        response.getWriter().write(new Gson().toJson(out));
                        return;
                    }

                    // Generar código de 6 dígitos
                    String codigo = String.format("%06d", new Random().nextInt(1_000_000));

                    // Invalida tokens previos sin usar de este usuario (por limpieza)
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE password_reset SET used=1 WHERE id_usuario=? AND used=0")) {
                        ps.setLong(1, idUsuario);
                        ps.executeUpdate();
                    }

                    // Insertar nuevo token con expiración de 15 minutos
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO password_reset (id_usuario, token, expires_at, used) " +
                                    "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 15 MINUTE), 0)")) {
                        ps.setLong(1, idUsuario);
                        ps.setString(2, codigo);
                        ps.executeUpdate();
                    }

                    // Enviar correo real
                    try {
                        EmailUtil.enviarCodigo(correo, codigo);
                        out.put("ok", true);
                    } catch (Exception mailEx) {
                        mailEx.printStackTrace(); // Ver detalle en "View Server Log"
                        out.put("ok", false);
                        out.put("msg", "No se pudo enviar el correo (revisa logs del servidor).");
                    }

                    response.getWriter().write(new Gson().toJson(out));
                } catch (Exception ex) {
                    ex.printStackTrace();
                    out.put("msg", "Error enviando el código.");
                    response.getWriter().write(new Gson().toJson(out));
                }
                return;
            }

            default:
                // Página para solicitar el código
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        // === Paso 2: Confirmar código y cambiar contraseña ===
        if ("confirmarCodigo".equalsIgnoreCase(accion)) {
            String dni = trim(request.getParameter("dni"));
            String correo = trim(request.getParameter("correo"));
            String codigo = trim(request.getParameter("codigo"));
            String pass1 = trim(request.getParameter("pass1"));
            String pass2 = trim(request.getParameter("pass2"));

            // Validación server-side
            if (!dni.matches("\\d{8}")) {
                request.setAttribute("msg", "DNI inválido.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            if (!correoValido(correo)) {
                request.setAttribute("msg", "Correo inválido.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            if (!codigo.matches("\\d{6}")) {
                request.setAttribute("msg", "Código inválido.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            if (pass1 == null || pass2 == null || !pass1.equals(pass2)) {
                request.setAttribute("msg", "Las contraseñas no coinciden.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            if (!isStrongPassword(pass1)) {
                request.setAttribute("msg",
                    "La contraseña debe tener mínimo 8 caracteres, al menos 1 mayúscula, 1 minúscula, 1 número y 1 carácter especial.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }

            try (Connection con = conexion.getConexion()) {
                PersonaDAO pdao = new PersonaDAO();
                Persona p = pdao.buscarPorDni(dni);

                if (p == null || p.getCorreo() == null || !p.getCorreo().equalsIgnoreCase(correo)) {
                    request.setAttribute("msg", "El DNI y el correo no coinciden.");
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                    return;
                }

                long idPersona = p.getId();
                long idUsuario = getUsuarioIdPorPersona(idPersona);
                if (idUsuario == 0L) {
                    request.setAttribute("msg", "La persona no tiene usuario registrado.");
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                    return;
                }

                // 2.1 Buscar token por código, no usado
                String qTok = "SELECT id FROM password_reset " +
                              "WHERE id_usuario=? AND token=? AND used=0 " +
                              "ORDER BY created_at DESC LIMIT 1";

                Long prId = null;
                try (PreparedStatement ps = con.prepareStatement(qTok)) {
                    ps.setLong(1, idUsuario);
                    ps.setString(2, codigo);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) prId = rs.getLong("id");
                    }
                }

                if (prId == null) {
                    request.setAttribute("msg", "Código incorrecto o ya utilizado.");
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                    return;
                }

                // 2.2 Validar vigencia en SQL (evita problemas de timezone)
                boolean vigente = false;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT 1 FROM password_reset WHERE id=? AND used=0 AND expires_at > NOW()")) {
                    ps.setLong(1, prId);
                    try (ResultSet rs = ps.executeQuery()) {
                        vigente = rs.next();
                    }
                }
                if (!vigente) {
                    request.setAttribute("msg", "El código ha expirado. Solicítalo nuevamente.");
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                    return;
                }

                // 2.3 Cambiar contraseña y marcar token como usado (transacción)
                con.setAutoCommit(false);
                try {
                    // Actualiza contraseña del usuario
                    String hash = pass1; // solo guarda el texto plano

                        try (PreparedStatement ps2 = con.prepareStatement(
                                "UPDATE usuario SET password_hash=? WHERE id_usuario=?")) {
                            ps2.setString(1, hash);
                            ps2.setLong(2, idUsuario);
                            ps2.executeUpdate();
                    }

                    // Marca el token como usado
                    try (PreparedStatement ps3 = con.prepareStatement(
                            "UPDATE password_reset SET used=1 WHERE id=?")) {
                        ps3.setLong(1, prId);
                        ps3.executeUpdate();
                    }

                    con.commit();
                    request.setAttribute("info", "¡Contraseña actualizada! Ahora puedes iniciar sesión.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } catch (Exception tx) {
                    con.rollback();
                    throw tx;
                } finally {
                    con.setAutoCommit(true);
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("msg", "Error interno del servidor.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
            return;
        }

        doGet(request, response);
    }

    // ===== Helpers =====
    private static String trim(String s) { return s == null ? "" : s.trim(); }

    private static boolean correoValido(String email) {
        return email != null && email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    private static boolean isStrongPassword(String s) {
    if (s == null) return false;
    // Al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo
  return s.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?`~]).{8,}$");
}

    private long getUsuarioIdPorPersona(long idPersona) {
        String sql = "SELECT id_usuario FROM usuario WHERE id_persona=? LIMIT 1";
        try (Connection c = conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idPersona);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (Exception e) {
            System.err.println("Error en getUsuarioIdPorPersona: " + e.getMessage());
            e.printStackTrace();
        }
        return 0L;
    }
}