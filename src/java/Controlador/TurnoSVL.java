/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Turno;
import ModeloDAO.TurnoDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "TurnoSVL", urlPatterns = {"/TurnoSVL"})
public class TurnoSVL extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TurnoDAO dao = new TurnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar" -> {
                List<Turno> turnos = dao.listar();
                request.setAttribute("turnos", turnos);
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }
            case "editar" -> {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Turno t = dao.obtenerPorId(id);
                    request.setAttribute("turno", t);
                } catch (Exception e) {
                    // ignorar parse errors
                }
                request.setAttribute("turnos", dao.listar());
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }
            default -> response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "insertar" -> {
                String nombre = request.getParameter("nombreTurno");
                if (nombre == null) nombre = "";
                nombre = nombre.trim();

                // Validaciones backend
                if (nombre.isEmpty()) {
                    request.setAttribute("errorMensaje", "El nombre no puede estar vacío.");
                    request.setAttribute("turnos", dao.listar());
                    request.setAttribute("openModal", true);
                    request.setAttribute("modalNombre", nombre);
                    request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
                    return;
                }
                if (dao.existeNombre(nombre)) {
                    request.setAttribute("errorMensaje", "Ya existe un turno con ese nombre.");
                    request.setAttribute("turnos", dao.listar());
                    request.setAttribute("openModal", true);
                    request.setAttribute("modalNombre", nombre);
                    request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
                    return;
                }
                if (dao.contarTurnos() >= 3) {
                    request.setAttribute("errorMensaje", "No se pueden agregar más de tres turnos.");
                    request.setAttribute("turnos", dao.listar());
                    request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
                    return;
                }

                Turno t = new Turno();
                t.setNombre_turno(nombre);
                t.setActivo(1);
                dao.agregar(t);

                request.setAttribute("mensaje", "Turno creado correctamente.");
                request.setAttribute("turnos", dao.listar());
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }

            case "actualizar" -> {
                try {
                    int id = Integer.parseInt(request.getParameter("id_turno"));
                    String nombre = request.getParameter("nombreTurno");
                    if (nombre == null) nombre = "";
                    nombre = nombre.trim();

                    if (nombre.isEmpty()) {
                        request.setAttribute("errorMensaje", "El nombre no puede estar vacío.");
                        request.setAttribute("turnos", dao.listar());
                        request.setAttribute("openModal", true);
                        request.setAttribute("modalNombre", nombre);
                        request.setAttribute("modalId", id);
                        request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
                        return;
                    }

                    if (dao.existeNombreExcepto(nombre, id)) {
                        request.setAttribute("errorMensaje", "Ya existe otro turno con ese nombre.");
                        request.setAttribute("turnos", dao.listar());
                        request.setAttribute("openModal", true);
                        request.setAttribute("modalNombre", nombre);
                        request.setAttribute("modalId", id);
                        request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
                        return;
                    }

                    Turno t = dao.obtenerPorId(id);
                    if (t != null) {
                        t.setNombre_turno(nombre);
                        // conservar estado actual del registro
                        dao.actualizar(t);
                        request.setAttribute("mensaje", "Turno actualizado correctamente.");
                    } else {
                        request.setAttribute("errorMensaje", "Turno no encontrado.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMensaje", "ID inválido.");
                }
                request.setAttribute("turnos", dao.listar());
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }

            case "toggleActivo" -> {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    boolean ok = dao.toggleActivo(id);
                    if (!ok) {
                        request.setAttribute("errorMensaje", "No se pudo cambiar el estado del turno.");
                    } else {
                        request.setAttribute("mensaje", "Estado cambiado correctamente.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMensaje", "ID inválido.");
                }
                request.setAttribute("turnos", dao.listar());
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }

            default -> response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
        }
    }
}
