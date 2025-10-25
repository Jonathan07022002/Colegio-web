/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Parentesco;
import ModeloDAO.ParentescoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "ParentescoSVL", urlPatterns = {"/ParentescoSVL"})
public class ParentescoSVL extends HttpServlet {

    Parentesco parentesco = new Parentesco();
    ParentescoDAO dao = new ParentescoDAO();
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ParentescoSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ParentescoSVL at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
    if (accion == null) accion = "listar"; // 👈 agrega esto

    switch (accion) {
        case "listar":
            List<Parentesco> lista = dao.listar();
            PrintWriter out = response.getWriter();
            if (lista.isEmpty()) {
                out.println("<tr><td colspan='4' style='text-align:center;'>No hay parentescos registrados</td></tr>");
            } else {
                for (Parentesco p : lista) {
                    out.println("<tr>");
                    out.println("<td>" + p.getId() + "</td>");
                    out.println("<td>" + p.getNombre() + "</td>");
                    out.println("<td>" + (p.getActivo() == 1 ? "Si" : "No") + "</td>");
                    out.println("<td>");
                    out.println("<button class='btn-edit' onclick='editarParentesco(" + p.getId() + ")'>editar️</button>");
                    out.println("<button class='btn-delete' onclick='eliminarParentesco(" + p.getId() + ")'>inhabilitar️</button>");
                    out.println("</td>");
                    out.println("</tr>");
                }
            }
            break;

        case "eliminar":
            int idEliminar = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(idEliminar);
            response.sendRedirect("ParentescoSVL?accion=listar");
            break;

        case "editar":
            int idEditar = Integer.parseInt(request.getParameter("id"));
            Parentesco parentescoEditar = dao.obtenerPorId(idEditar);
            request.setAttribute("rol", parentescoEditar);
            request.getRequestDispatcher("editar-parentesco.jsp").forward(request, response);
            break;

        default:
            response.sendRedirect("admin-apoderado.jsp");
    }
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        switch (accion) {
            case "agregar":
                String nombre = request.getParameter("nombre");
                int activo = Integer.parseInt(request.getParameter("activo"));
                parentesco.setNombre(nombre);
                parentesco.setActivo(activo);
                dao.agregar(parentesco);
                response.sendRedirect("ParentescoSVL?accion=listar");
                break;

            case "actualizar":
                int id = Integer.parseInt(request.getParameter("id"));
                String nombreUp = request.getParameter("nombre");
                int activoUp = Integer.parseInt(request.getParameter("activo"));
                parentesco.setId(id);
                parentesco.setNombre(nombreUp);
                parentesco.setActivo(activoUp);
                dao.actualizar(parentesco);
                response.sendRedirect("ParentescoSVL?accion=listar");
                break;

            default:
                response.sendRedirect("ParentescoSVL?accion=listar");
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
