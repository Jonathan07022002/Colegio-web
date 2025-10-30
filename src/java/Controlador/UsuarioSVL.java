package Controlador;

import ModeloDAO.UsuarioDAO;
import ModeloDAO.PersonaDAO;
import ModeloBean.Usuario;
import ModeloBean.Persona;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UsuarioSVL", urlPatterns = {"/UsuarioSVL"})
public class UsuarioSVL extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final PersonaDAO personaDAO = new PersonaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar": {
                List<Usuario> lista = usuarioDAO.listar();
                request.setAttribute("listaUsuarios", lista);
                request.getRequestDispatcher("admin-usuario.jsp").forward(request, response);
                break;
            }

            // ===== NUEVO: crear un usuario a partir del DNI =====
            case "crearDesdeDni": {
                String dni = request.getParameter("dni");
                if (dni == null || !dni.matches("\\d{8}")) {
                    request.getSession().setAttribute("flash_err", "DNI inválido (8 dígitos).");
                    response.sendRedirect("UsuarioSVL?accion=listar");
                    return;
                }
                Persona p = personaDAO.obtenerPorDni(dni);
                if (p == null) {
                    request.getSession().setAttribute("flash_err", "No existe una persona con ese DNI.");
                    response.sendRedirect("UsuarioSVL?accion=listar");
                    return;
                }
                if (usuarioDAO.existeUsuarioPorPersona(p.getId())) {
                    // Si ya tenía usuario, sólo actualizamos la contraseña (DNI)
                    usuarioDAO.actualizarPasswordPorPersona(p.getId(), dni);
                    request.getSession().setAttribute("flash_ok",
                            "La persona ya tenía usuario. Se actualizó la contraseña a su DNI.");
                } else {
                    boolean ok = usuarioDAO.crearUsuarioParaPersona(p, dni);
                    if (ok) {
                        request.getSession().setAttribute("flash_ok", "Usuario creado correctamente.");
                    } else {
                        request.getSession().setAttribute("flash_err", "No se pudo crear el usuario.");
                    }
                }
                response.sendRedirect("UsuarioSVL?accion=listar");
                break;
            }

            // ===== NUEVO: generación MASIVA por Rol =====
            case "crearMasivoPorRol": {
                String rol = request.getParameter("rol");
                if (rol == null || rol.trim().isEmpty()) {
                    request.getSession().setAttribute("flash_err", "Debe seleccionar un rol.");
                    response.sendRedirect("UsuarioSVL?accion=listar");
                    return;
                }
                int creados = usuarioDAO.crearMasivoPorRol(rol);
                request.getSession().setAttribute("flash_ok",
                        "Proceso masivo completado. Usuarios creados/actualizados: " + creados);
                response.sendRedirect("UsuarioSVL?accion=listar");
                break;
            }

            // ===== Toggle ACTIVO/INACTIVO (como tenías) =====
            case "cambiarEstado": {
                long id = Long.parseLong(request.getParameter("id"));
                Usuario u = usuarioDAO.obtenerPorId(id);
                int nuevoEstadoId = 1; // ACTIVO
                if (u != null && "INACTIVO".equalsIgnoreCase(u.getEstado())) {
                    nuevoEstadoId = 1;
                } else if (u != null) {
                    nuevoEstadoId = 2; // INACTIVO
                }
                usuarioDAO.cambiarEstado(id, nuevoEstadoId);
                response.sendRedirect("UsuarioSVL?accion=listar");
                break;
            }

            default:
                response.sendRedirect("UsuarioSVL?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}