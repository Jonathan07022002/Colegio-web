/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloDAO.GradoSeccionDAO;
import ModeloBean.GradoSeccion;
import ModeloDAO.GradoDAO;
import ModeloDAO.SeccionDAO;
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
@WebServlet(name = "GradoSeccionSVL", urlPatterns = {"/GradoSeccionSVL"})
public class GradoSeccionSVL extends HttpServlet {
    private GradoSeccionDAO dao = new GradoSeccionDAO();

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
            out.println("<title>Servlet GradoSeccionSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GradoSeccionSVL at " + request.getContextPath() + "</h1>");
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
                List<GradoSeccion> lista = dao.listar();
                request.setAttribute("gradoSecciones", lista);

                // Enviar combos
                request.setAttribute("grados", new GradoDAO().listar());
                request.setAttribute("secciones", new SeccionDAO().listar());
                request.setAttribute("turnos", new TurnoDAO().listar());

                request.getRequestDispatcher("admin-grado-seccion.jsp").forward(request, response);
            }

            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                GradoSeccion gs = dao.obtenerPorId(id);

                request.setAttribute("gradoSeccion", gs);
                request.setAttribute("grados", new GradoDAO().listar());
                request.setAttribute("secciones", new SeccionDAO().listar());
                request.setAttribute("turnos", new TurnoDAO().listar());

                request.getRequestDispatcher("admin-grado-seccion.jsp").forward(request, response);
            }

            case "eliminar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(id);
                response.sendRedirect("GradoSeccionSVL?accion=listar");
            }

            default -> response.sendRedirect("GradoSeccionSVL?accion=listar");
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

        GradoSeccion gs = new GradoSeccion();
        gs.setId_grado(Integer.parseInt(request.getParameter("id_grado")));
        gs.setId_seccion(Integer.parseInt(request.getParameter("id_seccion")));
        gs.setId_turno(Integer.parseInt(request.getParameter("id_turno")));
        gs.setVacante(Integer.parseInt(request.getParameter("vacante")));
        gs.setAnio(Integer.parseInt(request.getParameter("anio")));
        gs.setActivo("Sí".equals(request.getParameter("activo")) ? 1 : 0);

        switch (accion) {
            case "insertar" -> dao.insertar(gs);
            case "actualizar" -> {
                gs.setId_grado_seccion(Integer.parseInt(request.getParameter("id_grado_seccion")));
                dao.actualizar(gs);
            }
        }
        response.sendRedirect("GradoSeccionSVL?accion=listar");
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


