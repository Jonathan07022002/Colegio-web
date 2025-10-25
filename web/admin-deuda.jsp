<%-- 
    Document   : admin-deuda
    Created on : 19 oct. 2025, 1:33:15 a. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Deudas</title>
  <style>
    html, body { margin:0; padding:0; height:100%; width:100%; overflow:hidden; }
    .app { display:grid; grid-template-columns:270px 1fr; height:100vh; width:100vw; }
    .main { padding:24px; background:#eef3f8; overflow-y:auto; }

    h1 { font-size:1.6rem; font-weight:700; color:#1e293b; margin-bottom:1rem; }

    .filter-box {
      display:flex; gap:12px; flex-wrap:wrap; margin-bottom:16px;
    }
    select, input[type="text"] {
      padding:8px 12px; border-radius:8px; border:1px solid #cbd5e1; background:#fff; font-size:0.95rem;
    }
    .btn-primary {
      background:#2563eb; color:#fff; border:none; border-radius:8px; padding:8px 14px; cursor:pointer; font-weight:600;
    }
    .btn-primary:hover { background:#1e40af; }

    table { width:100%; border-collapse:collapse; background:#fff; border-radius:10px; overflow:hidden; }
    th, td { padding:10px 14px; border-bottom:1px solid #e5e7eb; text-align:left; font-size:0.93rem; }
    th { background:#f3f4f6; font-weight:600; }

    .actions button { padding:6px 10px; border:none; border-radius:6px; color:#fff; cursor:pointer; font-size:0.85rem; }
    .btn-view { background:#0284c7; }
    .btn-view:hover { background:#0369a1; }

    /* MODAL */
    .modal-overlay {
      display:none; position:fixed; top:0; left:0; width:100%; height:100%;
      background:rgba(0,0,0,0.55); justify-content:center; align-items:center; z-index:1000;
    }
    .modal {
      background:#fff; border-radius:14px; width:700px; padding:24px; animation:fadeIn .3s ease;
      box-shadow:0 10px 25px rgba(0,0,0,0.2);
    }
    @keyframes fadeIn { from{opacity:0; transform:translateY(-10px);} to{opacity:1; transform:translateY(0);} }
    .modal h2 { margin-bottom:10px; color:#1e293b; font-size:1.4rem; }
    .deuda-header {
      background:#f1f5f9; padding:10px 14px; border-radius:10px; margin-bottom:16px;
      display:flex; justify-content:space-between; align-items:center;
    }
    .total-deuda {
      font-size:1.1rem; font-weight:700; color:#dc2626;
    }
    .estado-btn {
      padding:6px 10px; border-radius:6px; font-weight:600; cursor:pointer; border:none;
    }
    .pendiente { background:#dc2626; color:#fff; }
    .pagado { background:#16a34a; color:#fff; }
    .prorroga { background:#eab308; color:#fff; }

    .modal-footer { text-align:right; margin-top:14px; }
    .modal-footer button { margin-left:8px; }
  </style>
</head>
<body id="page-users">
<div class="app">
  <jsp:include page="sidebar-admin.jsp" />

  <main class="main">
    <h1>Gestión de Deudas</h1>

    <!-- FILTROS -->
    <div class="filter-box">
      <select id="filtro-grado"><option value="">Grado</option></select>
      <select id="filtro-seccion"><option value="">Sección</option></select>
      <input type="text" id="filtro-dni" placeholder="DNI">
      <input type="text" id="filtro-nombre" placeholder="Nombre del estudiante">
      <button class="btn-primary" onclick="buscarDeudas()">Buscar</button>
    </div>

    <!-- TABLA DE ESTUDIANTES -->
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>DNI</th>
          <th>Nombre completo</th>
          <th>Grado</th>
          <th>Sección</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody id="tabla-estudiantes">
        <tr>
          <td>1</td>
          <td>12345678</td>
          <td>Balcázar Palacios, Piero Mathias</td>
          <td>5°</td>
          <td>A</td>
          <td><button class="btn-view" onclick="verDeuda('12345678')">Ver deuda</button></td>
        </tr>
      </tbody>
    </table>
  </main>
</div>

<!-- MODAL DE DEUDA -->
<div class="modal-overlay" id="modalDeuda">
  <div class="modal">
    <h2>Detalle de Deuda - <span id="deuda-nombre"></span></h2>
    <div class="deuda-header">
      <span>Año escolar: <strong id="deuda-anio">2025</strong></span>
      <span class="total-deuda">Deuda total: S/ <span id="deuda-total">0.00</span></span>
    </div>

    <table>
      <thead>
        <tr>
          <th>Concepto</th>
          <th>Detalle</th>
          <th>Monto (S/)</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody id="tabla-deudas">
        <!-- Se llenará dinámicamente -->
      </tbody>
    </table>

    <div class="modal-footer">
      <button class="btn-primary" style="background:#475569;" onclick="cerrarModal()">Cerrar</button>
    </div>
  </div>
</div>

<script>
  // FILTRO FLEXIBLE
  function buscarDeudas() {
    const grado = document.getElementById('filtro-grado').value.trim();
    const seccion = document.getElementById('filtro-seccion').value.trim();
    const dni = document.getElementById('filtro-dni').value.trim();
    const nombre = document.getElementById('filtro-nombre').value.trim();

    alert(`Buscando deudas según los filtros:\nGrado: ${grado}\nSección: ${seccion}\nDNI: ${dni}\nNombre: ${nombre}`);
    // fetch('DeudaController?accion=listar&grado=...') ...
  }

  // VER DEUDA DE ALUMNO
  function verDeuda(dni) {
    document.getElementById('modalDeuda').style.display = 'flex';
    document.getElementById('deuda-nombre').textContent = "Piero Mathias Balcázar";
    document.getElementById('deuda-anio').textContent = new Date().getFullYear();

    // Simulación de deuda (esto se generaría desde las tarifas configuradas)
    const deudas = [
      { concepto: "Matrícula", detalle: "Pago único", monto: 150, estado: "Pagado" },
      { concepto: "Mensualidad 1", detalle: "Enero", monto: 100, estado: "Pendiente" },
      { concepto: "Mensualidad 2", detalle: "Febrero", monto: 100, estado: "Pendiente" },
      { concepto: "Mensualidad 3", detalle: "Marzo", monto: 100, estado: "Prórroga" },
    ];

    const tbody = document.getElementById('tabla-deudas');
    tbody.innerHTML = "";
    let total = 0;
    deudas.forEach(d => {
      total += d.estado === "Pagado" ? 0 : d.monto;
      const clase =
        d.estado === "Pendiente" ? "pendiente" :
        d.estado === "Pagado" ? "pagado" : "prorroga";

      tbody.innerHTML += `
        <tr>
          <td>${d.concepto}</td>
          <td>${d.detalle}</td>
          <td>${d.monto.toFixed(2)}</td>
          <td><button class="estado-btn ${clase}">${d.estado}</button></td>
          <td><button class="btn-primary" onclick="cambiarEstado(this)">Actualizar</button></td>
        </tr>`;
    });

    document.getElementById('deuda-total').textContent = total.toFixed(2);
  }

  function cerrarModal() {
    document.getElementById('modalDeuda').style.display = 'none';
  }

  // CAMBIAR ESTADO DE PAGO (Simulación)
  function cambiarEstado(btn) {
    const estadoBtn = btn.parentNode.parentNode.querySelector('.estado-btn');
    const actual = estadoBtn.textContent;
    const nuevo = actual === "Pendiente" ? "Pagado" :
                  actual === "Pagado" ? "Prórroga" : "Pendiente";
    estadoBtn.textContent = nuevo;
    estadoBtn.className = "estado-btn " + (nuevo === "Pendiente" ? "pendiente" : nuevo === "Pagado" ? "pagado" : "prorroga");
    recalcularTotal();
  }

  // Actualiza total cuando cambian estados
  function recalcularTotal() {
    let total = 0;
    document.querySelectorAll('#tabla-deudas tr').forEach(row => {
      const monto = parseFloat(row.children[2].textContent);
      const estado = row.children[3].innerText;
      if (estado === "Pendiente" || estado === "Prórroga") total += monto;
    });
    document.getElementById('deuda-total').textContent = total.toFixed(2);
  }
</script>
</body>
</html>

