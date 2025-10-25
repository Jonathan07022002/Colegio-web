<%-- 
    Document   : admin-nota
    Created on : 18 oct. 2025, 2:33:59 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Notas</title>
  <style>
    html, body { margin:0; padding:0; height:100%; width:100%; overflow:hidden; }
    .app { display:grid; grid-template-columns:270px 1fr; height:100vh; width:100vw; }
    .main { padding:24px; background:#eef3f8; overflow-y:auto; }
    .tabs { display:flex; gap:8px; margin-bottom:16px; }
    .tab-btn {
      padding:8px 14px; border:none; border-radius:8px; background:#e2e8f0;
      cursor:pointer; font-weight:600;
    }
    .tab-btn.active { background:#2563eb; color:#fff; }
    table { width:100%; border-collapse:collapse; background:#fff; border-radius:10px; overflow:hidden; }
    th, td { padding:10px 14px; border-bottom:1px solid #e5e7eb; text-align:left; }
    th { background:#f3f4f6; }
    .header-actions { display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem; }
    .btn-primary {
      background:#2563eb; color:#fff; border:none; border-radius:8px; padding:8px 12px; cursor:pointer;
    }
    .btn-primary:hover { background:#1e40af; }
    .actions button { padding:6px 10px; border:none; border-radius:6px; color:#fff; cursor:pointer; }
    .btn-view { background:#0284c7; }
    .btn-view:hover { background:#0369a1; }
    .btn-edit { background:#16a34a; }
    .btn-edit:hover { background:#15803d; }
    .filter-box { display:flex; gap:10px; margin-bottom:15px; }
    select { padding:6px 10px; border-radius:6px; border:1px solid #ccc; }

    /* MODALES */
    .modal-overlay {
      display:none; position:fixed; top:0; left:0; width:100%; height:100%;
      background:rgba(0,0,0,0.5); justify-content:center; align-items:center; z-index:1000;
    }
    .modal {
      background:#fff; border-radius:12px; width:550px; padding:20px; animation:fadeIn .3s ease;
    }
    @keyframes fadeIn { from{opacity:0; transform:translateY(-10px);} to{opacity:1; transform:translateY(0);} }
    .modal h2 { margin-bottom:10px; }
    .modal input, .modal textarea {
      width:100%; padding:8px; border:1px solid #ccc; border-radius:8px; margin-bottom:10px;
    }
    .modal button { margin-right:8px; }
  </style>
</head>
<body id="page-users">
<div class="app">
  <jsp:include page="sidebar-admin.jsp" />

  <main class="main">
    <div class="header-actions">
      <h1>Gestión de Notas</h1>
    </div>

    <!-- BOTONES DE TABS -->
    <div class="tabs">
      <button class="btn-primary" onclick="abrirModalEscalas()">Escala de Notas</button>
       <button class="btn-primary" onclick="abrirModalConceptos()">Conceptos de Nota</button>
    </div>

    <!-- TAB 1: GESTIÓN DE NOTAS -->
    <div id="tab-notas">
      <div class="filter-box">
        <select id="filtro-grado"><option>Grado</option></select>
        <select id="filtro-seccion"><option>Sección</option></select>
        <select id="filtro-turno"><option>Turno</option></select>
        <button class="btn-primary" onclick="buscarAlumnos()">Buscar</button>
      </div>

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
        <tbody id="tabla-alumnos">
          <!-- Se cargan desde servlet -->
        </tbody>
      </table>
    </div>

    
  </main>
</div>

<!-- MODAL ESCALA DE NOTAS -->
<div class="modal-overlay" id="modalEscalas">
  <div class="modal">
    <h2>Escala de Notas</h2>
    <table>
      <thead><tr><th>Código</th><th>Descripción</th><th>Estado</th><th>Acción</th></tr></thead>
      <tbody id="tabla-escalas">
        <!-- Se llena desde servlet -->
        <tr><td>AD</td><td>Excelente</td><td>Activo</td><td><button class="btn-edit">Inhabilitar</button></td></tr>
      </tbody>
    </table>
    <h3 style="margin-top:10px;">Agregar Nueva Escala</h3>
    <input type="text" id="escala-codigo" placeholder="Código (AD, A, B, C)">
    <input type="text" id="escala-desc" placeholder="Descripción">
    <div style="text-align:right;">
      <button class="btn-primary" onclick="guardarEscala()">Guardar</button>
      <button class="btn-primary" onclick="cerrarModal('modalEscalas')">Cerrar</button>
    </div>
  </div>
</div>

<!-- MODAL CONCEPTOS -->
<div class="modal-overlay" id="modalConceptos">
  <div class="modal">
    <h2>Conceptos de Nota</h2>
    <table>
      <thead><tr><th>Nombre</th><th>Descripción</th><th>Acción</th></tr></thead>
      <tbody id="tabla-conceptos">
        <tr><td>Bimestral</td><td>Evaluación por bimestre</td><td><button  class="btn-edit">Eliminar</button></td></tr>
      </tbody>
    </table>
    <h3 style="margin-top:10px;">Agregar Nuevo Concepto</h3>
    <input type="text" id="concepto-nombre" placeholder="Nombre (Bimestral, Semanal...)">
    <textarea id="concepto-desc" placeholder="Descripción"></textarea>
    <div style="text-align:right;">
      <button class="btn-primary" onclick="guardarConcepto()">Guardar</button>
      <button class="btn-primary" onclick="cerrarModal('modalConceptos')">Cerrar</button>
    </div>
  </div>
</div>

<script>
  const tabNotas = document.getElementById('tab-notas');
  const tabConfig = document.getElementById('tab-config');
  const btns = document.querySelectorAll('.tab-btn');

  function mostrarTab(tab) {
    btns.forEach(b => b.classList.remove('active'));
    if (tab === 'notas') {
      tabNotas.style.display = 'block';
      tabConfig.style.display = 'none';
      btns[0].classList.add('active');
    } else {
      tabNotas.style.display = 'none';
      tabConfig.style.display = 'block';
      btns[1].classList.add('active');
    }
  }

  function abrirModalEscalas() {
    document.getElementById('modalEscalas').style.display = 'flex';
  }
  function abrirModalConceptos() {
    document.getElementById('modalConceptos').style.display = 'flex';
  }
  function cerrarModal(id) {
    document.getElementById(id).style.display = 'none';
  }

  function buscarAlumnos() {
    // fetch('NotaController?accion=listar&grado=...') etc.
    const tbody = document.getElementById('tabla-alumnos');
    tbody.innerHTML = `
      <tr>
        <td>1</td><td>12345678</td><td>Balcazar Palacios, Piero Mathias</td>
        <td>5°</td><td>A</td>
        <td><button class="btn-primary" onclick="verNota()">Ver Nota</button></td>
      </tr>`;
  }

  function verNota() {
    window.location.href = 'boleta-nota.jsp';
  }

  function guardarEscala() {
    const cod = document.getElementById('escala-codigo').value.trim();
    const desc = document.getElementById('escala-desc').value.trim();
    if (!cod || !desc) return alert('Complete los campos');
    alert(`Guardando escala: ${cod} - ${desc}`);
    // fetch('NotaController?accion=guardarEscala', {...})
  }

  function guardarConcepto() {
    const nom = document.getElementById('concepto-nombre').value.trim();
    const desc = document.getElementById('concepto-desc').value.trim();
    if (!nom || !desc) return alert('Complete los campos');
    alert(`Guardando concepto: ${nom} - ${desc}`);
    // fetch('NotaController?accion=guardarConcepto', {...})
  }
</script>
</body>
</html>

