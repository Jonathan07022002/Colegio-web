<%-- 
    Document   : admin-rol
    Created on : 17 oct. 2025, 10:54:02 p. m.
    Author     : Jonathan
--%>

<%@page import="java.util.List"%>
<%@page import="ModeloBean.Rol"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    <style>
      html, body {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
        overflow: hidden;
      }

      .app {
        display: grid;
        grid-template-columns: 270px 1fr;
        height: 100vh; /* altura total de la pantalla */
        width: 100vw;  /* ancho total de la pantalla */
        margin: 0;
      }

      .sidebar {
        height: 100vh;
      }

      .main {
        padding: 24px;
        background: #eef3f8;
        min-height: 100vh;
        overflow-y: auto; /* permite desplazarte solo dentro del contenido principal */
      }
      
    .header-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .header-actions h1 {
      font-size: 1.8rem;
      color: #333;
    }

    .btn-primary {
      background: #007bff;
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: 0.3s;
    }
    .btn-primary:hover {
      background: #0056b3;
    }

    /* --- TABLA --- */
    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 14px 16px;
      text-align: left;
      border-bottom: 1px solid #e6e6e6;
    }
    th {
      background: #f5f6fa;
      color: #333;
      font-weight: 600;
    }
    tr:hover {
      background: #f9f9ff;
    }

    /* --- MODAL --- */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.4);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal {
      background: #fff;
      width: 400px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.2);
      padding: 24px;
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .modal h2 {
      margin-top: 0;
      color: #333;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 6px;
      color: #444;
      font-weight: 500;
    }
    .form-group input,
    .form-group textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 8px;
      outline: none;
      font-family: inherit;
    }
    .form-group textarea {
      resize: none;
      height: 80px;
    }
    .modal-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 10px;
    }
    .btn-secondary {
      background: #ccc;
      border: none;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
    }
    .btn-secondary:hover {
      background: #bbb;
    }
  </style>
    </head>
    <div class="app">

    <%-- Incluir el sidebar --%>
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <div class="header-actions">
        <h1>Gestión de Roles</h1>
        <button class="btn-primary" id="btnOpenModal">+ Crear Rol</button>
      </div>

      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Nombre del Rol</th>
            <th>Descripción</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody id="tablaRoles">
          <%
                List<ModeloBean.Rol> roles = (List<ModeloBean.Rol>) request.getAttribute("roles");
                if (roles != null) {
                    for (ModeloBean.Rol r : roles) {
            %>
    <tr>
        <td><%= r.getId() %></td>
        <td><%= r.getNombre() %></td>
        <td><%= r.getDescripcion() %></td>
        <td>
            <button type="button" class="btn-secondary btnEditar"
            data-id="<%=r.getId()%>"
            data-nombre="<%=r.getNombre()%>"
            data-descripcion="<%=r.getDescripcion()%>">
            Editar
            </button>
            <a href="rolSVL?accion=eliminar&id=<%=r.getId()%>" class="btn-secondary">Eliminar</a>
        </td>
    </tr>
        <%
                }
            }
        %>
        </tbody>
      </table>
    </main>
  </div>

  <!-- MODAL -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <h2>Nuevo Rol</h2>
      <form id="formRol" action="rolSVL" method="post">
          <input type="hidden" name="accion" value="agregar"> 
        <div class="form-group">
          <label for="nombreRol">Nombre del Rol</label>
          <input type="text" id="nombreRol" name="nombreRol" required>
        </div>
        <div class="form-group">
          <label for="descripcionRol">Descripción</label>
          <input type="text" id="descripcionRol" name="descripcionRol" required>
        </div>
        <div class="modal-actions">
          <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
          <button type="submit" class="btn-primary">Guardar</button>
        </div>
      </form>
    </div>
  </div>
  
  <!-- MODAL EDITAR -->
<div class="modal-overlay" id="modalEditOverlay">
  <div class="modal">
    <h2>Editar Rol</h2>
    <form id="formEditRol" action="rolSVL" method="post">
      <input type="hidden" name="accion" value="actualizar">
      <input type="hidden" id="editId" name="id">

      <div class="form-group">
        <label for="editNombreRol">Nombre del Rol</label>
        <input type="text" id="editNombreRol" name="nombreRol" required>
      </div>

      <div class="form-group">
        <label for="editDescripcionRol">Descripción</label>
        <input type="text" id="editDescripcionRol" name="descripcionRol" required>
      </div>

      <div class="modal-actions">
        <button type="button" class="btn-secondary" id="btnCancelarEdit">Cancelar</button>
        <button type="submit" class="btn-primary">Actualizar</button>
      </div>
    </form>
  </div>
</div>

  <script>
    const btnOpen = document.getElementById('btnOpenModal');
  const btnCancel = document.getElementById('btnCancelar');
  const modal = document.getElementById('modalOverlay');
  const formRol = document.getElementById('formRol');

  btnOpen.addEventListener('click', () => modal.style.display = 'flex');
  btnCancel.addEventListener('click', () => modal.style.display = 'none');
  modal.addEventListener('click', (e) => {
    if (e.target === modal) modal.style.display = 'none';
  });
  
  const modalEdit = document.getElementById('modalEditOverlay');
  const btnCancelEdit = document.getElementById('btnCancelarEdit');
  const formEditRol = document.getElementById('formEditRol');

  // Abrir modal con datos del rol seleccionado
  document.querySelectorAll('.btnEditar').forEach(btn => {
    btn.addEventListener('click', () => {
      const id = btn.dataset.id;
      const nombre = btn.dataset.nombre;
      const descripcion = btn.dataset.descripcion;

      document.getElementById('editId').value = id;
      document.getElementById('editNombreRol').value = nombre;
      document.getElementById('editDescripcionRol').value = descripcion;

      modalEdit.style.display = 'flex';
    });
  });

  // Cerrar modal al hacer clic en cancelar o fuera del modal
  btnCancelEdit.addEventListener('click', () => modalEdit.style.display = 'none');
  modalEdit.addEventListener('click', e => {
    if (e.target === modalEdit) modalEdit.style.display = 'none';
  });
  </script>
</body>
</html>
