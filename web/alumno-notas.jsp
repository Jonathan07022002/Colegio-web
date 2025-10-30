<%-- 
    Document   : alumno-notas
    Created on : 26 oct. 2025, 12:42:55 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MRN Admin — Panel</title>
  <link rel="stylesheet" href="css/styles.css">
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
    .header{display:flex; flex-wrap:wrap; gap:12px; align-items:center; margin-bottom:10px;}
    .badge{background:#ffe08a; color:#7a5200; font-weight:800; border-radius:8px; padding:6px 10px;}
    .title{font-weight:800; font-size:1.2rem; margin:0;}
    .table-wrap{overflow:auto; border-radius:12px; border:1px solid #e8eaf3;}
    table.report{width:100%; border-collapse:collapse; min-width:920px;}
    table.report th, table.report td{border-bottom:1px solid #eceff6; padding:10px 12px; text-align:left;}
    table.report thead th{background:#f6f4e7; font-weight:800; color:#40350b;}
    table.report thead th:last-child{background:#f7edd6; text-align:center;}
    td.area{background:#faf7ec; font-weight:800; color:#3a2c07; width:240px;}
    td.promedio{background:#f7edd6; text-align:center; font-weight:900; color:#3a2c07;}
    td.asig{width:320px;}
    .nota{font-weight:800; text-align:center;}
    table.behave{width:100%; border-collapse:collapse; min-width:820px;}
    table.behave th, table.behave td{border-bottom:1px solid #eceff6; padding:10px 12px; text-align:left;}
    table.behave thead th{background:#f6f4e7; font-weight:800; color:#40350b;}
    table.behave thead th:last-child{background:#f7edd6; text-align:center;}
    td.prom{background:#f7edd6; text-align:center; font-weight:900; color:#3a2c07; width:120px;}
    .muted{color:#6b7280; font-size:.92rem;}
    .print{background:#0b3a66; color:#fff; border:0; border-radius:10px; padding:8px 12px; cursor:pointer;}
    .print:hover{filter:brightness(1.05);}
  </style>
</head>
<body>
  <div class="app">

    <%-- Incluir el sidebar --%>
    <jsp:include page="sidebar-alumno.jsp" />

    <main class="main">
      
    <section class="section">
        <div class="container">
          <div class="card">
            <div class="header">
              <h2 class="title">Boleta de Calificaciones — Bimestre <span id="bm-label">I</span></h2>
              <span class="badge" id="grado-badge">5.º Grado</span>
              <div class="muted" id="alumno-info"><strong>Alumno:</strong> Balcazar Palacios, Piero Mathias</div>
              <button class="print" onclick="window.print()">Imprimir</button>
            </div>
            <div class="table-wrap">
              <table class="report">
                <thead>
                  <tr>
                    <th>Áreas curriculares</th>
                    <th>Asignaturas</th>
                    <th style="width:120px; text-align:center;">Bimestre I</th>
                    <th style="width:160px; text-align:center;">Promedio final del área</th>
                  </tr>
                </thead>
                <tbody id="grades-body"></tbody>
              </table>
            </div>
          </div>
          <div class="card" style="margin-top:16px;">
            <h3 class="title" style="margin-bottom:10px;">Comportamiento</h3>
            <div class="table-wrap">
              <table class="behave">
                <thead>
                  <tr>
                    <th>Comportamiento del estudiante</th>
                    <th style="width:120px; text-align:center;">I</th>
                    <th style="width:160px; text-align:center;">Promedio final</th>
                  </tr>
                </thead>
                <tbody id="behave-student"></tbody>
              </table>
            </div>
            <div class="table-wrap" style="margin-top:12px;">
              <table class="behave">
                <thead>
                  <tr>
                    <th>Comportamiento del padre de familia y/o apoderado</th>
                    <th style="width:120px; text-align:center;">I</th>
                    <th style="width:160px; text-align:center;">Promedio final</th>
                  </tr>
                </thead>
                <tbody id="behave-parent"></tbody>
              </table>
            </div>
            <div style="margin-top:12px;">
              <h4 class="title" style="font-size:1rem;">Conclusiones descriptivas</h4>
              <div class="card" style="padding:12px; background:#fff7ec;">—</div>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>

  <script>
    const ALUMNO = { nombre: "Balcazar Palacios, Piero Mathias", grado: "5.º Grado", bimestre: "I" };
    const AREAS = [
      { area: "Matemática", items: ["Álgebra","Aritmética","Geometría","Cálculo","Actitud ante el área"], notas: ["A","A","A","A","A"], promedio: "A" },
      { area: "Razonamiento Mat.", items: ["Razonamiento Mat.","Actitud ante el área"], notas: ["A","A"], promedio: "A" },
      { area: "Razonamiento Verbal", items: ["Razonamiento Verbal","Actitud ante el área"], notas: ["A","A"], promedio: "A" },
      { area: "Comunicación", items: ["Ortografía","Redacción","Literatura","Comunicación","Plan lector","Actitud ante el área"], notas: ["A","A","A","A","A","A"], promedio: "A" },
      { area: "Ciencia y Tecnología", items: ["Biología","Física","Química","Actitud ante el área"], notas: ["A","A","A","A"], promedio: "A" },
      { area: "Personal Social", items: ["Geografía","Historia","Actitud ante el área"], notas: ["A","A","A"], promedio: "A" },
      { area: "Inglés", items: ["Inglés","Actitud ante el área"], notas: ["A","A"], promedio: "A" },
      { area: "Educación Física", items: ["Educación Física","Actitud ante el área"], notas: ["A","A"], promedio: "A" },
      { area: "Religión", items: ["Religión","Actitud ante el área"], notas: ["A","A"], promedio: "A" },
      { area: "Taller", items: ["Ajedrez","Danza","Actitud ante el área"], notas: ["A","A","A"], promedio: "A" },
      { area: "Artística", items: ["Arte","Actitud ante el área"], notas: ["A","A"], promedio: "A" }
    ];
    const BEHAVE_STUDENT = [
      "Asiste correctamente uniformado.","Puntualidad.","Presentación personal.",
      "Trata con respeto a sus compañeros.","Trae los cuadernos de acuerdo al horario (limpio y ordenado).",
      "Es respetuoso: saluda y se despide.","Cumple con las tareas a tiempo.","Responsable con el cuidado de sus materiales."
    ];
    const BEHAVE_PARENT = [
      "Hace seguimiento académico y se preocupa por la presentación, higiene y salud de su menor hijo(a).",
      "Apoya diariamente a su menor hijo reforzando las actividades en casa.",
      "Asiste a las actividades programadas por el aula e institución educativa.",
      "Es respetuoso, amable y empático con los demás padres de familia y personal de la institución."
    ];
    document.getElementById("alumno-info").innerHTML = `<strong>Alumno:</strong> ${ALUMNO.nombre}`;
    document.getElementById("grado-badge").textContent = ALUMNO.grado;
    document.getElementById("bm-label").textContent   = ALUMNO.bimestre;
    const tbody = document.getElementById("grades-body");
    tbody.innerHTML = AREAS.map(a => a.items.map((asig,i)=>`
      <tr>
        
        <td class="asig">${asig}</td>
        <td class="nota">${a.notas[i]||''}</td>
        
      </tr>
    `).join('')).join('');
    function renderBehave(list){
      return list.map((txt,i)=>`<tr><td>${i+1}. ${txt}</td><td class="nota">A</td>">A</td>`:''
    }
    document.getElementById("behave-student").innerHTML = renderBehave(BEHAVE_STUDENT);
    document.getElementById("behave-parent").innerHTML  = renderBehave(BEHAVE_PARENT);
  </script>
</body>
</html>
