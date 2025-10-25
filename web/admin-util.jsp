<%-- 
    Document   : admin-util
    Created on : 18 oct. 2025, 12:02:44 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Útiles Escolares</title>
  <style>
    html, body {
      margin: 0; padding: 0; height: 100%; width: 100%;
      overflow: hidden; font-family: 'Segoe UI', sans-serif;
    }

    .app {
      display: grid;
      grid-template-columns: 270px 1fr;
      height: 100vh;
    }

    .main {
      padding: 24px;
      background: #eef3f8;
      overflow-y: auto;
    }

    .header-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }
    .header-actions h1 {
      font-size: 1.8rem;
      color: #0b2f52;
    }
    .btn-primary {
      background: #2563eb;
      color: #fff;
      border: none;
      padding: 10px 18px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: 0.3s;
    }
    .btn-primary:hover { background: #1e4bb3; }

    /* Botones de categoría */
    .category-buttons {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-bottom: 20px;
    }
    .category-buttons button {
      background: #fff;
      border: 1px solid #2563eb;
      color: #2563eb;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: 0.3s;
    }
    .category-buttons button.active,
    .category-buttons button:hover {
      background: #2563eb;
      color: #fff;
    }

    /* Filtros */
    .filters {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      background: #fff;
      padding: 12px;
      border-radius: 10px;
      margin-bottom: 20px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    }
    .filters input {
      padding: 8px 12px;
      border: 1px solid #ccc;
      border-radius: 8px;
    }

    /* Tabla */
    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 14px;
      border-bottom: 1px solid #e6e6e6;
    }
    th {
      background: #f5f6fa;
      font-weight: 600;
      color: #333;
    }
    tr:hover { background: #f9f9ff; }
    .actions button {
      padding: 6px 12px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 500;
    }
    .btn-edit { background: #0b63f3; color: #fff; }
    .btn-disable { background: #dc2626; color: #fff; }

    /* Modal */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(15,23,42,0.55);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal {
      background: #fff;
      width: 450px;
      border-radius: 12px;
      box-shadow: 0 12px 40px rgba(0,0,0,0.25);
      padding: 30px;
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from {opacity: 0; transform: translateY(-10px);}
      to {opacity: 1; transform: translateY(0);}
    }
    .modal h2 {
      margin: 0 0 16px 0;
      color: #1e3a8a;
    }
    .form-group {
      margin-bottom: 14px;
    }
    .form-group label {
      display: block;
      font-weight: 600;
      margin-bottom: 6px;
    }
    .form-group input, .form-group textarea, .form-group select {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 8px;
    }
    .modal-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 10px;
    }
    .btn-secondary {
      background: #ccc;
      color: #333;
      border: none;
      padding: 8px 16px;
      border-radius: 8px;
    }
  </style>
</head>
<body>

<div class="app">
  <jsp:include page="sidebar-admin.jsp" />

  <main class="main">
    <div class="header-actions">
      <h1>Gestión de Útiles Escolares</h1>
      <button class="btn-primary" id="btnOpenModal">+ Nuevo Útil</button>
    </div>

    <!-- Botones dinámicos -->
    <div class="category-buttons" id="categoryButtons">
      <button class="active" onclick="mostrarCategoria('general')">General</button>
      <%-- Aquí se generan dinámicamente los grados desde el backend --%>
      <%
        // Ejemplo dinámico con tu lista de grados
        // for (Grado g : gradosList) {
      %>
        <button onclick="mostrarCategoria('1')">1er Grado</button>
        <button onclick="mostrarCategoria('2')">2do Grado</button>
      <%-- } --%>
    </div>

    <!-- Filtros -->
    <div class="filters">
      <input type="text" id="buscarNombre" placeholder="Buscar útil escolar...">
      <button class="btn-primary" id="btnFiltrar">Buscar</button>
    </div>

    <!-- Tabla general -->
    <table id="tablaGeneral">
      <thead>
        <tr>
          <th>#</th>
          <th>Nombre</th>
          <th>Descripción</th>
          <th>Activo</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>1</td>
          <td>Cuaderno cuadriculado</td>
          <td>Cuaderno tamaño A4 para matemáticas</td>
          <td>Sí</td>
          <td class="actions">
            <button class="btn-edit">Editar</button>
            <button class="btn-disable">Inhabilitar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </main>
</div>
    <div class="pagination">
  <c:forEach var="i" begin="1" end="${totalPaginas}">
    <c:choose>
      <c:when test="${i == paginaActual}">
        <button class="active">${i}</button>
      </c:when>
      <c:otherwise>
        <form action="UtilEscolarController" method="get" style="display:inline;">
          <input type="hidden" name="accion" value="listar">
          <input type="hidden" name="pagina" value="${i}">
          <button type="submit">${i}</button>
        </form>
      </c:otherwise>
    </c:choose>
  </c:forEach>
</div>

<!-- Modal Crear Útil -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal">
    <h2>Nuevo Útil Escolar</h2>
    <form id="formUtil">
      <div class="form-group">
        <label>Nombre</label>
        <input type="text" id="nombreUtil" required>
      </div>
      <div class="form-group">
        <label>Descripción</label>
        <textarea id="descripcionUtil" rows="3" required></textarea>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
        <button type="submit" class="btn-primary">Guardar</button>
      </div>
    </form>
  </div>
</div>

<script>
  // Abrir y cerrar modal
  const btnOpen = document.getElementById('btnOpenModal');
  const btnCancel = document.getElementById('btnCancelar');
  const modal = document.getElementById('modalOverlay');

  btnOpen.addEventListener('click', () => modal.style.display = 'flex');
  btnCancel.addEventListener('click', () => modal.style.display = 'none');
  modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });

  // Filtrar (simulado)
  document.getElementById('btnFiltrar').addEventListener('click', () => {
    const nombre = document.getElementById('buscarNombre').value;
    alert("Filtrando útiles por: " + nombre);
  });

  // Cambiar categoría
  function mostrarCategoria(cat) {
    document.querySelectorAll('.category-buttons button').forEach(b => b.classList.remove('active'));
    event.target.classList.add('active');
    alert("Mostrando útiles de: " + cat);
  }
</script>

</body>
</html>
