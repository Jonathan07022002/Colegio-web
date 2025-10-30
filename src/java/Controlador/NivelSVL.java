/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Nivel;
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
@WebServlet(name = "NivelSVL", urlPatterns = {"/NivelSVL"})
public class NivelSVL extends HttpServlet {
    NivelDAO dao = new NivelDAO();
    
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
            out.println("<title>Servlet NivelSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NivelSVL at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar":
                listar(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            case "toggleActivo":
                toggleActivo(request, response);
                break;
            default:
                listar(request, response);
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
            case "insertar":
                insertar(request, response);
                break;
            case "actualizar":
                actualizar(request, response);
                break;
            default:
                listar(request, response);
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
        List<Nivel> niveles = dao.listar();
        request.setAttribute("niveles", niveles);
        request.getRequestDispatcher("admin-nivel.jsp").forward(request, response);
    }

    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String nombre = request.getParameter("nombreNivel");

        Nivel n = new Nivel();
        n.setNombre(nombre);
        n.setActivo(1); // siempre activo al crear
        dao.agregar(n);
        System.out.println("✅ Nivel agregado: " + nombre);

        response.sendRedirect("NivelSVL?accion=listar");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Nivel n = dao.buscarId(id);
        request.setAttribute("nivel", n);
        listar(request, response);
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id_nivel"));
        String nombre = request.getParameter("nombreNivel");

        Nivel n = new Nivel(id, nombre, 1);
        dao.actualizar(n);
        System.out.println("✏️ Nivel actualizado: " + nombre);
        response.sendRedirect("NivelSVL?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.eliminar(id);
        System.out.println(" Nivel eliminado ID: " + id);
        response.sendRedirect("NivelSVL?accion=listar");
    }

    private void toggleActivo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.toggleActivo(id);
        System.out.println(" Estado de nivel cambiado (ID: " + id + ")");
        response.sendRedirect("NivelSVL?accion=listar");
    }
}