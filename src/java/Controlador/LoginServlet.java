/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;


import java.sql.*;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    private final String DB_URL = "jdbc:mysql://localhost:3307/colegio";
    private final String DB_USER = "root";
    private final String DB_PASS = "";
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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String role = request.getParameter("role").trim();
        String mensaje = "";

        if(username.isEmpty() || password.isEmpty()){
            mensaje = "Completa usuario y contraseña";
            request.setAttribute("error", mensaje);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                String sql = "SELECT u.password_hash FROM usuario u INNER JOIN persona p ON u.id_persona = p.id_persona " +
"                             INNER JOIN persona_rol rp ON p.id_persona = rp.id_persona" +
"                             INNER JOIN rol r ON rp.id_rol = r.id_rol" +
"                              WHERE u.username=? AND r.nombre_rol=?";

                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, role);

                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    String storedHash = rs.getString("password_hash");

                    if(storedHash.equals(password)){
                        // Login exitoso
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("role", role);

                        switch(role){
                            case "administrador": response.sendRedirect("admin-panel.jsp"); break;
                            case "docente": response.sendRedirect("index.html"); break;
                            case "alumno": response.sendRedirect("index.html"); break;
                            default: response.sendRedirect("sidebar_admin.jsp");
                        }
                        return;
                    } else {
                        mensaje = "Contraseña incorrecta";
                    }
                } else {
                    mensaje = "Usuario no encontrado o rol incorrecto";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            mensaje = "Error de conexión a la base de datos";
        }

        request.setAttribute("error", mensaje);
        request.getRequestDispatcher("login.jsp").forward(request, response);
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
