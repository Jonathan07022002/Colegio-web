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
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "GradoSVL", urlPatterns = {"/GradoSVL"})
public class GradoSVL extends HttpServlet {

    private final GradoDAO gdao = new GradoDAO();
    private final NivelDAO ndao = new NivelDAO();

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

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nivel = request.getParameter("nivel");
        String estado = request.getParameter("estado");
        if (estado == null) estado = "activo"; // por defecto solo activos

        List<Grado> grados = gdao.listarFiltrado(nivel, estado);
        List<Nivel> niveles = ndao.listar();

        request.setAttribute("niveles", niveles);
        request.setAttribute("grados", grados);
        request.setAttribute("nivelSeleccionado", nivel);
        request.setAttribute("estadoSeleccionado", estado);

        request.getRequestDispatcher("admin-grado.jsp").forward(request, response);
    }

    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String nombre = request.getParameter("nombreGrado");
        String nivelStr = request.getParameter("nivelGrado");

        if (nombre == null || nombre.trim().isEmpty() || nivelStr == null || nivelStr.isEmpty()) {
            response.sendRedirect("GradoSVL?accion=listar");
            return;
        }

        Grado g = new Grado();
        g.setNombre(nombre.trim());
        g.setId_nivel(Integer.parseInt(nivelStr));
        g.setActivo(1);
        gdao.agregar(g);
        response.sendRedirect("GradoSVL?accion=listar");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Grado g = gdao.buscarId(id);
        List<Nivel> niveles = ndao.listar();
        request.setAttribute("gradoEditar", g);
        request.setAttribute("niveles", niveles);
        listar(request, response);
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

