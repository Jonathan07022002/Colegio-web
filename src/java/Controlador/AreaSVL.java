/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Area;
import ModeloDAO.AreaDAO;
import ModeloDAO.CursoDAO;
import java.util.List;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "AreaSVL", urlPatterns = {"/AreaSVL"})
public class AreaSVL extends HttpServlet {
    
    AreaDAO dao = new AreaDAO();
    CursoDAO cdao = new CursoDAO();


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
            out.println("<title>Servlet AreaSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AreaSVL at " + request.getContextPath() + "</h1>");
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

        if ("editar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id_area"));
            Area area = dao.obtenerPorId(id);
            request.setAttribute("areaEditar", area);
        }

        List<Area> listaAreas = dao.listar();
        List listaCursos = cdao.listar();
        request.setAttribute("listaAreas", listaAreas);
        request.setAttribute("listaCursos", listaCursos);
        request.getRequestDispatcher("admin-curso.jsp").forward(request, response);

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

        if ("agregar".equals(accion)) {
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");

            Area a = new Area();
            a.setNombre(nombre);
            a.setDescripcion(descripcion);
            a.setActivo(true);
            dao.agregar(a);

        } else if ("toggleActivo".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id_area"));
            dao.toggleActivo(id);

        } else if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id_area"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            boolean activo = Boolean.parseBoolean(request.getParameter("activo"));

            Area a = new Area();
            a.setId_area(id);
            a.setNombre(nombre);
            a.setDescripcion(descripcion);
            a.setActivo(activo);
            dao.actualizar(a);
        }

        List<Area> listaAreas = dao.listar();
        List listaCursos = cdao.listar();
        request.setAttribute("listaAreas", listaAreas);
        request.setAttribute("listaCursos", listaCursos);
        request.getRequestDispatcher("admin-curso.jsp").forward(request, response);
    

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
