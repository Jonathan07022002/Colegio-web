/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;


import java.sql.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    private final String DB_URL = "jdbc:mysql://localhost:3307/colegio";
    private final String DB_USER = "root";
    private final String DB_PASS = "";
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String accion = request.getParameter("accion"); // "login" o "recuperar"
        String mensaje = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // 🔹 CASO 1: LOGIN NORMAL
                if ("login".equalsIgnoreCase(accion)) {
                    String username = request.getParameter("username").trim();
                    String password = request.getParameter("password").trim();

                    if (username.isEmpty() || password.isEmpty()) {
                        mensaje = "Completa usuario y contraseña";
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }

                    // Verificar si el usuario existe
                    String sqlUser = "SELECT u.id_usuario, u.password_hash, p.id_persona " +
                            "FROM usuario u INNER JOIN persona p ON u.id_persona = p.id_persona " +
                            "WHERE u.username = ?";
                    PreparedStatement psUser = conn.prepareStatement(sqlUser);
                    psUser.setString(1, username);
                    ResultSet rsUser = psUser.executeQuery();

                    if (!rsUser.next()) {
                        mensaje = "Usuario no encontrado";
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }

                    String storedHash = rsUser.getString("password_hash");
                    if (!storedHash.equals(password)) {
                        mensaje = "Contraseña incorrecta";
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }

                    int idPersona = rsUser.getInt("id_persona");

                    // Obtener rol
                    String sqlRole = "SELECT r.nombre_rol FROM rol r " +
                            "INNER JOIN persona_rol pr ON r.id_rol = pr.id_rol " +
                            "WHERE pr.id_persona = ?";
                    PreparedStatement psRole = conn.prepareStatement(sqlRole);
                    psRole.setInt(1, idPersona);
                    ResultSet rsRole = psRole.executeQuery();

                    String role = null;
                    if (rsRole.next()) {
                        role = rsRole.getString("nombre_rol").toLowerCase();
                    } else {
                        mensaje = "El usuario no tiene un rol asignado";
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }

                    // Crear sesión
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    // Redirigir según rol
                    switch (role) {
                        case "administrador":
                            response.sendRedirect("admin-panel.jsp");
                            break;
                        case "docente":
                            response.sendRedirect("docente-inicio.jsp");
                            break;
                        case "alumno":
                            response.sendRedirect("alumno-inicio.jsp");
                            break;
                        default:
                            response.sendRedirect("docente-inicio.jsp");
                            break;
                    }
                }

                // 🔹 CASO 2: RECUPERAR CONTRASEÑA
                else if ("recuperar".equalsIgnoreCase(accion)) {
                    String username = request.getParameter("username").trim();

                    if (username.isEmpty()) {
                        mensaje = "Por favor, ingresa tu usuario.";
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                        return;
                    }

                    String sql = "SELECT email FROM usuario WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();

                    if (!rs.next()) {
                        mensaje = "Usuario no encontrado.";
                        request.setAttribute("error", mensaje);
                        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                        return;
                    }

                    // Generar token
                    String token = UUID.randomUUID().toString();
                    String update = "UPDATE usuario SET password_token=?, token_expira=DATE_ADD(NOW(), INTERVAL 15 MINUTE) WHERE username=?";
                    PreparedStatement psUpdate = conn.prepareStatement(update);
                    psUpdate.setString(1, token);
                    psUpdate.setString(2, username);
                    psUpdate.executeUpdate();

                    // (Omitimos correo real para pruebas)
                    System.out.println("Token generado para " + username + ": " + token);

                    mensaje = "Se generó un enlace de recuperación (revisa consola para pruebas)";
                    request.setAttribute("mensaje", mensaje);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

                // 🔹 Si no se pasa acción
                else {
                    response.sendRedirect("login.jsp");
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
            mensaje = "Error interno en el servidor";
            request.setAttribute("error", mensaje);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    
    }

    
    

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
