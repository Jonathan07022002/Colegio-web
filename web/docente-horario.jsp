<%-- 
    Document   : docente-horario
    Created on : 27 oct. 2025, 7:10:28 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>MRN Docente — Horario</title>
  <link rel="stylesheet" href="css/styles.css">
  <link rel="icon" href="assets/img/favicon.png" type="image/png">
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
      height: 100vh;
      width: 100vw;
      margin: 0;
    }
    .sidebar { height: 100vh; }

    .menu {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .menu a {
      color: #dfe8f5;
      text-decoration: none;
      padding: 10px 12px;
      border-radius: 10px;
      display: block;
    }
    .menu a:hover { background: rgba(255,255,255,.09); }
    .menu a.active {
      background: #123e74;
      color: #fff;
      font-weight: 600;
    }

    main.main { flex: 1; padding: 20px; }
      .section .container{max-width:1200px; margin:auto;}
      .table-wrap{overflow:auto; background:#fff; border-radius:14px; box-shadow:0 6px 18px rgba(0,0,0,.08);}
      table.horario{width:100%; border-collapse:collapse; min-width:900px;}
      table.horario th, table.horario td{border-bottom:1px solid #e9edf5; padding:10px 12px; text-align:left; vertical-align:top;}
      table.horario thead th{position:sticky; top:0; background:#f4f7fd; z-index:1;}
      .time{white-space:nowrap; font-weight:700; color:#0e2238;}
      .slot{border-radius:10px; padding:10px; background:#f9fbff;}
      .slot .curso{font-weight:800; margin-bottom:4px; color:#0e2238;}
      .slot .sub{color:#6b7280; font-size:.9rem;}
      .slot.recreo{background:#fafafb; text-align:center; font-weight:700; color:#5f6b7a;}
      .c1{--c:#b8c9ff;} .c2{--c:#b7ffd3;} .c3{--c:#ffe1a6;} .c4{--c:#ffd2ec;}
      .c5{--c:#e2c7ff;} .c6{--c:#b7fff1;} .c7{--c:#cfe6ff;} .c8{--c:#ffb8b8;}
      .slot .bar{height:6px; background:var(--c); border-radius:6px; margin-bottom:8px;}
      .toolbar{display:flex; align-items:center; gap:10px; margin-bottom:14px; flex-wrap:wrap;}
      .pill{background:#e8eef9; color:#0e2238; border:0; border-radius:999px; padding:6px 12px; cursor:pointer; font-weight:600;}
      .pill.active{background:#0b3a66; color:#fff;}
      .legend{margin-left:auto; display:flex; gap:10px; flex-wrap:wrap;}
      .chip{display:inline-flex; gap:6px; align-items:center; font-size:.9rem; background:#fff; border-radius:999px; border:1px solid #e5e7eb; padding:4px 8px;}
      .dot{width:10px; height:10px; border-radius:50%; display:inline-block;}
  </style>
</head>
<body>
  <div class="app">
    <%-- Incluir el sidebar del docente --%>
    <jsp:include page="sidebar-docente.jsp" />

    <main class="main">
      <section class="section">
        <div class="container">
          <h2 style="margin:0 0 10px;">Mi Horario de Clases</h2>

          <div class="toolbar">
            <div>
              <button class="pill active">Semana</button>
            </div>
            <div class="legend">
              <span class="chip"><span class="dot" style="background:#b8c9ff;"></span> Álgebra</span>
              <span class="chip"><span class="dot" style="background:#b7ffd3;"></span> Geometría</span>
              <span class="chip"><span class="dot" style="background:#ffe1a6;"></span> Trigonometría</span>
              <span class="chip"><span class="dot" style="background:#ffd2ec;"></span> Aritmética</span>
              <span class="chip"><span class="dot" style="background:#e2c7ff;"></span> Razonamiento Matemático</span>
              <span class="chip"><span class="dot" style="background:#b7fff1;"></span> Estadística</span>
              <span class="chip"><span class="dot" style="background:#cfe6ff;"></span> Geometría Analítica</span>
              <span class="chip"><span class="dot" style="background:#ffb8b8;"></span> Cálculo</span>
            </div>
          </div>

          <div class="table-wrap">
            <table class="horario">
              <thead>
                <tr>
                  <th style="width:130px;">Hora</th>
                  <th>Lunes</th>
                  <th>Martes</th>
                  <th>Miércoles</th>
                  <th>Jueves</th>
                  <th>Viernes</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="time">08:00–08:45</td>
                  <td><div class="slot c1"><div class="bar"></div><div class="curso">Álgebra</div><div class="sub">Grado: 3°A — Sección: Azul</div></div></td>
                  <td><div class="slot c2"><div class="bar"></div><div class="curso">Geometría</div><div class="sub">Grado: 3°B — Sección: Rojo</div></div></td>
                  <td><div class="slot c3"><div class="bar"></div><div class="curso">Trigonometría</div><div class="sub">Grado: 4°A — Sección: Amarillo</div></div></td>
                  <td><div class="slot c4"><div class="bar"></div><div class="curso">Aritmética</div><div class="sub">Grado: 2°A — Sección: Verde</div></div></td>
                  <td><div class="slot c5"><div class="bar"></div><div class="curso">Razonamiento Matemático</div><div class="sub">Grado: 5°A — Sección: Azul</div></div></td>
                </tr>

                <tr>
                  <td class="time">08:50–09:35</td>
                  <td><div class="slot c2"><div class="bar"></div><div class="curso">Geometría</div><div class="sub">Grado: 3°A — Sección: Azul</div></div></td>
                  <td><div class="slot c3"><div class="bar"></div><div class="curso">Trigonometría</div><div class="sub">Grado: 4°A — Sección: Amarillo</div></div></td>
                  <td><div class="slot c4"><div class="bar"></div><div class="curso">Aritmética</div><div class="sub">Grado: 2°A — Sección: Verde</div></div></td>
                  <td><div class="slot c6"><div class="bar"></div><div class="curso">Estadística</div><div class="sub">Grado: 5°B — Sección: Rojo</div></div></td>
                  <td><div class="slot c7"><div class="bar"></div><div class="curso">Geometría Analítica</div><div class="sub">Grado: 5°A — Sección: Amarillo</div></div></td>
                </tr>

                <tr>
                  <td class="time">09:40–10:25</td>
                  <td><div class="slot c8"><div class="bar"></div><div class="curso">Cálculo</div><div class="sub">Grado: 5°A — Sección: Azul</div></div></td>
                  <td><div class="slot c4"><div class="bar"></div><div class="curso">Aritmética</div><div class="sub">Grado: 2°B — Sección: Verde</div></div></td>
                  <td><div class="slot c6"><div class="bar"></div><div class="curso">Estadística</div><div class="sub">Grado: 5°B — Sección: Rojo</div></div></td>
                  <td><div class="slot c5"><div class="bar"></div><div class="curso">Razonamiento Matemático</div><div class="sub">Grado: 4°B — Sección: Amarillo</div></div></td>
                  <td><div class="slot c7"><div class="bar"></div><div class="curso">Geometría Analítica</div><div class="sub">Grado: 5°B — Sección: Rojo</div></div></td>
                </tr>

                <tr>
                  <td class="time">10:25–10:45</td>
                  <td colspan="5"><div class="slot recreo">Recreo</div></td>
                </tr>

                <tr>
                  <td class="time">10:45–11:30</td>
                  <td><div class="slot c3"><div class="bar"></div><div class="curso">Trigonometría</div><div class="sub">Grado: 4°A — Sección: Amarillo</div></div></td>
                  <td><div class="slot c2"><div class="bar"></div><div class="curso">Geometría</div><div class="sub">Grado: 3°B — Sección: Rojo</div></div></td>
                  <td><div class="slot c1"><div class="bar"></div><div class="curso">Álgebra</div><div class="sub">Grado: 3°A — Sección: Azul</div></div></td>
                  <td><div class="slot c5"><div class="bar"></div><div class="curso">Razonamiento Matemático</div><div class="sub">Grado: 5°A — Sección: Azul</div></div></td>
                  <td><div class="slot c8"><div class="bar"></div><div class="curso">Cálculo</div><div class="sub">Grado: 5°A — Sección: Azul</div></div></td>
                </tr>

                <tr>
                  <td class="time">11:35–12:20</td>
                  <td><div class="slot c6"><div class="bar"></div><div class="curso">Estadística</div><div class="sub">Grado: 5°B — Sección: Rojo</div></div></td>
                  <td><div class="slot c7"><div class="bar"></div><div class="curso">Geometría Analítica</div><div class="sub">Grado: 5°A — Sección: Amarillo</div></div></td>
                  <td><div class="slot c2"><div class="bar"></div><div class="curso">Geometría</div><div class="sub">Grado: 3°A — Sección: Azul</div></div></td>
                  <td><div class="slot c4"><div class="bar"></div><div class="curso">Aritmética</div><div class="sub">Grado: 2°B — Sección: Verde</div></div></td>
                  <td><div class="slot c3"><div class="bar"></div><div class="curso">Trigonometría</div><div class="sub">Grado: 4°A — Sección: Amarillo</div></div></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </main>
  </div>



  <script>
  (function(){
    const COURSE = {
      'Álgebra':      { color:'c1', grado:'3°A' },
      'Geometría':    { color:'c2', grado:'3°B' },
      'Aritmética':   { color:'c3', grado:'2°A' },
      'Trigonometría':{ color:'c4', grado:'4°A' }
    };
    const DAYS = ['Lunes','Martes','Miércoles','Jueves','Viernes'];
    const SLOTS = ['08:00–08:45','08:50–09:35','09:40–10:25','10:25–10:45','10:45–11:30','11:35–12:20','12:25–13:10'];

    // Ejemplo de horario del docente
    const TABLE = {
      'Lunes':     ['Álgebra','Álgebra','Vacio','Recreo','Geometría','Vacio','Vacio'],
      'Martes':    ['Vacio','Aritmética','Aritmética','Recreo','Vacio','Vacio','Trigonometría'],
      'Miércoles': ['Geometría','Vacio','Trigonometría','Recreo','Vacio','Álgebra','Vacio'],
      'Jueves':    ['Vacio','Vacio','Geometría','Recreo','Aritmética','Trigonometría','Vacio'],
      'Viernes':   ['Álgebra','Vacio','Vacio','Recreo','Aritmética','Geometría','Vacio']
    };

    const weekBody = document.getElementById('week-body');
    weekBody.innerHTML = SLOTS.map((hour, i) => {
      const cells = DAYS.map(day => {
        const name = TABLE[day][i];
        if (name === 'Recreo') return `<td><div class="slot recreo">Recreo</div></td>`;
        if (name === 'Vacio') return `<td><div class="slot vacio">—</div></td>`;
        const c = COURSE[name];
        return `<td><div class="slot ${c.color}"><div class="bar"></div><div class="curso">${name}</div><div class="sub">Grado: ${c.grado}</div></div></td>`;
      }).join('');
      return `<tr><td class="time">${hour}</td>${cells}</tr>`;
    }).join('');

    // Día individual
    const dayTitle = document.getElementById('day-title');
    const dayList  = document.getElementById('day-list');
    function renderDay(day){
      dayTitle.textContent = day;
      dayList.innerHTML = TABLE[day].map((name, i) => {
        const hour = SLOTS[i];
        if (name === 'Recreo') return `<div class="item"><div class="top"><span class="time">${hour}</span><span>Recreo</span></div></div>`;
        if (name === 'Vacio') return `<div class="item vacio"><div class="top"><span class="time">${hour}</span><em>Hora libre</em></div></div>`;
        const c = COURSE[name];
        return `<div class="item ${c.color}"><div class="top"><span class="time">${hour}</span><strong>${name}</strong></div><div class="bar" style="height:6px; background:var(--c); border-radius:6px; margin:6px 0;"></div><div class="sub">Grado: ${c.grado}</div></div>`;
      }).join('');
    }
    renderDay('Lunes');

    // Controles de vista
    const btnSemana = document.querySelector('[data-view="semana"]');
    const btnDia    = document.querySelector('[data-view="dia"]');
    const daySwitch = document.getElementById('day-switch');
    const viewWeek  = document.getElementById('view-week');
    const viewDay   = document.getElementById('view-day');

    function setView(view){
      btnSemana.classList.toggle('active', view==='semana');
      btnDia.classList.toggle('active', view==='dia');
      viewWeek.classList.toggle('hide', view!=='semana');
      viewDay.classList.toggle('hide', view!=='dia');
      daySwitch.classList.toggle('hide', view!=='dia');
    }

    btnSemana.addEventListener('click', ()=> setView('semana'));
    btnDia.addEventListener('click', ()=> setView('dia'));

    daySwitch.querySelectorAll('.pill').forEach(b=>{
      b.addEventListener('click', ()=>{
        daySwitch.querySelectorAll('.pill').forEach(x=>x.classList.remove('active'));
        b.classList.add('active');
        renderDay(b.dataset.day);
      });
    });
  })();
  </script>
</body>
</html>

