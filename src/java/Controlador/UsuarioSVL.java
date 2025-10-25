/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Persona;
import ModeloBean.Usuario;
import ModeloDAO.PersonaDAO;
import ModeloDAO.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "UsuarioSVL", urlPatterns = {"/UsuarioSVL"})
public class UsuarioSVL extends HttpServlet {
    private UsuarioDAO usuariodao = new UsuarioDAO();

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
            out.println("<title>Servlet UsuarioSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UsuarioSVL at " + request.getContextPath() + "</h1>");
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

        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar" -> listarUsuarios(request, response);
            case "buscarPersona" -> buscarPersona(request, response);
            default -> listarUsuarios(request, response);
        }
    }
    
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> lista = usuariodao.listar();
        request.setAttribute("listaUsuarios", lista);

        RequestDispatcher dispatcher = request.getRequestDispatcher("admin-usuario.jsp");
        dispatcher.forward(request, response);
    }
    
    private void buscarPersona(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException{
        response.setContentType("text/plain;charset=UTF-8");
        String dni = request.getParameter("dniUsuario");

        if (dni == null || dni.trim().isEmpty()) {
            response.getWriter().write("error|DNI vacío");
            return;
        }

        PersonaDAO personaDAO = new PersonaDAO();
        Persona persona = personaDAO.buscarPorDni(dni.trim());

        try (PrintWriter out = response.getWriter()) {
            if (persona != null) {
                String nombreCompleto = persona.getNombres() + " " +
                                        persona.getApellidoPaterno() + " " +
                                        persona.getApellidoMaterno();
                out.write("ok|" + persona.getId() + "|" + nombreCompleto);
            } else {
                out.write("error|No se encontró persona");
            }
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
        if (accion == null) accion = "listar";

        switch (accion) {
            case "buscarPersona" -> buscarPersona(request, response);
            default -> listarUsuarios(request, response);
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
