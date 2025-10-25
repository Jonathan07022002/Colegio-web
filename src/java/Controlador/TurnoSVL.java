/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Turno;
import ModeloDAO.TurnoDAO;
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
@WebServlet(name = "TurnoSVL", urlPatterns = {"/TurnoSVL"})
public class TurnoSVL extends HttpServlet {
        private static final long serialVersionUID = 1L;
        TurnoDAO dao = new TurnoDAO();


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
            out.println("<title>Servlet TurnoSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TurnoSVL at " + request.getContextPath() + "</h1>");
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
                List<Turno> turnos = dao.listar();
                request.setAttribute("turnos", turnos);
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }
            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Turno t = dao.obtenerPorId(id);
                request.setAttribute("turno", t);
                request.setAttribute("turnos", dao.listar());
                request.getRequestDispatcher("admin-turno.jsp").forward(request, response);
            }
            case "eliminar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(id);
                response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
            }
            default -> response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
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
                request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        switch (accion) {
            case "insertar" -> {
                String nombre = request.getParameter("nombreTurno");
                int activo = request.getParameter("activo").equals("Sí") ? 1 : 0;

                Turno t = new Turno();
                t.setNombre_turno(nombre);
                t.setActivo(activo);

                dao.agregar(t);
                response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
            }
            case "actualizar" -> {
                int id = Integer.parseInt(request.getParameter("id_turno"));
                String nombre = request.getParameter("nombreTurno");
                int activo = request.getParameter("activo").equals("Sí") ? 1 : 0;

                Turno t = new Turno();
                t.setId_turno(id);
                t.setNombre_turno(nombre);
                t.setActivo(activo);

                dao.actualizar(t);
                response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
            }
            default -> response.sendRedirect(request.getContextPath() + "/TurnoSVL?accion=listar");
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
