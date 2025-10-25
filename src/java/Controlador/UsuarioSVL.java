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
    private PersonaDAO personadao = new PersonaDAO();

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
        String dni = request.getParameter("dni");

        if (dni.isEmpty()) {
                    request.setAttribute("mensajeError", "Ingrese un DNI válido.");
                    request.getRequestDispatcher("admin-usuario.jsp").forward(request, response);
                    return;
                }

                Persona persona = personadao.buscarPorDni(dni);
                if (persona == null) {
                    request.setAttribute("mensajeError", "No se encontró persona con ese DNI.");
                } else {
                    request.setAttribute("persona", persona);
                    request.setAttribute("idPersona", persona.getId());
                    request.setAttribute("nombrePersona", persona.getNombres() + " " + persona.getApellidoPaterno() + " " + persona.getApellidoMaterno());
                }

                List<Usuario> lista = usuariodao.listar();
                request.setAttribute("listaUsuarios", lista);
                request.getRequestDispatcher("admin-usuario.jsp").forward(request, response);
}
    
    private void crear(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException{
        try {
        int idPersona = Integer.parseInt(request.getParameter("idPersona"));
        Persona persona = personadao.obtenerPorId(idPersona);

        if (persona != null) {
            String nombre = persona.getNombres().trim();
            String apellidoPaterno = persona.getApellidoPaterno().trim();
            String apellidoMaterno = persona.getApellidoMaterno().trim();
            String dni = persona.getDni().trim();

            // Generar username: 3 primeras letras del nombre + apellido paterno completo + 2 primeras del materno
            String username = "";
            if (nombre.length() >= 3) {
                username += nombre.substring(0, 3);
            } else {
                username += nombre; // por si tiene menos de 3 letras
            }
            username += apellidoPaterno;
            if (apellidoMaterno.length() >= 2) {
                username += apellidoMaterno.substring(0, 2);
            } else {
                username += apellidoMaterno;
            }

            username = (username+"@mrn.edu.pe").toLowerCase(); // opcional, para normalizar

            // Password: el DNI (puedes cifrarlo si ya manejas password_hash)
            String password = dni;

            Usuario usuario = new Usuario();
            usuario.setIdPersona(idPersona);
            usuario.setUsername(username);
            usuario.setPasswordHash(password); // o setPasswordHash si lo estás cifrando
            usuario.setIdEstado(1);
            usuario.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            boolean exito = usuariodao.insertar(usuario);

            if (exito) {
                request.setAttribute("mensajeExito", "Usuario creado correctamente.");
            } else {
                request.setAttribute("mensajeError", "No se pudo crear el usuario.");
            }
        } else {
            request.setAttribute("mensajeError", "No se encontró la persona con ese ID.");
        }

        List<Usuario> lista = usuariodao.listar();
        request.setAttribute("listaUsuarios", lista);
        request.getRequestDispatcher("admin-usuario.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensajeError", "Error al crear el usuario: " + e.getMessage());
        request.getRequestDispatcher("admin-usuario.jsp").forward(request, response);
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
            case "crear" -> crear(request, response);
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
