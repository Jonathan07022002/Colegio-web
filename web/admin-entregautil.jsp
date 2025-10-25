<%-- 
    Document   : admi-entregautil
    Created on : 18 oct. 2025, 12:20:55 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Entrega de Útiles</title>
  <style>
     /* Usa tu estilo base general */
     html, body {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
        overflow: hidden; /* evita scroll si no es necesario */
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
    /* Ajustes específicos */
    .filters { display: flex; gap: 10px; margin-bottom: 20px; }
    select, button {
      padding: 8px 12px;
      border-radius: 8px;
      border: 1px solid #ccc;
      outline: none;
    }
    button { cursor: pointer; }
    .btn-primary { background: #2563eb; color: white; border: none; }
    .btn-primary:hover { background: #1e40af; }

    table { width: 100%; background: #fff; border-collapse: collapse; border-radius: 8px; }
    th, td { padding: 12px; border-bottom: 1px solid #e5e7eb; }
    th { background: #f3f4f6; color: #374151; text-align: left; }

    .actions button {
      padding: 6px 10px;
      border-radius: 6px;
      border: none;
      font-weight: 500;
    }
    .btn-view { background: #1d4ed8; color: #fff; }
    .btn-view:hover { background: #1e40af; }

    /* Modal */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.6);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal {
      background: #fff;
      width: 700px;
      border-radius: 12px;
      padding: 28px;
      box-shadow: 0 12px 40px rgba(0,0,0,0.3);
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from {opacity:0; transform: translateY(-10px);}
      to {opacity:1; transform: translateY(0);}
    }
    .modal h2 { color: #1e3a8a; margin-bottom: 16px; }
    .modal table { margin-top: 10px; width: 100%; border-collapse: collapse; }
    .modal th, .modal td { border-bottom: 1px solid #e5e7eb; padding: 10px; }
    .modal .estado { font-weight: 600; }

    .btn-entregado { background: #16a34a; color: #fff; }
    .btn-falta { background: #dc2626; color: #fff; }
    .btn-parcial { background: #f59e0b; color: #fff; }

    .btn-entregado:hover { background: #15803d; }
    .btn-falta:hover { background: #b91c1c; }
    .btn-parcial:hover { background: #d97706; }
  </style>
</head>
<body>
  <div class="app">
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <div class="header-actions">
        <h1>Gestión de Entrega de Útiles</h1>
      </div>

      <!-- FILTROS -->
      <div class="filters">
        <select id="grado">
          <option value="">Seleccione grado</option>
          <%-- aquí se llenan grados dinámicamente desde el servlet --%>
        </select>
        <select id="seccion">
          <option value="">Seleccione sección</option>
          <%-- secciones dinámicas --%>
        </select>
        <button class="btn-primary" id="btnBuscar">Buscar alumnos</button>
      </div>

      <!-- TABLA ALUMNOS -->
      <table id="tablaAlumnos">
        <thead>
          <tr>
            <th>#</th>
            <th>DNI</th>
            <th>Nombre Completo</th>
            <th>Grado</th>
            <th>Sección</th>
            <th>Acción</th>
          </tr>
        </thead>
        <tbody>
          <%-- generado dinámicamente --%>
          <tr>
            <td>1</td>
            <td>12345678</td>
            <td>Juan Pérez Díaz</td>
            <td>1er Grado</td>
            <td>A</td>
            <td><button class="btn-view" onclick="verEntrega(1)">Ver Entrega</button></td>
          </tr>
        </tbody>
      </table>
    </main>
  </div>

  <!-- MODAL -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <h2>Entrega de Útiles - <span id="nombreAlumno"></span></h2>
      <table>
        <thead>
          <tr>
            <th>Útil Escolar</th>
            <th>Cantidad</th>
            <th>Estado</th>
            <th>Acción</th>
          </tr>
        </thead>
        <tbody id="tablaUtiles">
          <!-- Datos dinámicos -->
        </tbody>
      </table>
      <div class="modal-actions" style="text-align:right; margin-top:15px;">
        <button class="btn-primary" onclick="cerrarModal()">Cerrar</button>
      </div>
    </div>
  </div>

  <script>
    const modal = document.getElementById('modalOverlay');
    const tablaUtiles = document.getElementById('tablaUtiles');

    function verEntrega(idAlumno) {
      modal.style.display = 'flex';
      document.getElementById('nombreAlumno').textContent = 'Juan Pérez Díaz'; // dinámico luego

      // Simulación de datos (esto vendrá del servlet vía fetch)
      const utiles = [
        {nombre: 'Cuaderno rayado', cantidad: 3, estado: 'Falta'},
        {nombre: 'Lápiz HB', cantidad: 2, estado: 'Entregado'},
        {nombre: 'Regla 30cm', cantidad: 1, estado: 'Parcial'}
      ];

      tablaUtiles.innerHTML = '';
      utiles.forEach(u => {
        tablaUtiles.innerHTML += `
          <tr>
            <td>${u.nombre}</td>
            <td>${u.cantidad}</td>
            <td class="estado">${u.estado}</td>
            <td>
              <button class="btn-entregado" onclick="cambiarEstado(this, 'Entregado')">Entregado</button>
              <button class="btn-falta" onclick="cambiarEstado(this, 'Falta')">Falta</button>
              <button class="btn-parcial" onclick="cambiarEstado(this, 'Parcial')">Parcial</button>
            </td>
          </tr>
        `;
      });
    }

    function cambiarEstado(btn, estado) {
      const fila = btn.closest('tr');
      fila.querySelector('.estado').textContent = estado;
      // Aquí podrías enviar al servlet para actualizar en BD:
      // fetch('EntregaUtilController?accion=actualizarEstado', { method:'POST', body: JSON.stringify({...}) })
    }

    function cerrarModal() {
      modal.style.display = 'none';
    }

    modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });
  </script>
</body>
</html>

