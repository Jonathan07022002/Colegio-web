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
  <style>
    html, body { margin: 0; padding: 0; height: 100%; width: 100%; font-family: Arial, sans-serif; }
    .app { display: grid; grid-template-columns: 270px 1fr; min-height: 100vh; width: 100vw; }
    .main { padding: 24px; background: #eef3f8; min-height: 100vh; overflow-y: auto; }
    .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .btn-primary { background: #007bff; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: 0.3s; }
    .btn-primary:hover { background: #0056b3; }
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
    th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e6e6e6; }
    th { background: #f5f6fa; color: #333; font-weight: 600; }
    tr:hover { background: #f9f9ff; }
    .btn-edit { background: #ffc107; color: #000; border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer; }
    .btn-delete { background: #dc3545; color: #fff; border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer; }
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); justify-content: center; align-items: center; z-index: 1000; }
    .modal { background: #fff; width: 400px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); padding: 24px; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
    .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; outline: none; }
    .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; }
    .btn-secondary { background: #ccc; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; font-weight: 500; }
    .btn-secondary:hover { background: #bbb; }
  </style>
</head>
<body id="page-turno">
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
          %>
          <tr>
            <td><%= t.getId_turno() %></td>
            <td><%= t.getNombre_turno() %></td>
            <td><%= t.getActivo() == 1 ? "Sí" : "No" %></td>
            <td>
              <form action="${pageContext.request.contextPath}/TurnoSVL" method="get" style="display:inline;">
                <input type="hidden" name="accion" value="editar">
                <input type="hidden" name="id" value="<%= t.getId_turno() %>">
                <button type="submit" class="btn-edit">Editar</button>
              </form>
              <form action="${pageContext.request.contextPath}/TurnoSVL" method="get" style="display:inline;" onsubmit="return confirm('¿Eliminar este turno?');">
                <input type="hidden" name="accion" value="eliminar">
                <input type="hidden" name="id" value="<%= t.getId_turno() %>">
                <button type="submit" class="btn-delete">Eliminar</button>
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
      <h2>Nuevo Turno</h2>
      <form action="${pageContext.request.contextPath}/TurnoSVL" method="post">
        <input type="hidden" name="accion" id="accionForm" value="insertar">
        <input type="hidden" name="id_turno" id="id_turno">
        <div class="form-group">
          <label for="nombreTurno">Nombre del Turno</label>
          <input type="text" id="nombreTurno" name="nombreTurno" required>
        </div>
        <div class="form-group">
          <label for="activo">Activo</label>
          <select id="activo" name="activo" required>
            <option value="Sí">Sí</option>
            <option value="No">No</option>
          </select>
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
      document.querySelector('.modal h2').textContent = 'Nuevo Turno';
      modal.style.display = 'flex';
    });
    btnCancel.addEventListener('click', () => modal.style.display = 'none');
    modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });
  </script>

  <% 
    Turno editar = (Turno) request.getAttribute("turno");
    if (editar != null) {
  %>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('accionForm').value = 'actualizar';
      document.getElementById('id_turno').value = '<%= editar.getId_turno() %>';
      document.getElementById('nombreTurno').value = '<%= editar.getNombre_turno() %>';
      document.getElementById('activo').value = '<%= editar.getActivo() == 1 ? "Sí" : "No" %>';
      document.querySelector('.modal h2').textContent = 'Editar Turno';
      document.getElementById('modalOverlay').style.display = 'flex';
    });
  </script>
  <% 
    } //  cierre correcto del if(editar != null)
  %>
</body>
</html>
