/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Seccion;
import ModeloDAO.SeccionDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "SeccionSVL", urlPatterns = {"/SeccionSVL"})
public class SeccionSVL extends HttpServlet {
    SeccionDAO dao = new SeccionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar" -> {
                List<Seccion> secciones = dao.listar();
                request.setAttribute("secciones", secciones);
                request.getRequestDispatcher("admin-seccion.jsp").forward(request, response);
            }
            default -> response.sendRedirect(request.getContextPath() + "/SeccionSVL?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "insertar" -> {
                String nombre = request.getParameter("nombreSeccion").trim();
                int aforo = Integer.parseInt(request.getParameter("aforoMax"));

                if (dao.existeNombre(nombre)) {
                    request.setAttribute("errorMensaje", "Ya existe una sección con el nombre '" + nombre + "'.");
                    List<Seccion> secciones = dao.listar();
                    request.setAttribute("secciones", secciones);
                    request.getRequestDispatcher("admin-seccion.jsp").forward(request, response);
                    return;
                }

                Seccion s = new Seccion();
                s.setNombre(nombre);
                s.setAforo_max(aforo);
                dao.agregar(s);
                response.sendRedirect("SeccionSVL?accion=listar");
            }

            case "actualizar" -> {
                int id = Integer.parseInt(request.getParameter("id_seccion"));
                String nombre = request.getParameter("nombreSeccion").trim();
                int aforo = Integer.parseInt(request.getParameter("aforoMax"));

                // validar duplicado en otro id
                List<Seccion> todas = dao.listar();
                boolean duplicado = todas.stream()
                        .anyMatch(sec -> sec.getNombre().equalsIgnoreCase(nombre) && sec.getId_seccion() != id);

                if (duplicado) {
                    request.setAttribute("errorMensaje", "Ya existe una sección con el nombre '" + nombre + "'.");
                    List<Seccion> secciones = dao.listar();
                    request.setAttribute("secciones", secciones);
                    request.getRequestDispatcher("admin-seccion.jsp").forward(request, response);
                    return;
                }

                Seccion s = new Seccion();
                s.setId_seccion(id);
                s.setNombre(nombre);
                s.setAforo_max(aforo);
                dao.actualizar(s);
                response.sendRedirect("SeccionSVL?accion=listar");
            }

            case "toggleActivo" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.toggleActivo(id);
                response.sendRedirect("SeccionSVL?accion=listar");
            }

            default -> response.sendRedirect("SeccionSVL?accion=listar");
        }
    }
}

