<%-- 
    Document   : admin-apoderado
    Created on : 18 oct. 2025, 12:52:58 a. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Apoderados</title>
  <style>
    /* ========== Baseline (coincide con tu estilo) ========== */
    html, body { margin:0; padding:0; height:100%; width:100%; overflow:hidden; }
    .app { display: grid; grid-template-columns: 270px 1fr; height:100vh; width:100vw; }
    .main { padding:24px; background:#eef3f8; min-height:100vh; overflow-y:auto; }

    .header-actions { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
    .header-actions h1 { font-size:1.8rem; color:#0b2f52; }

    .btn-primary { background:#2563eb; color:#fff; border:none; padding:10px 18px; border-radius:8px; cursor:pointer; font-weight:500; transition:0.2s; }
    .btn-primary:hover { background:#1d4ed8; }

    /* tabs */
    .tabs { display:flex; gap:8px; margin-bottom:16px; }
    .tab { padding:8px 14px; border-radius:8px; background:#f5f6fa; cursor:pointer; font-weight:600; border:none; }
    .tab.active { background:#2563eb; color:#fff; }

    /* filtros */
    .filters { display:flex; gap:10px; flex-wrap:wrap; background:#fff; padding:14px; border-radius:10px; box-shadow:0 1px 4px rgba(0,0,0,0.08); margin-bottom:18px; align-items:center; }
    .filters input, .filters select { padding:8px 12px; border:1px solid #d1d5db; border-radius:8px; outline:none; }

    /* tabla */
    table { width:100%; border-collapse:collapse; background:#fff; border-radius:10px; overflow:hidden; box-shadow:0 2px 6px rgba(0,0,0,0.08); }
    th, td { padding:12px 14px; border-bottom:1px solid #e6e6e6; text-align:left; vertical-align:middle; }
    th { background:#f5f6fa; color:#333; font-weight:600; }
    tr.row-child { background:#fbfdff; }
    .actions button { padding:6px 10px; border:none; border-radius:6px; cursor:pointer; font-weight:500; margin-right:6px; }
    .btn-view { background:#06b6d4; color:#fff; } /* cyan */
    .btn-add { background:#10b981; color:#fff; }  /* green */
    .btn-disable { background:#ef4444; color:#fff; } /* red */

    /* modal (reutilizable) */
    .modal-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(15,23,42,0.55); justify-content:center; align-items:center; z-index:1000; backdrop-filter:blur(3px); }
    .modal { background:#fff; width:680px; max-width:95%; border-radius:12px; padding:28px; box-shadow:0 12px 40px rgba(0,0,0,0.25); }
    .modal h2 { margin:0 0 14px 0; color:#1e3a8a; border-bottom:2px solid #2563eb; padding-bottom:8px; }
    .form-grid { display:grid; grid-template-columns:repeat(2, minmax(0,1fr)); gap:16px 18px; }
    .form-group label{ display:block; margin-bottom:6px; color:#1f2937; font-weight:600; }
    .form-group input, .form-group select { width:100%; padding:10px 12px; border-radius:8px; border:1px solid #cbd5e1; outline:none; background:#f9fafb; }
    .modal-actions { display:flex; justify-content:flex-end; gap:12px; margin-top:20px; }

    .badge { padding:6px 10px; border-radius:999px; font-weight:600; font-size:0.85rem; }
    .badge.active { background:#10b981; color:#fff; }
    .badge.inactive { background:#94a3b8; color:#fff; }

    /* small helpers */
    .small { font-size:0.9rem; color:#555; }
    .children-table { margin-top:8px; margin-bottom:8px; border-top:1px dashed #e6e6e6; }
  </style>
</head>
<body>
  <div class="app">
    <%-- include sidebar (ajusta ruta si es necesario) --%>
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <div class="header-actions">
        <h1>Gestión de apoderados</h1>
      </div>

      <div class="tabs">
        <button class="tab active" data-tab="tab-apoderados">Apoderados</button>
        <button class="tab" data-tab="tab-parentescos">Parentescos</button>
      </div>

      <!-- ====== TAB APODERADOS ====== -->
      <section id="tab-apoderados" class="tab-content" style="display:block;">
        <div class="filters" style="align-items:center;">
          <input type="text" id="filtroNombreAp" placeholder="Buscar por nombre...">
          <input type="text" id="filtroDniAp" placeholder="Buscar por DNI...">
          <input type="text" id="filtroTelefonoAp" placeholder="Teléfono...">
          <button class="btn-primary" id="btnFiltrarAp">Filtrar</button>
          <div style="margin-left:auto;" class="small">Mostrando apoderados</div>
        </div>

        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>DNI</th>
              <th>Nombre completo</th>
              <th>Fecha Nac.</th>
              <th>Correo</th>
              <th>Teléfono</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody id="tablaApoderados">
            <!-- filas cargadas por JS -->
          </tbody>
        </table>

        <div style="margin-top:12px;" class="small">* Pulsa "Ver" para mostrar/ocultar los hijos del apoderado. "Agregar" abre modal para asociar un hijo existente por DNI.</div>
      </section>

      <!-- ====== TAB PARENTESCOS ====== -->
      <section id="tab-parentescos" class="tab-content" style="display:none;">
        <div class="header-actions" style="margin-bottom:12px;">
          
          <button class="btn-primary" id="btnOpenParentesco">+ Crear Parentesco</button>
        </div>

        <table>
          <thead>
            <tr><th>ID</th><th>Nombre</th><th>Activo</th><th>Acciones</th></tr>
          </thead>
          <tbody id="tablaParentescos">
            <tr><td colspan="4" style="text-align:center;">Cargando...</td></tr>
          </tbody>
        </table>
      </section>
    </main>
  </div>

  <!-- ===== MODAL: Crear Parentesco ===== -->
  <div class="modal-overlay" id="modalParentesco">
    <div class="modal">
      <h2>Nuevo Parentesco</h2>
      <form id="formParentesco" action="ParentescoSVL" method="post">
          <input type="hidden" name="accion" value="agregar"> 
        <div class="form-grid">
          <div class="form-group">
            <label for="nombrePar">Nombre</label>
            <input type="text" id="nombrePar" name="nombre" required>
          </div>
          <div class="form-group">
            <label for="activoPar">Activo</label>
            <select id="activoPar" name="activo">
              <option value="1">Si</option>
              <option value="0">No</option>
            </select>
          </div>
        </div>
        <div class="modal-actions">
          <button type="button" class="btn-secondary" id="btnCancelPar">Cancelar</button>
          <button type="submit" class="btn-primary">Guardar</button>
        </div>
      </form>
    </div>
  </div>

  <!-- ===== MODAL: Agregar hijo a apoderado (buscar por DNI) ===== -->
  <div class="modal-overlay" id="modalAgregarHijo">
    <div class="modal">
      <h2>Agregar Hijo (buscar por DNI)</h2>
      <form id="formBuscarHijo">
        <div class="form-grid">
          <div class="form-group" style="grid-column: span 2;">
            <label for="dniBuscar">DNI del hijo</label>
            <input type="text" id="dniBuscar" maxlength="8" placeholder="Ingrese DNI a buscar" required>
          </div>
          <div id="resultadoBusqueda" style="grid-column: span 2;"></div>
        </div>
        <div class="modal-actions">
          <button type="button" class="btn-secondary" id="btnCancelBuscar">Cancelar</button>
          <button type="submit" class="btn-primary" id="btnAsociarHijo" disabled>Asociar hijo</button>
        </div>
        <input type="hidden" id="apoderadoIdSeleccionado" value="">
        <input type="hidden" id="personaEncontradaId" value="">
      </form>
    </div>
  </div>

<script>
/* ===================== Tabs ===================== */
const tabs = document.querySelectorAll('.tab');
tabs.forEach(t => t.addEventListener('click', () => {
  // Cambiar pestaña visualmente
  tabs.forEach(x => x.classList.remove('active'));
  document.querySelectorAll('.tab-content').forEach(c => c.style.display = 'none');
  t.classList.add('active');
  document.getElementById(t.dataset.tab).style.display = 'block';

  // Si la pestaña presionada es la de parentescos, cargar desde el servlet
  if (t.dataset.tab === 'tab-parentescos') {
    cargarParentescos();
  }
}));

/* ===================== Helpers DOM ===================== */
const tablaApoderados = document.getElementById('tablaApoderados');
const tablaParentescos = document.getElementById('tablaParentescos');
const modalParentesco = document.getElementById('modalParentesco');
const modalAgregarHijo = document.getElementById('modalAgregarHijo');

/* ===================== CARGAR PARENTESCOS ===================== */
function cargarParentescos() {
  const xhr = new XMLHttpRequest();
  xhr.open("GET", "<%= request.getContextPath() %>/ParentescoSVL?accion=listar", true);

  xhr.onload = function () {
    if (xhr.status === 200) {
      // Simplemente insertamos el HTML devuelto
      document.getElementById("tablaParentescos").innerHTML = xhr.responseText;
    } else {
      console.error("Error al cargar parentescos:", xhr.status);
    }
  };

  xhr.onerror = function () {
    console.error("Error de conexión con el servidor");
  };

  xhr.send();
}

// 🔹 Detecta cuando el usuario cambia a la pestaña "Parentescos"
document.addEventListener("DOMContentLoaded", () => {
  const btnParentescos = document.querySelector('button:contains("Parentescos")');

  // Si tienes tabs manejados por clase activa
  const tabParentescos = document.getElementById("tab-parentescos");
  const tabApoderados = document.getElementById("tab-apoderados");

  const tabButtons = document.querySelectorAll("button");

  tabButtons.forEach(btn => {
    btn.addEventListener("click", () => {
      // Espera un pequeño delay para que el contenido se muestre
      setTimeout(() => {
        if (tabParentescos.style.display !== "none") {
          cargarParentescos();
        }
      }, 100);
    });
  });
});

// placeholders
function editarParentesco(id) {
  alert("Editar parentesco ID: " + id);
}

function eliminarParentesco(id) {
  alert("Eliminar parentesco ID: " + id);
}
/* ===================== CARGAR APODERADOS ===================== */
async function cargarApoderados(filtros = {}) {
  try {
    // Construir query string con filtros opcionales
    const qs = new URLSearchParams(filtros).toString();
    const res = await fetch('ApoderadoController?accion=listar' + (qs ? '&' + qs : ''));
    if (!res.ok) throw new Error('No JSON');
    const lista = await res.json();
    renderApoderados(lista);
  } catch (err) {
    // demo local si no hay backend
    const demo = [
      { id:1, dni:'12345678', nombres:'María López', fechaNacimiento:'1980-05-12', correo:'maria@example.com', telefono:'987654321' },
      { id:2, dni:'87654321', nombres:'Carlos Ruiz', fechaNacimiento:'1975-02-20', correo:'carlos@example.com', telefono:'987001122' }
    ];
    renderApoderados(demo);
    console.warn('Apoderados: demo local (ajusta ApoderadoController).', err);
  }
}

function renderApoderados(lista) {
  tablaApoderados.innerHTML = '';
  lista.forEach((a, idx) => {
    const tr = document.createElement('tr');
    tr.dataset.apoderadoId = a.id;
    tr.innerHTML = `
      <td>${idx + 1}</td>
      <td>${a.dni}</td>
      <td>${a.nombres}</td>
      <td>${a.fechaNacimiento || ''}</td>
      <td>${a.correo || ''}</td>
      <td>${a.telefono || ''}</td>
      <td class="actions">
        <button class="btn-view" onclick="toggleChildren(${a.id})">Ver</button>
        <button class="btn-add" onclick="abrirAgregarHijo(${a.id})">Agregar</button>
        <button class="btn-disable" onclick="inhabilitarApoderado(${a.id})">Inhabilitar</button>
      </td>
    `;
    tablaApoderados.appendChild(tr);

    // contenedor para hijos (fila que se mostrará/ocultará)
    const trChildren = document.createElement('tr');
    trChildren.classList.add('row-child');
    trChildren.dataset.childrenFor = a.id;
    trChildren.style.display = 'none';
    trChildren.innerHTML = `<td colspan="7">
      <div class="children-table">
        <table style="width:100%; border-collapse:collapse;">
          <thead>
            <tr style="background:#f8fafc;"><th>Id</th><th>DNI</th><th>Nombre</th><th>Grado</th><th>Sección</th><th>Acciones</th></tr>
          </thead>
          <tbody id="children-body-${a.id}">
            <tr><td colspan="6" class="small">Cargando hijos...</td></tr>
          </tbody>
        </table>
      </div>
    </td>`;
    tablaApoderados.appendChild(trChildren);
  });
}

/* ========== TOGGLE HIJOS (VER) ========== */
async function toggleChildren(apoderadoId) {
  const trChildren = document.querySelector(`tr[data-children-for="${apoderadoId}"]`);
  if (!trChildren) return;
  const body = document.getElementById(`children-body-${apoderadoId}`);

  if (trChildren.style.display === 'none' || trChildren.style.display === '') {
    // mostrar: cargar hijos desde backend
    trChildren.style.display = '';
    try {
      const res = await fetch(`ApoderadoController?accion=hijos&id=${apoderadoId}`);
      if (!res.ok) throw new Error('No JSON');
      const hijos = await res.json();
      body.innerHTML = '';
      if (hijos.length === 0) body.innerHTML = `<tr><td colspan="6" class="small">No tiene hijos asociados.</td></tr>`;
      hijos.forEach(h => {
        const r = document.createElement('tr');
        r.innerHTML = `<td>${h.id}</td><td>${h.dni}</td><td>${h.nombres}</td><td>${h.grado || ''}</td><td>${h.seccion || ''}</td>
          <td><button class="btn-disable" onclick="inhabilitarHijo(${h.id})">Inhabilitar</button></td>`;
        body.appendChild(r);
      });
    } catch (err) {
      // demo local
      body.innerHTML = `<tr><td>101</td><td>20123456</td><td>Juanito López</td><td>3°</td><td>A</td><td><button class="btn-disable">Inhabilitar</button></td></tr>`;
      console.warn('Hijos demo (ajusta ApoderadoController?hijos).', err);
    }
  } else {
    // ocultar
    trChildren.style.display = 'none';
  }
}

/* ========== MODAL: AGREGAR HIJO ========= */
function abrirAgregarHijo(apoderadoId) {
  document.getElementById('apoderadoIdSeleccionado').value = apoderadoId;
  document.getElementById('dniBuscar').value = '';
  document.getElementById('resultadoBusqueda').innerHTML = '';
  document.getElementById('personaEncontradaId').value = '';
  document.getElementById('btnAsociarHijo').disabled = true;
  modalAgregarHijo.style.display = 'flex';
}
document.getElementById('btnCancelBuscar').addEventListener('click', () => modalAgregarHijo.style.display = 'none');

document.getElementById('formBuscarHijo').addEventListener('submit', async (e) => {
  e.preventDefault();
  const dni = document.getElementById('dniBuscar').value.trim();
  if (!dni) return;
  try {
    // Ajusta la URL a tu controlador de personas
    const res = await fetch(`PersonaController?accion=buscarPorDni&dni=${dni}`);
    if (!res.ok) throw new Error('No JSON');
    const persona = await res.json();
    if (persona && persona.id) {
      document.getElementById('resultadoBusqueda').innerHTML = `<div><strong>${persona.nombres}</strong> — ${persona.dni} — ${persona.correo || ''}</div>`;
      document.getElementById('personaEncontradaId').value = persona.id;
      document.getElementById('btnAsociarHijo').disabled = false;
    } else {
      document.getElementById('resultadoBusqueda').innerHTML = '<div class="small">No se encontró persona con ese DNI.</div>';
      document.getElementById('personaEncontradaId').value = '';
      document.getElementById('btnAsociarHijo').disabled = true;
    }
  } catch (err) {
    // demo local fallback
    document.getElementById('resultadoBusqueda').innerHTML = '<div class="small">Demo: persona encontrada (Juanito Ejemplo)</div>';
    document.getElementById('personaEncontradaId').value = '101';
    document.getElementById('btnAsociarHijo').disabled = false;
    console.warn('Buscar persona demo (ajusta PersonaController).', err);
  }
});

document.getElementById('btnAsociarHijo').addEventListener('click', async (e) => {
  e.preventDefault();
  const apoderadoId = document.getElementById('apoderadoIdSeleccionado').value;
  const personaId = document.getElementById('personaEncontradaId').value;
  if (!apoderadoId || !personaId) return alert('Falta información.');

  try {
    // Ajusta la URL a tu controlador de apoderados para asociar hijo:
    const res = await fetch('ApoderadoController?accion=asociarHijo', {
      method:'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ apoderadoId: apoderadoId, personaId: personaId })
    });
    if (!res.ok) throw new Error('Error en servidor');
    // refrescar la lista de hijos mostrada si está expandida
    const trChildren = document.querySelector(`tr[data-children-for="${apoderadoId}"]`);
    if (trChildren && trChildren.style.display !== 'none') await toggleChildren(parseInt(apoderadoId)); // esto ocultará luego volverá a cargar si quieres
    modalAgregarHijo.style.display = 'none';
    alert('Hijo asociado correctamente (o demo).');
    // opcional: recargar apoderados
    cargarApoderados();
  } catch (err) {
    // demo: cerrar y añadir demo
    modalAgregarHijo.style.display = 'none';
    alert('Asociación demo (ajusta ApoderadoController).');
    cargarApoderados();
    console.warn('Asociar hijo demo', err);
  }
});

/* ========== INHABILITAR / EDITAR (placeholders para backend) ========== */
async function inhabilitarApoderado(id) {
  if (!confirm('¿Inhabilitar apoderado?')) return;
  try {
    await fetch(`ApoderadoController?accion=inhabilitar&id=${id}`, { method:'POST' });
    cargarApoderados();
  } catch (err) {
    alert('Demo: apoderado inhabilitado (ajusta backend).');
    cargarApoderados();
  }
}
async function inhabilitarHijo(id) {
  if (!confirm('¿Inhabilitar hijo?')) return;
  try {
    await fetch(`ApoderadoController?accion=inhabilitarHijo&id=${id}`, { method:'POST' });
    // recargar apoderados para actualizar vista
    cargarApoderados();
  } catch (err) {
    alert('Demo: hijo inhabilitado (ajusta backend).');
    cargarApoderados();
  }
}
function editarParentesco(id) { alert('Editar parentesco id=' + id + ' (implementar)'); }
async function inhabilitarParentesco(id) {
  if (!confirm('¿Inhabilitar parentesco?')) return;
  try {
    await fetch(`ParentescoController?accion=inhabilitar&id=${id}`, { method:'POST' });
    cargarParentescos();
  } catch (err) {
    alert('Demo: parentesco inhabilitado.');
    cargarParentescos();
  }
}

/* ========== Parentesco modal open/close and submit ========== */
document.getElementById('btnOpenParentesco').addEventListener('click', () => { modalParentesco.style.display = 'flex'; });
document.getElementById('btnCancelPar').addEventListener('click', () => { modalParentesco.style.display = 'none'; });
document.getElementById('formParentesco').addEventListener('submit', async (e) => {
  e.preventDefault();
  const nombre = document.getElementById('nombrePar').value.trim();
  const activo = document.getElementById('activoPar').value;
  if (!nombre) return;
  try {
    await fetch('ParentescoController?accion=registrar', {
      method:'POST',
      headers:{ 'Content-Type':'application/json' },
      body: JSON.stringify({ nombre, activo })
    });
    modalParentesco.style.display = 'none';
    cargarParentescos();
  } catch (err) {
    // demo local
    modalParentesco.style.display = 'none';
    alert('Parentesco creado (demo).');
    cargarParentescos();
  }
});

/* ========== FILTRAR APODERADOS ========== */
document.getElementById('btnFiltrarAp').addEventListener('click', () => {
  const filtros = {
    nombre: document.getElementById('filtroNombreAp').value.trim(),
    dni: document.getElementById('filtroDniAp').value.trim(),
    telefono: document.getElementById('filtroTelefonoAp').value.trim()
  };
  cargarApoderados(filtros);
});

/* ========== Close modals on overlay click ========== */
document.querySelectorAll('.modal-overlay').forEach(m => {
  m.addEventListener('click', (e) => { if (e.target === m) m.style.display = 'none'; });
});

/* ========== Inicializar datos ========== */
window.addEventListener('load', () => {
  cargarApoderados();
});
</script>
</body>
</html>


