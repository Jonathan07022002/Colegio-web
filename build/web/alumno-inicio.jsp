<%-- 
    Document   : alumno-inicio
    Created on : 26 oct. 2025, 12:21:19 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>MRN Alumno — Inicio</title>
  <link rel="stylesheet" href="css/styles.css">
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
      
    .section .container{max-width:1200px; margin:auto;}
    .card{background:#fff; border-radius:14px; box-shadow:0 6px 18px rgba(0,0,0,.08); padding:16px;}
  </style>

  <style>
    #modulos-cursos .grid{display:grid; gap:18px; grid-template-columns:repeat(auto-fit,minmax(280px,1fr));}
    #modulos-cursos .card{background:#fff; border-radius:18px; overflow:hidden; box-shadow:0 6px 18px rgba(0,0,0,.08); transition:transform .12s ease, box-shadow .12s ease; cursor:pointer;}
    #modulos-cursos .card:hover{ transform:translateY(-2px); box-shadow:0 10px 22px rgba(0,0,0,.12);}
    #modulos-cursos .bar{ height:12px; }
    #modulos-cursos .body{ padding:16px 18px 18px; }
    #modulos-cursos .title{ font-weight:800; font-size:1.1rem; margin:6px 0 6px; color:#0e2238;}
    #modulos-cursos .sub{ color:#6b7280; font-size:.95rem; margin:0; }
    #modulos-cursos .c1 .bar{ background:#ffb8b8; } .c2 .bar{ background:#b8c9ff; } .c3 .bar{ background:#b7ffd3; } .c4 .bar{ background:#ffe1a6; }
    #modulos-cursos .c5 .bar{ background:#e2c7ff; } .c6 .bar{ background:#b7fff1; } .c7 .bar{ background:#cfe6ff; } .c8 .bar{ background:#ffd2ec; }
    #modulos-cursos .canvas[hidden]{ display:none !important; }
    #modulos-cursos .canvas{ background:#fff; border-radius:18px; padding:20px; box-shadow:0 6px 18px rgba(0,0,0,.08); margin-top:10px; }
    #modulos-cursos .back{ background:#0b3a66; color:#fff; border:0; border-radius:10px; padding:8px 12px; cursor:pointer; margin-bottom:12px; }
    #modulos-cursos .back:hover{ filter:brightness(1.05); }
    #modulos-cursos .canvas-grid{ display:grid; gap:16px; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); }
    #modulos-cursos .panel{ background:#f8fafc; border:1px solid #e5e7eb; border-radius:12px; padding:14px; }
    #modulos-cursos .info{ list-style:none; padding:0; margin:0; }
    #modulos-cursos .info li{ margin:6px 0; }
    #modulos-cursos .chips{ display:flex; flex-wrap:wrap; gap:8px; }
    #modulos-cursos .chip{ background:#e5f0ff; color:#113a77; padding:6px 10px; border-radius:999px; font-size:.85rem; }
    #modulos-cursos .muted{ color:#6b7280; font-size:.9rem; }
  </style>
</head>
<body>
  <div class="app">

    <%-- Incluir el sidebar --%>
    <jsp:include page="sidebar-alumno.jsp" />

    <main class="main" id="app-main">
  <section id="modulos-cursos" class="mod-wrap">
    <div class="section">
      <div class="container">
        <div id="mc-grid" class="grid">
          <article class="card c1">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Comunicación</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c2">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Matemática</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c3">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Personal Social</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c4">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Ciencia y Ambiente</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c5">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Arte y Cultura</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c6">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Educación Física</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c7">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Educación Religiosa</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>

          <article class="card c8">
            <div class="bar"></div>
            <div class="body">
              <div class="title">Tutoría</div>
              <p class="sub">Docente: Por asignar</p>
            </div>
          </article>
        </div>
      </div>
    </div>
  </section>
</main>
  </div>
    <script>
  
  </script>
</body>
</html>


