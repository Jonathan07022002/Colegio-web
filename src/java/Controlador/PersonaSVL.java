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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("listar".equals(accion)) {
            List<Persona> lista = personaDAO.listarPersonas();
            List<Rol> listaRoles = rolDAO.listar();
            request.setAttribute("personas", lista);
            request.setAttribute("roles", listaRoles);

            // Si hay un mensaje (error o confirmación), lo pasamos al JSP
            String msg = request.getParameter("msg");
            if (msg != null) {
                switch (msg) {
                    case "dni_existente":
                        request.setAttribute("error", "El DNI ingresado ya está registrado.");
                        break;
                    case "correo_existente":
                        request.setAttribute("error", "El correo ingresado ya está registrado.");
                        break;
                    case "dni_invalido":
                        request.setAttribute("error", "El DNI debe tener 8 dígitos numéricos.");
                        break;
                    case "fecha_invalida":
                        request.setAttribute("error", "La fecha de nacimiento no puede ser futura.");
                        break;
                    case "rol_vacio":
                        request.setAttribute("error", "Debe seleccionar al menos un rol.");
                        break;
                    case "rol_inactivo":
                        request.setAttribute("error", "Uno de los roles seleccionados está inactivo.");
                        break;
                    case "ok":
                        request.setAttribute("exito", "Persona registrada correctamente.");
                        break;
                    case "error_bd":
                        request.setAttribute("error", "Error al guardar en la base de datos.");
                        break;
                    case "error":
                        request.setAttribute("error", "Ocurrió un error inesperado.");
                        break;
                }
            }

            request.getRequestDispatcher("admin-persona.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("agregar".equalsIgnoreCase(accion)) {
            try {
                // 🔹 Captura de datos del formulario
                String dni = request.getParameter("dni");
                String nombres = request.getParameter("nombres");
                String apellidoPaterno = request.getParameter("apellido_paterno");
                String apellidoMaterno = request.getParameter("apellido_materno");
                String fechaNac = request.getParameter("fecha_nacimiento");
                String direccion = request.getParameter("direccion");
                String telefono = request.getParameter("telefono");
                String correo = request.getParameter("correo");

                // 🔹 Validación de formato DNI
                if (dni == null || !dni.matches("\\d{8}")) {
                    reenviarConError(request, response, "El DNI debe tener 8 dígitos numéricos.");
                    return;
                }

                // 🔹 Validación de duplicados
                

                // 🔹 Validación de fecha (rango permitido: 5 a 100 años)
                    Date fechaNacimiento;
                    try {
                        fechaNacimiento = Date.valueOf(fechaNac); // formato yyyy-MM-dd
                    } catch (IllegalArgumentException e) {
                        reenviarConError(request, response, "Formato de fecha inválido (use yyyy-mm-dd).");
                        return;
                    }

                    Date fechaActual = new Date(System.currentTimeMillis());

                    // Validar que no sea futura
                    if (fechaNacimiento.after(fechaActual)) {
                        reenviarConError(request, response, "La fecha de nacimiento no puede ser futura.");
                        return;
                    }

                    // Calcular edad
                    long milisegundosPorAnio = 1000L * 60 * 60 * 24 * 365;
                    long edadAnios = (fechaActual.getTime() - fechaNacimiento.getTime()) / milisegundosPorAnio;

                    // Validar rango entre 5 y 100 años
                    if (edadAnios < 5 || edadAnios > 100) {
                        reenviarConError(request, response, "La edad debe estar entre 5 y 100 años.");
                        return;
                    }

                // 🔹 Roles seleccionados
                String[] rolesSeleccionados = request.getParameterValues("rol");
                if (rolesSeleccionados == null || rolesSeleccionados.length == 0) {
                    reenviarConError(request, response, "Debe seleccionar al menos un rol.");
                    return;
                }

                List<Integer> rolesIds = new ArrayList<>();
                for (String rolIdStr : rolesSeleccionados) {
                    int idRol = Integer.parseInt(rolIdStr);
                    if (false){
                        reenviarConError(request, response, "Uno de los roles seleccionados está inactivo.");
                        return;
                    }
                    rolesIds.add(idRol);
                }

                // 🔹 Crear objeto Persona
                Persona p = new Persona();
                p.setDni(dni);
                p.setNombres(nombres);
                p.setApellidoPaterno(apellidoPaterno);
                p.setApellidoMaterno(apellidoMaterno);
                p.setFechaNacimiento(fechaNacimiento);
                p.setDireccion(direccion);
                p.setTelefono(telefono);
                p.setCorreo(correo);

                // 🔹 Guardar en BD
                boolean ok = personaDAO.agregar(p, rolesIds);

                // 🔹 Mensaje final
                if (ok) {
                    response.sendRedirect("PersonaSVL?accion=listar&msg=ok");
                } else {
                    reenviarConError(request, response, "El DNI ingresado ya está registrado.");
                }

            } catch (Exception e) {
                System.out.println("❌ Error en PersonaSVL (agregar): " + e.getMessage());
                reenviarConError(request, response, "Ocurrió un error inesperado.");
            }

                    
        }else if("cambiarEstado".equalsIgnoreCase(accion)){
            int id = Integer.parseInt(request.getParameter("id"));
            int activo = Integer.parseInt(request.getParameter("activo"));
            if(activo == 1){
            personaDAO.cambiarEstado(id, 0);
            response.sendRedirect("PersonaSVL?accion=listar");
            } else if(activo == 0){
                personaDAO.cambiarEstado(id, 1);
                response.sendRedirect("PersonaSVL?accion=listar");
            }
        }else if("actualizar".equalsIgnoreCase(accion)){
            Persona personaEdit = new Persona();
            personaEdit.setId(Integer.parseInt(request.getParameter("id")));
            
            personaEdit.setCorreo(request.getParameter("correo"));
            personaEdit.setTelefono(request.getParameter("telefono"));
            personaEdit.setDireccion(request.getParameter("direccion"));
            try {
                personaDAO.actualizarDatosBasicos(personaEdit);
            } catch (SQLException ex) {
                System.getLogger(PersonaSVL.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            }
            response.sendRedirect("PersonaSVL?accion=listar");
        } else{
        
            response.sendRedirect("PersonaSVL?accion=listar");
        }
    }

    // ==========================
    // 🔸 MÉTODO UTILITARIO
    // ==========================
    private void reenviarConError(HttpServletRequest request, HttpServletResponse response, String mensaje)
            throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        request.setAttribute("mostrarModal", true); // para reabrir el modal
        List<Persona> lista = personaDAO.listarPersonas();
        List<Rol> listaRoles = rolDAO.listar();
        request.setAttribute("personas", lista);
        request.setAttribute("roles", listaRoles);
        request.getRequestDispatcher("admin-persona.jsp").forward(request, response);
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
