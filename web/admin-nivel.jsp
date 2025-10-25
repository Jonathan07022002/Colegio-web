<%-- 
    Document   : admin-nivel
    Created on : 17 oct. 2025, 11:51:18 p. m.
    Author     : Jonathan
--%>

<%@page import="java.util.List"%>
<%@page import="ModeloBean.Nivel"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Gestión de Niveles</title>
    <style>
      html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
      .app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; }
      .sidebar { height: 100vh; }
      .main { padding: 24px; background: #eef3f8; min-height: 100vh; overflow-y: auto; }
      .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
      .header-actions h1 { font-size: 1.8rem; color: #333; }
      .btn-primary { background: #007bff; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: 0.3s; }
      .btn-primary:hover { background: #0056b3; }
      table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
      th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e6e6e6; }
      th { background: #f5f6fa; color: #333; font-weight: 600; }
      tr:hover { background: #f9f9ff; }
      .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); justify-content: center; align-items: center; z-index: 1000; }
      .modal { background: #fff; width: 400px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); padding: 24px; animation: fadeIn 0.3s ease; }
      @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
      .modal h2 { margin-top: 0; color: #333; text-align: center; }
      .form-group { margin-bottom: 15px; }
      .form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
      .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; outline: none; }
      .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; }
      .btn-secondary { background: #ccc; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; font-weight: 500; }
      .btn-secondary:hover { background: #bbb; }
    </style>
  </head>

  <body id="page-niveles">
    <div class="app">
      <jsp:include page="sidebar-admin.jsp" />

      <main class="main">
        <div class="header-actions">
          <h1>Gestión de Niveles</h1>
          <button class="btn-primary" id="btnOpenModal">+ Crear Nivel</button>
        </div>

        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre</th>
              <th>Activo</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <%
              List<Nivel> niveles = (List<Nivel>) request.getAttribute("niveles");
              if (niveles != null && !niveles.isEmpty()) {
                  for (Nivel n : niveles) {
            %>
            <tr>
              <td><%= n.getId_nivel() %></td>
              <td><%= n.getNombre() %></td>
              <td><%= n.getActivo() == 1 ? "Sí" : "No" %></td>
              <td>
                <form action="NivelSVL" method="get" style="display:inline;">
                  <input type="hidden" name="accion" value="editar">
                  <input type="hidden" name="id" value="<%= n.getId_nivel() %>">
                  <button type="submit" class="btn-secondary" style="background:#ffc107 ;color:white;">Editar</button>
                </form>

                <form action="NivelSVL" method="get" style="display:inline;">
                  <input type="hidden" name="accion" value="toggleActivo">
                  <input type="hidden" name="id" value="<%= n.getId_nivel() %>">
                  <button type="submit" class="btn-secondary"
                    style="background:<%= n.getActivo() == 1 ? "#ff5c5c" : "#28a745" %>;color:white;">
                    <%= n.getActivo() == 1 ? "Inhabilitar" : "Habilitar" %>
                  </button>
                </form>
              </td>
            </tr>
            <%
                  }
              } else {
            %>
            <tr><td colspan="4" style="text-align:center;">No hay niveles registrados.</td></tr>
            <%
              }
            %>
          </tbody>
        </table>
      </main>
    </div>

    <!-- MODAL -->
    <div class="modal-overlay" id="modalOverlay">
      <div class="modal">
        <h2>Nuevo Nivel</h2>
        <form id="formNivel" action="NivelSVL" method="post">
          <input type="hidden" name="accion" id="accionForm" value="insertar">
          <input type="hidden" name="id_nivel" id="id_nivel">

          <div class="form-group">
            <label for="nombreNivel">Nombre del Nivel</label>
            <input type="text" id="nombreNivel" name="nombreNivel" required>
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
        document.getElementById('id_nivel').value = '';
        document.getElementById('nombreNivel').value = '';
        document.querySelector('.modal h2').textContent = 'Nuevo Nivel';
        modal.style.display = 'flex';
      });

      btnCancel.addEventListener('click', () => modal.style.display = 'none');
      modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });
    </script>

    <% Nivel editar = (Nivel) request.getAttribute("nivel");
       if (editar != null) { %>
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('accionForm').value = 'actualizar';
        document.getElementById('id_nivel').value = '<%= editar.getId_nivel() %>';
        document.getElementById('nombreNivel').value = '<%= editar.getNombre() %>';
        document.querySelector('.modal h2').textContent = 'Editar Nivel';
        document.getElementById('modalOverlay').style.display = 'flex';
      });
    </script>
    <% } %>
  </body>
</html>
