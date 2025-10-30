<%-- 
    Document   : docente-inicio
    Created on : 27 oct. 2025, 7:01:38 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>MRN Docente — Inicio</title>
  <link rel="stylesheet" href="css/styles.css">

  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      width: 100%;
      overflow: auto;
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
    .section .container { max-width: 1200px; margin: auto; }

    .card {
      background: #fff;
      border-radius: 14px;
      box-shadow: 0 6px 18px rgba(0,0,0,.08);
      padding: 16px;
    }

    /* Cursos */
    #modulos-grados .grid {
      display: grid;
      gap: 18px;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    }
    #modulos-grados .card {
      background: #fff;
      border-radius: 18px;
      overflow: hidden;
      box-shadow: 0 6px 18px rgba(0,0,0,.08);
      transition: transform .12s ease, box-shadow .12s ease;
      cursor: pointer;
    }
    #modulos-grados .card:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 22px rgba(0,0,0,.12);
    }
    #modulos-grados .bar { height: 12px; }
    #modulos-grados .body { padding: 16px 18px 18px; }
    #modulos-grados .title {
      font-weight: 800;
      font-size: 1.1rem;
      margin: 6px 0 6px;
      color: #0e2238;
    }
    #modulos-grados .sub {
      color: #6b7280;
      font-size: .95rem;
      margin: 0;
    }

    /* Colores de tarjetas */
    .c1 .bar { background: #ffb8b8; }
    .c2 .bar { background: #b8c9ff; }
    .c3 .bar { background: #b7ffd3; }
    .c4 .bar { background: #ffe1a6; }
    .c5 .bar { background: #e2c7ff; }
    .c6 .bar { background: #b7fff1; }
    .c7 .bar { background: #cfe6ff; }
    .c8 .bar { background: #ffd2ec; }
  </style>
</head>
<body>
  <div class="app">
    <%-- Incluir el sidebar del docente --%>
    <jsp:include page="sidebar-docente.jsp" />

    <main class="main" id="app-main">
      <section id="modulos-grados" class="mod-wrap">
        <div class="section">
          <div class="container">
            <div id="mc-grid" class="grid">

              <article class="card c1">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Álgebra</div>
                  <p class="sub">Grado: 2° — Sección: “A”</p>
                </div>
              </article>

              <article class="card c2">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Geometría</div>
                  <p class="sub">Grado: 3° — Sección: “B”</p>
                </div>
              </article>

              <article class="card c3">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Aritmética</div>
                  <p class="sub">Grado: 1° — Sección: “A”</p>
                </div>
              </article>

              <article class="card c4">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Trigonometría</div>
                  <p class="sub">Grado: 5° — Sección: “C”</p>
                </div>
              </article>

              <article class="card c5">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Estadística</div>
                  <p class="sub">Grado: 4° — Sección: “B”</p>
                </div>
              </article>

              <article class="card c6">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Razonamiento Matemático</div>
                  <p class="sub">Grado: 6° — Sección: “A”</p>
                </div>
              </article>

              <article class="card c7">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Geometría Analítica</div>
                  <p class="sub">Grado: 5° — Sección: “B”</p>
                </div>
              </article>

              <article class="card c8">
                <div class="bar"></div>
                <div class="body">
                  <div class="title">Taller de Resolución de Problemas</div>
                  <p class="sub">Grado: 2° — Sección: “C”</p>
                </div>
              </article>

            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</body>
</html>

