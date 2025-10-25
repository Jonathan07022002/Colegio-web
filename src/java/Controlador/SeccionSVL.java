/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Seccion;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ModeloDAO.SeccionDAO;
import java.util.List;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "SeccionSVL", urlPatterns = {"/SeccionSVL"})
public class SeccionSVL extends HttpServlet {
    SeccionDAO dao = new SeccionDAO();

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
            out.println("<title>Servlet SeccionSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SeccionSVL at " + request.getContextPath() + "</h1>");
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
        if (accion == null) accion = "";

        switch (accion) {
            case "insertar" -> {
                String nombre = request.getParameter("nombreSeccion");
                int aforo = Integer.parseInt(request.getParameter("aforoMax"));
                Seccion s = new Seccion();
                s.setNombre(nombre);
                s.setAforo_max(aforo);
                dao.agregar(s);
                response.sendRedirect("SeccionSVL?accion=listar");
            }
            case "actualizar" -> {
                int id = Integer.parseInt(request.getParameter("id_seccion"));
                String nombre = request.getParameter("nombreSeccion");
                int aforo = Integer.parseInt(request.getParameter("aforoMax"));
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
