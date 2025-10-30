<%-- 
    Document   : alumno-pago
    Created on : 26 oct. 2025, 12:43:05 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>MRN Admin — Panel</title>
  <link rel="stylesheet" href="css/styles.css">
  <script defer src="js/app.js"></script>
  <link rel="icon" href="assets/img/favicon.png" type="image/png">
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

      .menu{display:flex; flex-direction:column; gap:10px;}
    .menu a{color:#dfe8f5; text-decoration:none; padding:10px 12px; border-radius:10px; display:block;}
    .menu a:hover{background:rgba(255,255,255,.09);}
    .menu a.active{background:#123e74; color:#fff; font-weight:600;}
    main.main{flex:1; padding:20px;}
    .section .container{max-width:1200px; margin:auto;}
    .card{background:#fff; border-radius:14px; box-shadow:0 6px 18px rgba(0,0,0,.08); padding:16px;}
  </style>

  <style>
    .title{font-weight:800; font-size:1.2rem; margin:0;}
    .summary{display:flex;gap:12px;flex-wrap:wrap;margin:10px 0}
    .kpi{background:#f8fafc;border:1px solid #e5e7eb;border-radius:12px;padding:10px 12px;min-width:180px}
    .kpi .label{color:#6b7280;font-size:.9rem} .kpi .value{font-weight:900;font-size:1.1rem}
    .toolbar{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:10px}
    .pill{background:#e8eef9;color:#0e2238;border:0;border-radius:999px;padding:6px 12px;cursor:pointer;font-weight:600}
    .pill.active{background:#0b3a66;color:#fff}
    .search{margin-left:auto;display:flex;gap:8px;align-items:center}
    .table-wrap{overflow:auto;border-radius:12px;border:1px solid #e8eaf3}
    table.pay{width:100%;min-width:980px;border-collapse:collapse}
    table.pay th,table.pay td{border-bottom:1px solid #eceff6;padding:10px 12px;text-align:left}
    table.pay thead th{background:#f6f9ff;font-weight:800;color:#0e2238}
    .money{font-weight:800}
    .status{font-weight:700;border-radius:999px;font-size:.85rem;padding:4px 10px;display:inline-block}
    .status.pendiente{background:#fde2e1;color:#9b1c1c} .status.pagado{background:#dbf5e7;color:#11643c}
    .btn{border:0;border-radius:10px;padding:8px 10px;cursor:pointer} .btn.primary{background:#0b3a66;color:#fff} .btn.light{background:#eef2f7}
    .note{color:#6b7280;font-size:.9rem;margin-top:8px}
    .modal{position:fixed;inset:0;background:rgba(0,0,0,.35);display:none;align-items:center;justify-content:center;padding:16px;z-index:50}
    .modal.open{display:flex} .modal .box{background:#fff;border-radius:14px;box-shadow:0 10px 30px rgba(0,0,0,.2);width:min(560px,100%);padding:16px}
    .form{display:grid;gap:10px} .row{display:grid;gap:10px;grid-template-columns:1fr 1fr}
    .form label{font-weight:700}
    .form input[type="text"],.form input[type="date"],.form input[type="number"],.form select{width:100%;border:1px solid #e5e7eb;border-radius:10px;padding:8px 10px}
    .actions{display:flex;justify-content:flex-end;gap:8px;margin-top:8px}
  </style>
</head>
<body>
  <div class="app">

    <%-- Incluir el sidebar --%>
    <jsp:include page="sidebar-alumno.jsp" />

    <main class="main">
      <section class="section">
        <div class="container">
          <h2 class="title">Pagos</h2>
          <div class="summary">
            <div class="kpi"><div class="label">Total a pagar</div><div class="value" id="kpi-total">S/ 0.00</div></div>
            <div class="kpi"><div class="label">Total pagado</div><div class="value" id="kpi-pagado">S/ 0.00</div></div>
            <div class="kpi"><div class="label">Total pendiente</div><div class="value" id="kpi-pendiente">S/ 0.00</div></div>
          </div>
          <div class="toolbar">
            <div>
              <button class="pill active" data-filter="todos">Todos</button>
              <button class="pill" data-filter="pendiente">Pendientes</button>
              <button class="pill" data-filter="pagado">Pagados</button>
            </div>
            <div class="search">
              <input id="q" type="text" placeholder="Buscar concepto o mes…" style="border:1px solid #e5e7eb;border-radius:10px;padding:8px 10px;min-width:240px">
              <button class="btn light" id="clear">Limpiar</button>
            </div>
          </div>
          <div class="table-wrap">
            <table class="pay">
              <thead>
                <tr>
                  <th style="width:200px">Concepto</th>
                  <th>Mes</th>
                  <th>Vencimiento</th>
                  <th style="width:120px">Monto</th>
                  <th style="width:120px">Estado</th>
                  <th>Detalle</th>
                  <th style="width:180px">Acción</th>
                </tr>
              </thead>
              <tbody id="tbody"></tbody>
            </table>
          </div>
          <p class="note">*Esta vista es informativa y permite registrar regularizaciones. La validación final la realiza tesorería.</p>
        </div>
      </section>
    </main>
  </div>

  <div class="modal" id="modal">
    <div class="box">
      <h3 style="margin:0 0 8px" id="m-title">Regularizar pago</h3>
      <form class="form" id="m-form">
        <div class="row">
          <div><label>Concepto</label><input id="m-concepto" type="text" readonly></div>
          <div><label>Monto (S/)</label><input id="m-monto" type="number" step="0.01" min="0" required></div>
        </div>
        <div class="row">
          <div><label>Método</label><select id="m-metodo" required>
            <option>Depósito</option><option>Transferencia</option><option>Tarjeta</option><option>Yape/Plin</option>
          </select></div>
          <div><label>Fecha de pago</label><input id="m-fecha" type="date" required></div>
        </div>
        <div class="row">
          <div><label>Código de operación</label><input id="m-codigo" type="text" placeholder="Ej. 12345678" required></div>
          <div><label>Adjuntar voucher (opcional)</label><input id="m-file" type="file" accept="image/*,application/pdf"></div>
        </div>
        <div class="actions">
          <button type="button" class="btn light" id="m-cancel">Cancelar</button>
          <button type="submit" class="btn primary">Confirmar</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    const PEN = new Intl.NumberFormat('es-PE', { style:'currency', currency:'PEN', minimumFractionDigits:2 });
  const $ = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));

  let DATA = [];
  let FILTER = 'todos';
  let QUERY = '';

  // 🔹 Cargar datos del servlet (cuando esté disponible)
  async function fetchPagos() {
    try {
      const res = await fetch('AlumnoPagoSVL?accion=listar'); // ← tu servlet
      if (!res.ok) throw new Error('Error al obtener datos');
      const data = await res.json();
      DATA = data;
      render();
    } catch (e) {
      console.warn('⚠️ No se pudo conectar con el servlet. Cargando datos estáticos...');
      DATA = seedData(); // usa datos locales por ahora
      render();
    }
  }

  // 🔹 Datos estáticos temporales
  function seedData() {
    const meses = ['Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
    const rows = [{ id:'matricula', concepto:'Matrícula', mes:'—', vencimiento:'15 de Febrero', monto:150, estado:'Pendiente', detalle:'' }];
    meses.forEach((mes,i)=>rows.push({
      id:`cuota-${i+1}`,
      concepto:`Cuota ${i+1}`,
      mes,
      vencimiento:`05 de ${mes}`,
      monto:240,
      estado:'Pendiente',
      detalle:''
    }));
    return rows;
  }

  // 🔹 Totales (KPI)
  function refreshKPI() {
    const total = DATA.reduce((s,r)=>s+r.monto,0);
    const pagado = DATA.filter(r=>r.estado==='Pagado').reduce((s,r)=>s+r.monto,0);
    const pendiente = total - pagado;
    $('#kpi-total').textContent = PEN.format(total);
    $('#kpi-pagado').textContent = PEN.format(pagado);
    $('#kpi-pendiente').textContent = PEN.format(pendiente);
  }

  // 🔹 Filtros y búsqueda
  function matches(r) {
    if (FILTER!=='todos' && r.estado.toLowerCase()!==FILTER) return false;
    if (QUERY) {
      const t = (r.concepto+' '+r.mes).toLowerCase();
      if (!t.includes(QUERY)) return false;
    }
    return true;
  }

  // 🔹 Render principal
  function render() {
    refreshKPI();
    $('#tbody').innerHTML = DATA.filter(matches).map(r=>{
      const status = r.estado==='Pagado'
        ? '<span class="status pagado">Pagado</span>'
        : '<span class="status pendiente">Pendiente</span>';
      const det = r.estado==='Pagado' ? (r.detalle || 'Pago confirmado') : '—';
      const accion = r.estado==='Pagado'
        ? `<button class="btn light" data-ver="${r.id}">Ver recibo</button>`
        : `<button class="btn primary" data-regularizar="${r.id}">Regularizar</button>`;
      return `
        <tr>
          <td>${r.concepto}</td>
          <td>${r.mes}</td>
          <td>${r.vencimiento}</td>
          <td class="money">${PEN.format(r.monto)}</td>
          <td>${status}</td>
          <td>${det}</td>
          <td>${accion}</td>
        </tr>`;
    }).join('');
  }

  // 🔹 Modal
  const modal = $('#modal');
  let currentId = null;

  function openModal(row) {
    currentId = row.id;
    $('#m-title').textContent = `Regularizar — ${row.concepto}`;
    $('#m-concepto').value = row.concepto;
    $('#m-monto').value = row.monto.toFixed(2);
    $('#m-metodo').value = 'Depósito';
    $('#m-fecha').valueAsDate = new Date();
    $('#m-codigo').value = '';
    $('#m-file').value = '';
    modal.classList.add('open');
  }

  function closeModal() {
    modal.classList.remove('open');
    currentId = null;
  }

  $('#m-cancel').addEventListener('click', closeModal);
  modal.addEventListener('click', e=>{ if(e.target===modal) closeModal(); });

  // 🔹 Acciones de tabla
  document.addEventListener('click', e=>{
    const reg = e.target.closest('[data-regularizar]');
    if (reg) {
      const id = reg.getAttribute('data-regularizar');
      const row = DATA.find(r=>r.id===id);
      if (row) openModal(row);
    }

    const ver = e.target.closest('[data-ver]');
    if (ver) {
      const id = ver.getAttribute('data-ver');
      const r = DATA.find(x=>x.id===id);
      if (r) alert(`Recibo\n\nConcepto: ${r.concepto}\nMonto: ${PEN.format(r.monto)}\nMétodo: ${r.metodo||'-'}\nFecha: ${r.fechaPago||'-'}\nCódigo: ${r.codigo||'-'}`);
    }
  });

  // 🔹 Envío del formulario
  $('#m-form').addEventListener('submit', e=>{
    e.preventDefault();
    const row = DATA.find(r=>r.id===currentId);
    if(!row) return;

    const monto = parseFloat($('#m-monto').value||'0');
    const metodo = $('#m-metodo').value;
    const fecha = $('#m-fecha').value;
    const codigo = $('#m-codigo').value.trim();
    if(!monto || !fecha || !codigo) return alert('Completa monto, fecha y código.');

    // Simulación de actualización (más adelante enviarás por fetch al servlet)
    row.monto = monto;
    row.estado = 'Pagado';
    row.metodo = metodo;
    row.fechaPago = fecha;
    row.codigo = codigo;
    row.detalle = `Pago registrado (${metodo}) — ${fecha} — Op: ${codigo}`;
    closeModal();
    render();
  });

  // 🔹 Filtros y búsqueda
  $$('.pill[data-filter]').forEach(b=>b.addEventListener('click',()=>{
    $$('.pill[data-filter]').forEach(x=>x.classList.remove('active'));
    b.classList.add('active');
    FILTER = b.getAttribute('data-filter');
    render();
  }));

  $('#q').addEventListener('input',()=>{
    QUERY = $('#q').value.trim().toLowerCase();
    render();
  });

  $('#clear').addEventListener('click',()=>{
    $('#q').value = '';
    QUERY = '';
    render();
  });

  // 🔹 Cargar al iniciar
  fetchPagos();
    </script>
</body>
</html>