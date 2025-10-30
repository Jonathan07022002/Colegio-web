<%-- 
    Document   : ADMIN
    Created on : 17 oct. 2025, 11:54:48 p. m.
    Author     : Jonathan
--%>

<%@page import="java.util.List"%>
<%@page import="ModeloBean.Grado"%>
<%@page import="ModeloBean.Nivel"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Gestión de Grados</title>
  <style>
    /* (mis estilos idénticos a los previos para mantener diseño) */
    html, body { margin: 0; padding: 0; height: 100%; width: 100%; background: #eef3f8; font-family: "Segoe UI", Arial, sans-serif; }
    .app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; }
    .main { padding: 24px; background: #eef3f8; overflow-y: auto; }
    .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .header-actions h1 { font-size: 1.8rem; color: #333; }
    .btn-primary { background: #2563eb; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: background 0.3s; box-shadow: 0 2px 6px rgba(37,99,235,0.2); }
    .btn-primary:hover { background: #1d4ed8; }
    .filtros-container { background: #fff; border-radius: 10px; padding: 16px; display: flex; align-items: center; gap: 10px; margin-bottom: 20px; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
    .filtros-container select { padding: 10px 14px; border-radius: 8px; border: 1px solid #ccc; outline: none; font-size: 0.95rem; }
    .btn-filtrar { background: #2563eb; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .btn-filtrar:hover { background: #1d4ed8; }
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
    th, td { padding: 14px 16px; border-bottom: 1px solid #e6e6e6; text-align: left; }
    th { background: #f5f6fa; font-weight: 600; color: #333; }
    tr:hover { background: #f9f9ff; }
    .btn-edit, .btn-toggle { border: none; padding: 6px 12px; border-radius: 6px; color: #fff; cursor: pointer; margin-right: 6px; }
    .btn-edit { background: #ffb020; }
    .btn-edit:hover { filter: brightness(0.95); }
    .btn-red { background: #ff5c5c; color: white; }
    .btn-green { background: #28a745; color: white; }
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); justify-content: center; align-items: center; z-index: 1000; }
    .modal { background: #fff; width: 420px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.25); padding: 24px; }
    .modal h2 { text-align: center; margin-top: 0; color: #333; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
    .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; outline: none; font-size: 1rem; }
    .modal-actions { display: flex; justify-content: flex-end; gap: 10px; }
    .btn-secondary { background: #ccc; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; }
    .btn-secondary:hover { background: #bbb; }
  </style>
</head>
<body>
  <div class="app">
    <jsp:include page="sidebar-admin.jsp" />
    <main class="main">
      <div class="header-actions">
        <h1>Gestión de Grados</h1>
        <button class="btn-primary" id="btnOpenModal">+ Crear Grado</button>
      </div>

      <!-- FILTROS -->
      <div class="filtros-container">
        <label for="filtroNivel"><b>Nivel:</b></label>
        <select id="filtroNivel">
          <option value="">Todos los niveles</option>
          <%
            List<Nivel> nivelesFiltro = (List<Nivel>) request.getAttribute("niveles");
            if (nivelesFiltro != null) {
              for (Nivel n : nivelesFiltro) {
                if (true) {
          %>
          <option value="<%= n.getNombre() %>"><%= n.getNombre() %></option>
          <% } } } %>
        </select>

        <label for="filtroEstado"><b>Estado:</b></label>
        <select id="filtroEstado">
          <option value="todos">Todos</option>
          <option value="activo">Activo</option>
          <option value="inactivo">Inactivo</option>
        </select>

        <button class="btn-filtrar" id="btnFiltrar">Filtrar</button>
      </div>

      <!-- TABLA -->
      <table id="tablaGrados">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Nivel</th>
            <th>Activo</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <%
            List<Grado> grados = (List<Grado>) request.getAttribute("grados");
            if (grados != null && !grados.isEmpty()) {
              for (Grado g : grados) {
                // agregamos data-activo con el valor numérico para evitar ambigüedades
          %>
          <tr data-activo="<%= g.getActivo() %>">
            <td><%= g.getId_grado() %></td>
            <td><%= g.getNombre() %></td>
            <td><%= g.getNombreNivel() %></td>
            <td><%= g.getActivo() == 1 ? "Sí" : "No" %></td>
            <td>
              <button type="button" class="btn-edit"
                onclick="editarGrado(<%= g.getId_grado() %>, '<%= g.getNombre().replace("'", "\\'") %>', <%= g.getId_nivel() %>)">
                Editar
              </button>

              <form action="GradoSVL" method="post" style="display:inline;">
                <input type="hidden" name="accion" value="toggleActivo">
                <input type="hidden" name="id" value="<%= g.getId_grado() %>">
                <button type="submit" class="btn-toggle <%= g.getActivo() == 1 ? "btn-red" : "btn-green" %>">
                  <%= g.getActivo() == 1 ? "Inhabilitar" : "Habilitar" %>
                </button>
              </form>
            </td>
          </tr>
          <% } } else { %>
          <tr><td colspan="5" style="text-align:center;">No hay grados registrados.</td></tr>
          <% } %>
        </tbody>
      </table>
    </main>
  </div>

  <!-- MODAL -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <h2 id="modalTitle">Nuevo Grado</h2>
      <form id="formGrado" action="GradoSVL" method="post">
        <input type="hidden" name="accion" id="accionForm" value="insertar">
        <input type="hidden" name="id_grado" id="id_grado">

        <div class="form-group">
          <label for="nombreGrado">Nombre del Grado</label>
          <input type="text" id="nombreGrado" name="nombreGrado" required>
        </div>

        <div class="form-group">
          <label for="nivelGrado">Nivel</label>
          <select id="nivelGrado" name="nivelGrado" required>
            <option value="">Seleccione un nivel</option>
            <%
              List<Nivel> niveles = (List<Nivel>) request.getAttribute("niveles");
              if (niveles != null) {
                for (Nivel n : niveles) {
                  if (n.getActivo() == 1) {
            %>
            <option value="<%= n.getId_nivel() %>"><%= n.getNombre() %></option>
            <% } } } %>
          </select>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
          <button type="submit" class="btn-primary">Guardar</button>
        </div>
      </form>
    </div>
  </div>

  <!-- JAVASCRIPT -->
  <script>
    const modal = document.getElementById("modalOverlay");
    const btnOpen = document.getElementById("btnOpenModal");
    const btnCancel = document.getElementById("btnCancelar");
    const btnFiltrar = document.getElementById("btnFiltrar");

    // abrir modal
    btnOpen.onclick = () => {
      document.getElementById("accionForm").value = "insertar";
      document.getElementById("id_grado").value = "";
      document.getElementById("nombreGrado").value = "";
      document.getElementById("nivelGrado").value = "";
      document.getElementById("modalTitle").textContent = "Nuevo Grado";
      modal.style.display = "flex";
    };

    // cerrar modal
    btnCancel.onclick = () => modal.style.display = "none";
    modal.onclick = e => { if (e.target === modal) modal.style.display = "none"; };

    // editar grado
    function editarGrado(id, nombre, idNivel) {
      document.getElementById("accionForm").value = "actualizar";
      document.getElementById("id_grado").value = id;
      document.getElementById("nombreGrado").value = nombre;
      document.getElementById("nivelGrado").value = idNivel;
      document.getElementById("modalTitle").textContent = "Editar Grado";
      modal.style.display = "flex";
    }

    // Filtrar al click del botón
    btnFiltrar.addEventListener("click", filtrarGrados);

    function filtrarGrados() {
      const nivelSeleccionado = document.getElementById("filtroNivel").value.trim().toLowerCase();
      const estadoSeleccionado = document.getElementById("filtroEstado").value.trim().toLowerCase(); // "todos"|"activo"|"inactivo"
      const filas = document.querySelectorAll("#tablaGrados tbody tr");

      filas.forEach(fila => {
        const nivelCelda = fila.cells[2].textContent.trim().toLowerCase();
        const activoNum = fila.dataset.activo; // "1" o "0"
        let mostrar = true;

        // filtro por nivel (si se seleccionó)
        if (nivelSeleccionado !== "" && !nivelCelda.includes(nivelSeleccionado)) {
          mostrar = false;
        }

        // filtro por estado usando data-activo (sin ambigüedad)
        if (estadoSeleccionado === "activo") {
          if (activoNum !== "1") mostrar = false;
        } else if (estadoSeleccionado === "inactivo") {
          if (activoNum !== "0") mostrar = false;
        } else if (estadoSeleccionado === "todos") {
          // mostrar tanto 1 como 0 (sin cambio)
        }

        // caso especial: si filtró por nivel pero dejó estado en "todos", mostrar solo activos
        if (nivelSeleccionado !== "" && estadoSeleccionado === "todos") {
          if (activoNum !== "1") mostrar = false;
        }

        fila.style.display = mostrar ? "" : "none";
      });
    }

    // al cargar: mostrar solo activos por defecto
    window.addEventListener("DOMContentLoaded", () => {
      const filas = document.querySelectorAll("#tablaGrados tbody tr");
      filas.forEach(fila => {
        const activoNum = fila.dataset.activo;
        fila.style.display = (activoNum === "1") ? "" : "none";
      });
      // marcar visualmente "activo" si quieres (opcional)
      document.getElementById("filtroEstado").value = "activo";
    });
  </script>
</body>
</html>
