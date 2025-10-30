<%-- 
    Document   : admin-turno
    Created on : 17 oct. 2025, 11:55:59 p. m.
    Author     : Jonathan
--%>

<%@page import="java.util.List"%>
<%@page import="ModeloBean.Turno"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Gestión de Turnos</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
      html, body {
        margin: 0; padding: 0;
        height: 100%; width: 100%;
        font-family: "Segoe UI", Arial, sans-serif;
        background: #eef3f8;
      }
      .app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; }
      .sidebar { height: 100vh; }
      .main { padding: 24px; background: #eef3f8; overflow-y: auto; }

      .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
      .header-actions h1 { font-size: 1.8rem; color: #333; }
      .btn-primary {
        background: #2563eb; color: #fff; border: none; padding: 10px 20px;
        border-radius: 8px; cursor: pointer; font-weight: 500;
        transition: 0.3s; box-shadow: 0 2px 6px rgba(37,99,235,0.2);
      }
      .btn-primary:hover { background: #1d4ed8; }

      table {
        width: 100%; border-collapse: collapse; background: #fff;
        border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      }
      th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e6e6e6; }
      th { background: #f5f6fa; color: #333; font-weight: 600; }
      tr:hover { background: #f9f9ff; }

      .btn-edit, .btn-toggle {
        border: none; padding: 6px 12px; border-radius: 6px;
        color: #fff; cursor: pointer; margin-right: 6px;
      }
      .btn-edit { background: #ffc107; }
      .btn-toggle.btn-green { background: #28a745; }
      .btn-toggle.btn-red { background: #dc3545; }

      .modal-overlay {
        display: none; position: fixed; top: 0; left: 0;
        width: 100%; height: 100%; background: rgba(0,0,0,0.4);
        justify-content: center; align-items: center; z-index: 1000;
      }
      .modal {
        background: #fff; width: 430px; border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.25);
        padding: 26px; animation: fadeIn 0.3s ease;
      }
      @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      .modal h2 { text-align: center; color: #333; font-size: 1.4rem; margin-top: 0; }
      .form-group { margin-bottom: 15px; }
      .form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
      .form-group input {
        width: 100%; padding: 10px; border: 1px solid #ccc;
        border-radius: 8px; outline: none; font-size: 1rem;
      }
      .modal-actions {
        display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;
      }
      .btn-secondary {
        background: #ccc; border: none; padding: 8px 16px;
        border-radius: 8px; cursor: pointer; font-weight: 500;
      }
      .btn-secondary:hover { background: #bbb; }
      .btn-primary-modal {
        background: #2563eb; color: #fff; border: none;
        padding: 8px 18px; border-radius: 8px; cursor: pointer; font-weight: 500;
      }
      .btn-primary-modal:hover { background: #1d4ed8; }
    </style>
  </head>

  <body id="page-turnos">
    <div class="app">
      <jsp:include page="sidebar-admin.jsp" />

      <main class="main">
        <div class="header-actions">
          <h1>Gestión de Turnos</h1>
          <button class="btn-primary" id="btnOpenModal">+ Crear Turno</button>
        </div>

        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre del Turno</th>
              <th>Activo</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <%
              List<Turno> turnos = (List<Turno>) request.getAttribute("turnos");
              if (turnos != null && !turnos.isEmpty()) {
                for (Turno t : turnos) {
                  String nombreEscapado = t.getNombre_turno() != null ? t.getNombre_turno().replace("'", "\\'") : "";
            %>
            <tr>
              <td><%= t.getId_turno() %></td>
              <td><%= t.getNombre_turno() %></td>
              <td><%= t.getActivo() == 1 ? "Sí" : "No" %></td>
              <td>
                <button type="button" class="btn-edit"
                        onclick="editarTurno(<%= t.getId_turno() %>, '<%= nombreEscapado %>')">
                  Editar
                </button>
                <form action="TurnoSVL" method="post" style="display:inline;" onsubmit="return toggleDirecto();">
                  <input type="hidden" name="accion" value="toggleActivo">
                  <input type="hidden" name="id" value="<%= t.getId_turno() %>">
                  <button type="submit" class="btn-toggle <%= t.getActivo() == 1 ? "btn-red" : "btn-green" %>">
                    <%= t.getActivo() == 1 ? "Inhabilitar" : "Habilitar" %>
                  </button>
                </form>
              </td>
            </tr>
            <% } } else { %>
              <tr><td colspan="4" style="text-align:center;">No hay turnos registrados.</td></tr>
            <% } %>
          </tbody>
        </table>
      </main>
    </div>

    <!-- MODAL -->
    <div class="modal-overlay" id="modalOverlay">
      <div class="modal">
        <h2 id="modalTitulo">Nuevo Turno</h2>
        <form id="formTurno" action="TurnoSVL" method="post">
          <input type="hidden" name="accion" id="accionForm" value="insertar">
          <input type="hidden" name="id_turno" id="id_turno">

          <div class="form-group">
            <label for="nombreTurno">Nombre del Turno</label>
            <input type="text" id="nombreTurno" name="nombreTurno" required>
          </div>

          <div class="modal-actions">
            <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
            <button type="submit" class="btn-primary-modal">Guardar</button>
          </div>
        </form>
      </div>
    </div>

    <script>
      const btnOpen = document.getElementById('btnOpenModal');
      const btnCancel = document.getElementById('btnCancelar');
      const modal = document.getElementById('modalOverlay');
      const titulo = document.getElementById('modalTitulo');
      const accion = document.getElementById('accionForm');
      const form = document.getElementById('formTurno');

      btnOpen.addEventListener('click', () => {
        accion.value = 'insertar';
        titulo.textContent = 'Nuevo Turno';
        document.getElementById('id_turno').value = '';
        document.getElementById('nombreTurno').value = '';
        modal.style.display = 'flex';
      });

      btnCancel.addEventListener('click', () => modal.style.display = 'none');
      modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });

      // ✅ Validar antes de enviar
      form.addEventListener('submit', e => {
        const nombre = document.getElementById('nombreTurno').value.trim();
        const filas = document.querySelectorAll('tbody tr');
        const nombres = Array.from(filas).map(tr => tr.children[1].innerText.trim().toLowerCase());
        const activos = Array.from(filas).filter(tr => tr.children[2].innerText.trim() === "Sí").length;

        if (nombre === "") {
          Swal.fire("Error", "El nombre del turno no puede estar vacío.", "warning");
          e.preventDefault();
          return;
        }

        if (accion.value === 'insertar' && activos >= 3) {
          Swal.fire("Error", "Solo se permiten 3 turnos activos (Mañana, Tarde y Noche).", "error");
          e.preventDefault();
          return;
        }

        if (nombres.includes(nombre.toLowerCase())) {
          Swal.fire("Error", "Ya existe un turno con ese nombre.", "error");
          e.preventDefault();
        }
      });

      function editarTurno(id, nombre) {
        accion.value = 'actualizar';
        titulo.textContent = 'Editar Turno';
        document.getElementById('id_turno').value = id;
        document.getElementById('nombreTurno').value = nombre;
        modal.style.display = 'flex';
      }

      // ✅ Cambia estado sin confirmación molesta
      function toggleDirecto() {
        Swal.fire({
          title: "Procesando...",
          text: "Cambiando estado del turno...",
          allowOutsideClick: false,
          didOpen: () => Swal.showLoading()
        });
        setTimeout(() => Swal.close(), 600);
        return true;
      }

      <% if (request.getAttribute("mensaje") != null) { %>
        Swal.fire("Éxito", "<%= request.getAttribute("mensaje") %>", "success");
      <% } else if (request.getAttribute("errorMensaje") != null) { %>
        Swal.fire("Error", "<%= request.getAttribute("errorMensaje") %>", "error");
      <% } %>
    </script>
  </body>
</html>
