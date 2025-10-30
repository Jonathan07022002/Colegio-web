/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Rol;
import ModeloDAO.rolDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "rolSVL", urlPatterns = {"/rolSVL"})
public class rolSVL extends HttpServlet {
    rolDAO roldao = new rolDAO();
    Rol rol = new Rol();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet rolSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet rolSVL at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        switch (accion) {
            case "listar":
                List<Rol> lista = roldao.listar();
                request.setAttribute("roles", lista);
                request.getRequestDispatcher("admin-rol.jsp").forward(request, response);
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                roldao.eliminar(idEliminar);
                response.sendRedirect("rolSVL?accion=listar");
                break;

            case "editar":
                int idEditar = Integer.parseInt(request.getParameter("id"));
                Rol rolEditar = roldao.obtenerPorId(idEditar);
                request.setAttribute("rol", rolEditar);
                request.getRequestDispatcher("editar-rol.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("rolSVL?accion=listar");
        }
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
        String accion = request.getParameter("accion");

        switch (accion) {
            case "agregar":
                String nombre = request.getParameter("nombreRol");
                String descripcion = request.getParameter("descripcionRol");
                rol.setNombre(nombre.toUpperCase());
                rol.setDescripcion(descripcion);
                roldao.agregar(rol);
                response.sendRedirect("rolSVL?accion=listar");
                break;

            case "actualizar":
                int id = Integer.parseInt(request.getParameter("id"));
                String nombreUp = request.getParameter("nombreRol");
                String descripcionUp = request.getParameter("descripcionRol");
                rol.setId(id);
                rol.setNombre(nombreUp);
                rol.setDescripcion(descripcionUp);
                roldao.actualizar(rol);
                response.sendRedirect("rolSVL?accion=listar");
                break;
            case "cambiarEstado":
                int a = Integer.parseInt(request.getParameter("id"));                
                int activo = Integer.parseInt(request.getParameter("activo"));
                if(activo == 1){
                    roldao.cambiarEstado(a, 0);
                    response.sendRedirect("rolSVL?accion=listar");
                } else if(activo == 0){
                    roldao.cambiarEstado(a, 1);
                    response.sendRedirect("rolSVL?accion=listar");
                }
            break;

            default:
                response.sendRedirect("rolSVL?accion=listar");
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
