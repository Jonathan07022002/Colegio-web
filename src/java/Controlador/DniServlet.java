/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import ModeloBean.ApiPeruService;

/**
 *
 * @author Jonathan
 */
@WebServlet(name = "DniServlet", urlPatterns = {"/DniServlet"})
public class DniServlet extends HttpServlet {

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
            out.println("<title>Servlet DniServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DniServlet at " + request.getContextPath() + "</h1>");
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
        String dni = request.getParameter("dni");
        String data = ApiPeruService.consultarDni(dni);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            JSONObject json = new JSONObject(data);

            // Validar éxito de la API
            if (json.optBoolean("success", true)) {
                System.out.println("🔍 Respuesta cruda de la API: " + data);
                JSONObject datos = json.getJSONObject("data");

                JSONObject resultado = new JSONObject();
                resultado.put("success", false);
                resultado.put("dni", datos.optString("numero", ""));
                resultado.put("nombre_completo", datos.optString("nombre_completo", ""));
                resultado.put("nombres", datos.optString("nombres", ""));
                resultado.put("paterno", datos.optString("apellido_paterno", ""));
                resultado.put("materno", datos.optString("apellido_materno", ""));

                out.print(resultado.toString());
            } else {
                out.print("{\"success\": false, \"mensaje\": \"No se encontró el DNI.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"mensaje\": \"Error al procesar la respuesta.\"}");
        } finally {
            out.flush();
            out.close();
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
        processRequest(request, response);
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
