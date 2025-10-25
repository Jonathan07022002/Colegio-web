/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import ModeloBean.Persona;
import ModeloBean.Rol;
import ModeloDAO.PersonaDAO;
import ModeloDAO.rolDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
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
@WebServlet(name = "PersonaSVL", urlPatterns = {"/PersonaSVL"})
public class PersonaSVL extends HttpServlet {
    
    PersonaDAO personaDAO = new PersonaDAO();
    rolDAO rolDAO = new rolDAO();

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PersonaSVL</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PersonaSVL at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("listar".equals(accion)) {
            List<Persona> lista = personaDAO.listarPersonas();
            List<Rol> listaRoles = rolDAO.listar();
            request.setAttribute("personas", lista);
            request.setAttribute("roles", listaRoles);
            request.getRequestDispatcher("admin-persona.jsp").forward(request, response);
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

        if ("agregar".equalsIgnoreCase(accion)) {

            // 🔹 Captura de datos del formulario
            String dni = request.getParameter("dni");
            String nombres = request.getParameter("nombres");
            String apellidoPaterno = request.getParameter("apellido_paterno");
            String apellidoMaterno = request.getParameter("apellido_materno");
            String fechaNac = request.getParameter("fecha_nacimiento");
            String direccion = request.getParameter("direccion");
            String telefono = request.getParameter("telefono");
            String correo = request.getParameter("correo");

            // 🔹 Roles seleccionados
            String[] rolesSeleccionados = request.getParameterValues("rol");
            List<Integer> rolesIds = new ArrayList<>();
            if (rolesSeleccionados != null) {
                for (String rolId : rolesSeleccionados) {
                    rolesIds.add(Integer.parseInt(rolId));
                }
            }

            // 🔹 Crear objeto Persona
            Persona p = new Persona();
            p.setDni(dni);
            p.setNombres(nombres);
            p.setApellidoPaterno(apellidoPaterno);
            p.setApellidoMaterno(apellidoMaterno);
            p.setFechaNacimiento(Date.valueOf(fechaNac));
            p.setDireccion(direccion);
            p.setTelefono(telefono);
            p.setCorreo(correo);

            // 🔹 Guardar en la BD
            boolean ok = personaDAO.agregar(p, rolesIds);

            // 🔹 Redirección con mensaje
            if (ok) {
                response.sendRedirect("PersonaSVL?accion=listar&msg=ok");
            } else {
                response.sendRedirect("PersonaSVL?accion=listar&msg=error");
            }

        } else {
            response.sendRedirect("PersonaSVL?accion=listar");
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
