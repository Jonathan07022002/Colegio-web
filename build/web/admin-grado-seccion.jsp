<%-- 
    Document   : admin-gradoseccion
    Created on : 18 oct. 2025, 12:26:49 a. m.
    Author     : Jonathan
--%>

<%@page import="java.util.List"%> 
<%@page import="ModeloBean.GradoSeccion"%>
<%@page import="ModeloBean.Grado"%>
<%@page import="ModeloBean.Seccion"%>
<%@page import="ModeloBean.Turno"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>                                                   
  <meta charset="UTF-8">
  <title>Gestión de Grado-Sección</title>
  <style>
    html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
    .app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; }
    .main { padding: 24px; background: #eef3f8; min-height: 100vh; overflow-y: auto; }
    .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .header-actions h1 { font-size: 1.8rem; color: #333; }
    .btn-primary { background: #007bff; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: 0.3s; }
    .btn-primary:hover { background: #0056b3; }

    /* Filtros */
    .filter-bar {
      display: flex;
      gap: 10px;
      background: #fff;
      padding: 14px;
      border-radius: 10px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      margin-bottom: 20px;
      align-items: center;
    }
    .filter-bar select {
      padding: 8px 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 14px;
      width: 180px;
    }

    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
    th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e6e6e6; }
    th { background: #f5f6fa; color: #333; font-weight: 600; }
    tr:hover { background: #f9f9ff; }

    .btn-secondary, .btn-edit, .btn-delete {
      border: none; padding: 6px 12px; border-radius: 6px; color: #fff; cursor: pointer; margin-right: 6px;
    }
    .btn-edit { background: #ffc107; color: #000; }
    .btn-delete { background: #dc3545; }

    /* Modal */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); justify-content: center; align-items: center; z-index: 1000; }
    .modal { background: #fff; width: 450px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); padding: 24px; animation: fadeIn 0.3s ease; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
    .form-group input, .form-group select {
      width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; outline: none;
    }
    .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; }
    .btn-secondary { background: #ccc; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .btn-secondary:hover { background: #bbb; }
  </style>
</head>

<body id="page-grado-seccion">
  <div class="app">
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <div class="header-actions">
        <h1>Gestión de Grado-Sección</h1>
        <button class="btn-primary" id="btnOpenModal">+ Crear Grado-Sección</button>
      </div>

      <!-- 🔹 Filtros -->
      <form class="filter-bar">
        <select name="id_grado">
          <option value="">Todos los grados</option>
          <%
            List<Grado> grados = (List<Grado>) request.getAttribute("grados");
            if (grados != null) for (Grado g : grados) {
          %>
            <option value="<%= g.getId_grado() %>"><%= g.getNombre() %></option>
          <% } %>
        </select>

        <select name="id_seccion">
          <option value="">Todas las secciones</option>
          <%
            List<Seccion> secciones = (List<Seccion>) request.getAttribute("secciones");
            if (secciones != null) for (Seccion s : secciones) {
          %>
            <option value="<%= s.getId_seccion() %>"><%= s.getNombre() %></option>
          <% } %>
        </select>

        <select name="activo">
          <option value="">Todos</option>
          <option value="1">Activos</option>
          <option value="0">Inactivos</option>
        </select>

        <button type="submit" class="btn-primary">Filtrar</button>
      </form>

      <!-- 🔹 Tabla -->
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Nivel</th>
            <th>Grado</th>
            <th>Sección</th>
            <th>Turno</th>
            <th>Vacantes</th>
            <th>Año</th>
            <th>Activo</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody id="tablaGradoSeccion">
          <%
            List<GradoSeccion> lista = (List<GradoSeccion>) request.getAttribute("gradoSecciones");
            if (lista != null && !lista.isEmpty()) {
              for (GradoSeccion gs : lista) {
          %>
          <tr>
            <td><%= gs.getId_grado_seccion() %></td>
            <td><%= gs.getNombreNivel() %></td>
            <td><%= gs.getNombreGrado() %></td>
            <td><%= gs.getNombreSeccion() %></td>
            <td><%= gs.getNombreTurno() %></td>
            <td><%= gs.getVacante() %></td>
            <td><%= gs.getAnio() %></td>
            <td><%= gs.getActivo() == 1 ? "Sí" : "No" %></td>
            <td>
              <a href="GradoSeccionSVL?accion=editar&id=<%= gs.getId_grado_seccion() %>" class="btn-edit">Editar</a>
              <a href="GradoSeccionSVL?accion=eliminar&id=<%= gs.getId_grado_seccion() %>" class="btn-delete" onclick="return confirm('¿Deseas eliminar este registro?');">Eliminar</a>
            </td>
          </tr>
          <% } } else { %>
          <tr>
            <td colspan="9" style="text-align:center;">No hay registros disponibles.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </main>
  </div>

  <!-- 🔹 Modal -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <h2>Nuevo Grado-Sección</h2>
      <form id="formGradoSeccion" action="GradoSeccionSVL" method="post">
        <input type="hidden" name="accion" id="accionForm" value="insertar">
        <input type="hidden" name="id_grado_seccion" id="id_grado_seccion" value="">

        <div class="form-group">
          <label for="id_grado">Grado</label>
          <select id="id_grado" name="id_grado" required>
            <option value="">Seleccione</option>
            <%
              if (grados != null) for (Grado g : grados) {
            %>
              <option value="<%= g.getId_grado() %>"><%= g.getNombre() %></option>
            <% } %>
          </select>
        </div>

        <div class="form-group">
          <label for="id_seccion">Sección</label>
          <select id="id_seccion" name="id_seccion" required>
            <option value="">Seleccione</option>
            <%
              if (secciones != null) for (Seccion s : secciones) {
            %>
              <option value="<%= s.getId_seccion() %>"><%= s.getNombre() %></option>
            <% } %>
          </select>
        </div>

        <div class="form-group">
          <label for="id_turno">Turno</label>
          <select id="id_turno" name="id_turno" required>
            <option value="">Seleccione</option>
            <%
              List<Turno> turnos = (List<Turno>) request.getAttribute("turnos");
              if (turnos != null) for (Turno t : turnos) {
            %>
              <option value="<%= t.getId_turno() %>"><%= t.getNombre_turno() %></option>
            <% } %>
          </select>
        </div>

        <div class="form-group">
          <label for="vacante">Vacantes</label>
          <input type="number" id="vacante" name="vacante" required>
        </div>


        <div class="modal-actions">
          <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
          <button type="submit" class="btn-primary">Guardar</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    const btnOpen = document.getElementById('btnOpenModal');
    const btnCancel = document.getElementById('btnCancelar');
    const modal = document.getElementById('modalOverlay');

    btnOpen.addEventListener('click', () => {
      document.getElementById('accionForm').value = 'insertar';
      document.getElementById('id_grado_seccion').value = '';
      document.getElementById('formGradoSeccion').reset();
      modal.style.display = 'flex';
    });

    btnCancel.addEventListener('click', () => modal.style.display = 'none');
    modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });

    // ---------- FILTRO DINÁMICO CLIENTE ----------
    const filtroGrado = document.querySelector('select[name="id_grado"]');
    const filtroSeccion = document.querySelector('select[name="id_seccion"]');
    const filtroActivo = document.querySelector('select[name="activo"]');
    const tabla = document.getElementById('tablaGradoSeccion');

    document.querySelector('.filter-bar').addEventListener('submit', e => {
      e.preventDefault();
      aplicarFiltros();
    });

    function aplicarFiltros() {
      const gradoTexto = filtroGrado.options[filtroGrado.selectedIndex]?.text.toLowerCase();
      const seccionTexto = filtroSeccion.options[filtroSeccion.selectedIndex]?.text.toLowerCase();
      const activoValor = filtroActivo.value;

      const filas = tabla.querySelectorAll('tr');
      filas.forEach(fila => {
        const grado = fila.children[2]?.textContent.toLowerCase();
        const seccion = fila.children[3]?.textContent.toLowerCase();
        const activo = fila.children[7]?.textContent.trim() === 'Sí' ? '1' : '0';

        let visible = true;
        if (filtroGrado.value && grado !== gradoTexto) visible = false;
        if (filtroSeccion.value && seccion !== seccionTexto) visible = false;
        if (activoValor && activo !== activoValor) visible = false;

        fila.style.display = visible ? '' : 'none';
      });
    }

    [filtroGrado, filtroSeccion, filtroActivo].forEach(sel => sel.addEventListener('change', aplicarFiltros));
  </script>

  <%-- Mostrar modal en modo edición si viene desde el servlet --%>
  <%
    GradoSeccion editar = (GradoSeccion) request.getAttribute("gradoSeccion");
    if (editar != null) {
  %>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('accionForm').value = 'actualizar';
      document.getElementById('id_grado_seccion').value = '<%= editar.getId_grado_seccion() %>';
      document.getElementById('id_grado').value = '<%= editar.getId_grado() %>';
      document.getElementById('id_seccion').value = '<%= editar.getId_seccion() %>';
      document.getElementById('id_turno').value = '<%= editar.getId_turno() %>';
      document.getElementById('vacante').value = '<%= editar.getVacante() %>';
      document.getElementById('anio').value = '<%= editar.getAnio() %>';
      document.getElementById('activo').value = '<%= editar.getActivo() == 1 ? "Sí" : "No" %>';
      document.querySelector('.modal h2').textContent = 'Editar Grado-Sección';
      document.getElementById('modalOverlay').style.display = 'flex';
    });
  </script>
  <% } %>
</body>
</html>

