<%-- 
    Document   : admin-tarifa
    Created on : 19 oct. 2025, 12:21:06 a. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Tarifas</title>
  <style>
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
      
    .header {
      display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;
    }

    

    .btn {
      background: #007bff;
      color: #fff;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.95rem;
      transition: 0.3s;
    }
    
    .tabs-btn {
      padding:8px 14px; border:none; border-radius:8px; background:#e2e8f0;
      cursor:pointer; font-weight:600;
    }
    .tabs-btn.active { background:#2563eb; color:#fff; }

    .btn-primary {
      background:#2563eb; color:#fff; border:none; border-radius:8px; padding:8px 12px; cursor:pointer;
    }
    .btn-primary:hover { background:#1e40af; }

    .filters {
      display:flex; gap:10px; margin-bottom:15px; margin-top:15px;
    }

    select, input[type="number"], input[type="text"] {
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 0.9rem;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      border-radius: 8px;
      overflow: hidden;
    }

    th, td {
      padding: 10px 12px;
      text-align: left;
      border-bottom: 1px solid #e6e6e6;
    }

    th {
      background: #f1f3f5;
      font-weight: 600;
    }

    td:last-child {
      text-align: center;
    }

    .badge {
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 500;
      color: #fff;
    }

    .badge.active { background: #28a745; }
    .badge.inactive { background: #dc3545; }

    /* MODALES */
    .modal {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.45);
      justify-content: center;
      align-items: center;
      z-index: 999;
    }

    .modal-content {
      background: #fff;
      padding: 20px;
      border-radius: 10px;
      width: 600px;
      max-width: 95%;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
      animation: fadeIn 0.25s ease-in-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: scale(0.95); }
      to { opacity: 1; transform: scale(1); }
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }

    .modal-header h2 {
      font-size: 1.2rem;
    }

    .close {
      font-size: 1.3rem;
      cursor: pointer;
      color: #888;
    }

    .form-row {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;
    }

    .form-group {
      margin-bottom: 12px;
    }

    label {
      display: block;
      font-weight: 500;
      margin-bottom: 4px;
    }

    .modal-actions {
      text-align: right;
      margin-top: 10px;
    }
  </style>
</head>
<body>
    <div class="app">
        <jsp:include page="sidebar-admin.jsp" />
  <main class="main">
    <div class="header">
      <h1>Gestión de Tarifas</h1>
     </div>
      <div class="tabs">
        <button class="btn-primary" id="btn-add-tarifa">Agregar Tarifa</button>
        <button class="btn-primary" id="btn-conceptos">Conceptos de Pago</button>
        <button class="btn-primary" id="btn-periocidad">Periocidad</button>
      </div>
    

    <div class="filters">
      <select id="filtro-anio">
        <option value="">Año escolar actual</option>
      </select>

      <select id="filtro-grado">
        <option value="">Grado</option>
        <option>1° Primaria</option>
        <option>2° Primaria</option>
      </select>

      <select id="filtro-estado">
        <option value="">Estado</option>
        <option value="1">Activo</option>
        <option value="0">Inactivo</option>
      </select>

      <button class="btn">Filtrar</button>
    </div>

    <table>
      <thead>
        <tr>
          <th>Año</th>
          <th>Grado</th>
          <th>Concepto</th>
          <th>Monto Total (S/)</th>
          <th>Cuotas</th>
          <th>Monto x Cuota</th>
          <th>Activo</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody id="tabla-tarifas">
        <tr>
          <td>2025</td>
          <td>1° Primaria</td>
          <td>Matrícula</td>
          <td>200.00</td>
          <td>1</td>
          <td>200.00</td>
          <td><span class="badge active">Activo</span></td>
          <td><button class="btn btn-secondary">Editar</button></td>
        </tr>
      </tbody>
    </table>
  </main>
 </div>

  <!-- MODAL CREAR TARIFA -->
  <div class="modal" id="modal-tarifa">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Registrar Tarifa</h2>
        <span class="close" onclick="cerrarModal('modal-tarifa')">&times;</span>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Año Escolar</label>
          <input type="number" id="anio-escolar" readonly>
        </div>
        <div class="form-group">
          <label>Grado</label>
          <select id="grado">
            <option>1° Primaria</option>
            <option>2° Primaria</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Concepto de Pago</label>
          <select id="concepto">
            <option>Matrícula</option>
            <option>Mensualidad</option>
            <option>Cuota de aniversario</option>
          </select>
        </div>
        <div class="form-group">
          <label>Activo</label>
          <select id="activo">
            <option value="1">Sí</option>
            <option value="0">No</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Monto Total (S/)</label>
          <input type="number" id="monto-total" step="0.01">
        </div>
        <div class="form-group">
          <label>Cuotas</label>
          <input type="number" id="cuotas" min="1" max="12" value="1">
        </div>
      </div>

      <div class="form-group">
        <label>Monto por Cuota (S/)</label>
        <input type="number" id="monto-cuota" step="0.01" readonly>
      </div>

      <div class="modal-actions">
        <button class="btn-secondary" onclick="cerrarModal('modal-tarifa')">Cancelar</button>
        <button class="btn">Guardar</button>
      </div>
    </div>
  </div>

  <!-- MODAL CONCEPTOS -->
  <div class="modal" id="modal-conceptos">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Conceptos de Pago</h2>
        <span class="close" onclick="cerrarModal('modal-conceptos')">&times;</span>
      </div>
      <table>
        <thead>
          <tr>
            <th>Nombre</th>
            <th>Descripción</th>
            <th>Periocidad</th>
            <th>Activo</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody id="tabla-conceptos">
          <tr>
            <td>Matrícula</td>
            <td>Pago por inscripción anual</td>
            <td>Pago único</td>
            <td><span class="badge active">Activo</span></td>
            <td><button class="btn btn-secondary">Inhabilitar</button></td>
          </tr>
        </tbody>
      </table>
      <div class="modal-actions">
        <button class="btn" onclick="abrirModal('modal-nuevo-concepto')">Nuevo Concepto</button>
      </div>
    </div>
  </div>

  <!-- MODAL NUEVO CONCEPTO -->
  <div class="modal" id="modal-nuevo-concepto">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Nuevo Concepto de Pago</h2>
        <span class="close" onclick="cerrarModal('modal-nuevo-concepto')">&times;</span>
      </div>

      <div class="form-group">
        <label>Nombre del Concepto</label>
        <input type="text" id="nombre-concepto">
      </div>

      <div class="form-group">
        <label>Descripción</label>
        <input type="text" id="descripcion-concepto">
      </div>

      <div class="form-group">
        <label>Periocidad</label>
        <select id="periocidad-concepto">
          <option>Pago único</option>
          <option>Mensual</option>
          <option>Bimestral</option>
        </select>
      </div>

      <div class="modal-actions">
        <button class="btn-secondary" onclick="cerrarModal('modal-nuevo-concepto')">Cancelar</button>
        <button class="btn">Guardar</button>
      </div>
    </div>
  </div>

  <script>
    // Carga automática del año actual
    document.getElementById("anio-escolar").value = new Date().getFullYear();
    document.getElementById("filtro-anio").innerHTML = `<option>2025</option>`;

    // Modal handlers
    document.getElementById('btn-add-tarifa').onclick = () => abrirModal('modal-tarifa');
    document.getElementById('btn-conceptos').onclick = () => abrirModal('modal-conceptos');

    function abrirModal(id) {
      document.getElementById(id).style.display = "flex";
    }

    function cerrarModal(id) {
      document.getElementById(id).style.display = "none";
    }

    // Cálculo automático de monto por cuota
    const total = document.getElementById('monto-total');
    const cuotas = document.getElementById('cuotas');
    const montoCuota = document.getElementById('monto-cuota');

    total.addEventListener('input', calcular);
    cuotas.addEventListener('input', calcular);

    function calcular() {
      const t = parseFloat(total.value) || 0;
      const c = parseInt(cuotas.value) || 1;
      montoCuota.value = (t / c).toFixed(2);
    }

    // Cerrar modal al hacer clic fuera
    window.onclick = (e) => {
      document.querySelectorAll('.modal').forEach(m => {
        if (e.target === m) m.style.display = "none";
      });
    };
  </script>
</body>
</html>
