/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Curso;
import ModeloDAO.CursoDAO;
import ModeloDAO.AreaDAO;
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
@WebServlet(name = "CursoSVL", urlPatterns = {"/CursoSVL"})
public class CursoSVL extends HttpServlet {
    
    CursoDAO dao = new CursoDAO();
    AreaDAO adao = new AreaDAO(); // Para cargar áreas en el JSP

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
            out.println("<title>Servlet CursoSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CursoSVL at " + request.getContextPath() + "</h1>");
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
                List<Curso> listaCursos = dao.listar();
        List listaAreas = adao.listar();

        request.setAttribute("listaCursos", listaCursos);
        request.setAttribute("listaAreas", listaAreas);
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

        if (accion.equals("agregar")) {
            int id_area = Integer.parseInt(request.getParameter("id_area"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");

            Curso c = new Curso();
            c.setNombre(nombre);
            c.setDescripcion(descripcion);
            c.setId_area(id_area);
            c.setActivo(true);

            dao.agregar(c);

        } else if (accion.equals("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id_curso"));
            dao.eliminar(id);

        } else if (accion.equals("toggleActivo")) {
            int id = Integer.parseInt(request.getParameter("id_curso"));
            dao.toggleActivo(id);
        }

        // Siempre recargar el JSP con todas las listas
        List<Curso> listaCursos = dao.listar();
        List listaAreas = adao.listar();
        request.setAttribute("listaCursos", listaCursos);
        request.setAttribute("listaAreas", listaAreas);
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
