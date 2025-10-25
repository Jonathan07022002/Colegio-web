<%-- 
    Document   : boleta-nota
    Created on : 18 oct. 2025, 2:41:05 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Boleta de Calificaciones</title>
  <style>
    html, body { margin:0; padding:0; height:100%; width:100%; }
    .app { display:grid; grid-template-columns:270px 1fr; height:100vh; width:100vw; }
    .main { padding:24px; background:#eef3f8; overflow-y:auto; }
    @media print {
  body, html {
    margin: 0;
    padding: 0;
    background: #fff;
  }

  .sidebar {
    display: none !important;
  }

  .app {
    display: block !important;
  }

  .main {
    background: #fff !important;
    padding: 0 !important;
    margin: 0 !important;
  }

  .btn-primary, .btn-secondary {
    display: none !important;
  }

  .card {
    box-shadow: none !important;
    border: none !important;
    page-break-inside: avoid;
  }
}

    .header {
      display:flex;
      justify-content:space-between;
      align-items:center;
      flex-wrap:wrap;
      gap:8px;
      border-bottom:1px solid #e5e7eb;
      padding-bottom:10px;
      margin-bottom:10px;
    }

    .title { margin:0; font-size:1.25rem; font-weight:600; color:#111827; }
    .badge {
      background:#2563eb; color:#fff; padding:4px 10px; border-radius:8px;
      font-size:0.9rem; font-weight:600;
    }
    .muted { color:#6b7280; font-size:0.9rem; }
    .btn-primary, .btn-secondary {
      border:none; border-radius:8px; padding:8px 12px; cursor:pointer; font-weight:600;
    }
    .btn-primary { background:#2563eb; color:#fff; }
    .btn-primary:hover { background:#1e40af; }
    .btn-secondary { background:#9ca3af; color:#fff; }
    .btn-secondary:hover { background:#6b7280; }

    .table-wrap { overflow-x:auto; }
    table {
      width:100%; border-collapse:collapse;
      border-radius:10px; overflow:hidden;
    }
    th, td { padding:10px 14px; border-bottom:1px solid #e5e7eb; }
    th { background:#f3f4f6; text-align:left; font-weight:600; color:#374151; }
    td.nota, td.promedio, td.prom { text-align:center; font-weight:600; }
    td.area { background:#f9fafb; font-weight:600; }
    td.asig { color:#111827; }

    @media print {
      .sidebar, .btn-primary, .btn-secondary { display:none; }
      body, .main { background:#fff; }
      .card { box-shadow:none; border:1px solid #ddd; }
    }
  </style>
</head>
<body>
<div class="app">
  <jsp:include page="sidebar-admin.jsp" />

  <main class="main">
    <div class="header">
      <h1 class="title">Boleta de Calificaciones</h1>
      <div style="display:flex; gap:10px;">
        <button class="btn-secondary" onclick="history.back()">Volver</button>
        <button class="btn-primary" onclick="window.print()">Imprimir</button>
      </div>
    </div>

    <div class="card">
      <div class="header">
        <h2 class="title">Bimestre <span id="bm-label">I</span></h2>
        <span class="badge" id="grado-badge">5.º Grado - Sección A</span>
      </div>
      <div class="muted" id="alumno-info"><strong>Alumno:</strong> —</div>
    </div>

    <div class="card">
      <h3 class="title" style="margin-bottom:8px;">Áreas curriculares</h3>
      <div class="table-wrap">
        <table class="report">
          <thead>
            <tr>
              <th>Área curricular</th>
              <th>Asignatura</th>
              <th style="width:120px; text-align:center;">Bimestre</th>
              <th style="width:160px; text-align:center;">Promedio final del área</th>
            </tr>
          </thead>
          <tbody id="grades-body"></tbody>
        </table>
      </div>
    </div>

    <div class="card">
      <h3 class="title" style="margin-bottom:8px;">Comportamiento del Estudiante</h3>
      <div class="table-wrap">
        <table class="behave">
          <thead>
            <tr>
              <th>Indicador</th>
              <th style="width:120px; text-align:center;">Bimestre</th>
              <th style="width:160px; text-align:center;">Promedio final</th>
            </tr>
          </thead>
          <tbody id="behave-student"></tbody>
        </table>
      </div>
    </div>

    <div class="card">
      <h3 class="title" style="margin-bottom:8px;">Comportamiento del Apoderado</h3>
      <div class="table-wrap">
        <table class="behave">
          <thead>
            <tr>
              <th>Indicador</th>
              <th style="width:120px; text-align:center;">Bimestre</th>
              <th style="width:160px; text-align:center;">Promedio final</th>
            </tr>
          </thead>
          <tbody id="behave-parent"></tbody>
        </table>
      </div>
    </div>

    <div class="card">
      <h3 class="title" style="margin-bottom:8px;">Conclusiones descriptivas</h3>
      <div class="card" style="padding:12px; background:#fff7ec; border:1px solid #fde68a;">
        <p id="conclusiones">—</p>
      </div>
    </div>
  </main>
</div>

<script>
  // Datos simulados (estos se cargarán desde tu servlet con fetch)
  const ALUMNO = {
    nombre: "Balcazar Palacios, Piero Mathias",
    grado: "5.º Grado",
    seccion: "A",
    bimestre: "I"
  };

  const AREAS = [
    { area: "Matemática", items: ["Aritmética","Álgebra","Geometría"], notas: ["A","A","B"], promedio: "A" },
    { area: "Comunicación", items: ["Ortografía","Redacción","Literatura"], notas: ["AD","A","A"], promedio: "AD" },
    { area: "Ciencia y Tecnología", items: ["Biología","Física","Química"], notas: ["A","A","A"], promedio: "A" }
  ];

  const BEHAVE_STUDENT = [
    "Asiste correctamente uniformado.",
    "Cumple con las tareas a tiempo.",
    "Trata con respeto a sus compañeros."
  ];
  const BEHAVE_PARENT = [
    "Hace seguimiento académico.",
    "Asiste a las reuniones programadas."
  ];

  // Render
  document.getElementById("alumno-info").innerHTML = `<strong>Alumno:</strong> ${ALUMNO.nombre}`;
  document.getElementById("grado-badge").textContent = `${ALUMNO.grado} - Sección ${ALUMNO.seccion}`;
  document.getElementById("bm-label").textContent   = ALUMNO.bimestre;

  const tbody = document.getElementById("grades-body");
  tbody.innerHTML = AREAS.map(a => a.items.map((asig,i)=>`
    <tr>
      
      <td class="asig">${asig}</td>
      <td class="nota">${a.notas[i]||''}</td>
      
    </tr>
  `).join('')).join('');

  function renderBehave(list){
    return list.map((txt,i)=>`
      <tr>
        <td>${i+1}. ${txt}</td>
        <td class="nota">A</td>
        
      </tr>`).join('');
  }

  document.getElementById("behave-student").innerHTML = renderBehave(BEHAVE_STUDENT);
  document.getElementById("behave-parent").innerHTML  = renderBehave(BEHAVE_PARENT);

  document.getElementById("conclusiones").textContent =
    "El estudiante demuestra un desempeño destacado en las áreas curriculares evaluadas, mostrando responsabilidad y participación activa.";
</script>
</body>
</html>

