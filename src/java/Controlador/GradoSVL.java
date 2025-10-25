/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Grado;
import ModeloBean.Nivel;
import ModeloDAO.GradoDAO;
import ModeloDAO.NivelDAO;
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
@WebServlet(name = "GradoSVL", urlPatterns = {"/GradoSVL"})
public class GradoSVL extends HttpServlet {
    private GradoDAO gdao = new GradoDAO();
    private NivelDAO ndao = new NivelDAO();


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
            out.println("<title>Servlet GradoSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GradoSVL at " + request.getContextPath() + "</h1>");
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
            case "listar" -> listar(request, response);
            case "editar" -> editar(request, response);
            case "eliminar" -> eliminar(request, response);
            default -> listar(request, response);
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
        if (accion == null) accion = "insertar";

        switch (accion) {
            case "insertar" -> insertar(request, response);
            case "actualizar" -> actualizar(request, response);
            case "toggleActivo" -> toggleActivo(request, response);
            default -> listar(request, response);
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
    
        private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Grado> grados = gdao.listar();
        List<Nivel> niveles = ndao.listar();
        request.setAttribute("grados", grados);
        request.setAttribute("niveles", niveles);
        request.getRequestDispatcher("admin-grado.jsp").forward(request, response);
    }

    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String nombre = request.getParameter("nombreGrado");
        String nivelStr = request.getParameter("nivelGrado");
        if (nombre == null || nombre.trim().isEmpty() || nivelStr == null || nivelStr.trim().isEmpty()) {
            // datos incompletos -> recargar lista con mensaje mínimo (puedes mejorar mostrando un alert)
            response.sendRedirect("GradoSVL?accion=listar");
            return;
        }
        int idNivel = Integer.parseInt(nivelStr);

        Grado g = new Grado();
        g.setNombre(nombre);
        g.setId_nivel(idNivel);
        g.setActivo(1); // siempre activo al crear
        gdao.agregar(g);
        response.sendRedirect("GradoSVL?accion=listar");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Grado g = gdao.buscarId(id);
        List<Grado> grados = gdao.listar();
        List<Nivel> niveles = ndao.listar();
        request.setAttribute("grados", grados);
        request.setAttribute("niveles", niveles);
        request.setAttribute("gradoEditar", g); // para auto-abrir modal con datos
        request.getRequestDispatcher("admin-grado.jsp").forward(request, response);
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id_grado"));
        String nombre = request.getParameter("nombreGrado");
        int idNivel = Integer.parseInt(request.getParameter("nivelGrado"));

        Grado g = new Grado();
        g.setId_grado(id);
        g.setNombre(nombre);
        g.setId_nivel(idNivel);

        gdao.actualizar(g);
        response.sendRedirect("GradoSVL?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        gdao.eliminar(id);
        response.sendRedirect("GradoSVL?accion=listar");
    }

    private void toggleActivo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        gdao.toggleActivo(id);
        response.sendRedirect("GradoSVL?accion=listar");
    }


}
