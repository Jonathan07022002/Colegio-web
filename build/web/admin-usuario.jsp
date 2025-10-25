<%-- 
    Document   : admin-usuario
    Created on : 18 oct. 2025, 1:05:02 p. m.
    Author     : Jonathan
--%>

<%@page import="ModeloBean.Rol"%>
<%@page import="ModeloBean.Usuario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Usuarios</title>
  <style>
      html, body {
        margin: 0; padding: 0; height: 100%; width: 100%;
      }
      .app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; }
      .main { padding: 24px; background: #eef3f8; overflow-y: auto; }
      .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
      .btn-primary {
        background: #2563eb; color: #fff; border: none; border-radius: 8px;
        padding: 8px 12px; cursor: pointer;
      }
      .btn-primary:hover { background: #1e40af; }
      table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; }
      th, td { padding: 10px 14px; border-bottom: 1px solid #e5e7eb; }
      th { background: #f3f4f6; text-align: left; }
      .btn-edit { background: #16a34a; color:#fff; border:none; border-radius:6px; padding:5px 8px; text-decoration:none; }
      .btn-edit:hover { background: #15803d; }
      .btn-delete { background: #dc2626; color:#fff; border:none; border-radius:6px; padding:5px 8px; text-decoration:none; }
      .btn-delete:hover { background: #b91c1c; }
      .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.5); justify-content: center; align-items: center; z-index: 1000; }
      .modal {
        background: #fff; border-radius: 12px; width: 500px; padding: 20px;
      }
  </style>
</head>
<body>
  <div class="app">
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <div class="header-actions">
        <h1>Gestión de Usuarios</h1>
        <div style="display:flex; gap:10px;">
          <button class="btn-primary" onclick="document.getElementById('modalIndividual').style.display='flex'">Nuevo Usuario</button>
          <button class="btn-primary" onclick="document.getElementById('modalMasivo').style.display='flex'">Generar Usuarios</button>
        </div>
      </div>

      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Usuario</th>
            <th>Nombre Completo</th>
            <th>Estado</th>
            <th>Fecha de Creación</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <%
            List<Usuario> lista = (List<Usuario>) request.getAttribute("listaUsuarios");
            if (lista != null && !lista.isEmpty()) {
              for (Usuario us : lista) {
          %>
          <tr>
            <td><%= us.getIdUsuario() %></td>
            <td><%= us.getUsername() %></td>
            <td><%= us.getNombreCompleto() %></td>
            <td><%= us.getEstado() %></td>
            <td><%= us.getCreatedAt() %></td>
            <td>
              <a href="UsuarioSVL?accion=editar&id=<%= us.getIdUsuario() %>" class="btn-edit">Editar</a>
              <a href="UsuarioSVL?accion=eliminar&id=<%= us.getIdUsuario() %>" class="btn-delete" onclick="return confirm('¿Deseas eliminar este registro?');">Eliminar</a>
            </td>
          </tr>
          <% } } else { %>
          <tr><td colspan="9" style="text-align:center;">No hay registros disponibles.</td></tr>
          <% } %>
          
          <% if (request.getAttribute("persona") != null) { %>
            <script>
              document.addEventListener("DOMContentLoaded", function() {
                document.getElementById("modalIndividual").style.display = "flex";
              });
            </script>
            <% } %>
        </tbody>
      </table>
    </main>
  </div>

  <!-- MODAL INDIVIDUAL -->
  <div class="modal-overlay" id="modalIndividual">
    <div class="modal">
      <h2>Crear Usuario Individual</h2>
      <form action="UsuarioSVL" method="post">
        <input type="hidden" name="accion" value="buscarPersona">
        <label>DNI:</label>
        <input type="text" name="dni" placeholder="Ingrese DNI" required>
        <button type="submit" class="btn-primary">Buscar</button>
      </form>

      <% if (request.getAttribute("persona") != null) { %>
        <form action="UsuarioSVL" method="post">
          <input type="hidden" name="accion" value="crear">
          <input type="hidden" name="idPersona" value="<%= request.getAttribute("idPersona") %>">
          <p><strong>Nombre:</strong> <%= request.getAttribute("nombrePersona") %></p>
          <button type="submit" class="btn-primary">Crear Usuario</button>
        </form>
      <% } %>

      <div style="text-align:right; margin-top:10px;">
          <button class="btn-primary" onclick="document.getElementById('modalIndividual').style.display='none'">Cerrar</button>
      </div>
    </div>
  </div>

  <!-- MODAL MASIVO -->
  <div class="modal-overlay" id="modalMasivo">
    <div class="modal">
      <h2>Generar Usuarios Masivos</h2>
      <form action="UsuarioSVL" method="post">
        <input type="hidden" name="accion" value="crearMasivo">
        <label>Rol:</label>
      <select name="rol" id="rolSelect" required onchange="mostrarCamposAlumno()">
        <option value="">Seleccione rol</option>
        <%
            List<Rol> listaRoles = (List<Rol>) request.getAttribute("roles");
                if (listaRoles != null) {
                    for (Rol r : listaRoles) {
            %>
                <option value="<%= r.getNombre() %>"><%= r.getNombre() %></option>
            <%
                    }
                }
            %>
      </select>
        <!-- Campos que solo se mostrarán si el rol es Alumno -->
      <div id="camposAlumno" style="display:none;">
        <label>Nivel:</label>
        <select name="nivel">
          <option value="">Seleccione nivel</option>
          <option value="Inicial">Inicial</option>
          <option value="Primaria">Primaria</option>
          <option value="Secundaria">Secundaria</option>
        </select>

        <label>Grado:</label>
        <input type="text" name="grado" placeholder="Ejemplo: 3°">

        <label>Sección:</label>
        <input type="text" name="seccion" placeholder="Ejemplo: A">
      </div>

        <div style="margin-top:10px;">
          <button type="submit" class="btn-primary">Generar Usuarios</button>
          <button type="button" class="btn-primary" onclick="document.getElementById('modalMasivo').style.display='none'">Cerrar</button>
        </div>
      </form>
    </div>
  </div>
  
<script>
  function mostrarCamposAlumno() {
    const rol = document.getElementById('rolSelect').value;
    const campos = document.getElementById('camposAlumno');

    if (rol === 'Alumno') {
      campos.style.display = 'block';
    } else {
      campos.style.display = 'none';
    }
  }
</script>
</body>
</html>