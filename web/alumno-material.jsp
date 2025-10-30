<%-- 
    Document   : alumno-material
    Created on : 26 oct. 2025, 12:43:14 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>MRN Admin — Panel</title>
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
    .legend { margin:8px 0 12px; font-size:.9rem; display:flex; gap:14px; color:#333; }
    .legend .dot { width:10px; height:10px; border-radius:50%; display:inline-block; margin-right:6px; }
    .legend .dot.entregado { background:#28a745; } .legend .dot.pendiente { background:#dc3545; }
    .status { font-weight:600; padding:4px 10px; border-radius:999px; font-size:.85rem; display:inline-block; }
    .status.entregado { background:#d4edda; color:#155724; } .status.pendiente { background:#f8d7da; color:#721c24; }
    table.materiales { width:100%; border-collapse:collapse; }
    table.materiales th, table.materiales td { padding:10px 12px; border-bottom:1px solid #e8e8e8; text-align:left; }
    table.materiales th { background:#f2f6fb; font-weight:600; }
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
            <h2 style="margin:0 0 10px 0;">Lista de Útiles Escolares</h2>
            <div class="legend">
              <span><span class="dot entregado"></span>Entregado</span>
              <span><span class="dot pendiente"></span>Pendiente</span>
            </div>
            <table class="materiales">
              <thead>
                <tr>
                  <th>Útil Escolar</th>
                  <th>Detalle</th>
                  <th>Estado</th>
                </tr>
              </thead>
              <tbody>
                <tr><td>Cuadernos A4 rayados (x3)</td><td>Comunicación, Personal Social, Inglés</td><td><span class="status entregado">Entregado</span></td></tr>
                <tr><td>Cuadernos A4 cuadriculados (x2)</td><td>Matemática, Ciencia y Tecnología</td><td><span class="status pendiente">Pendiente</span></td></tr>
                <tr><td>Cuaderno de dibujo</td><td>Hojas bond 120 g</td><td><span class="status entregado">Entregado</span></td></tr>
                <tr><td>Resma papel bond A4</td><td>500 hojas</td><td><span class="status pendiente">Pendiente</span></td></tr>
                <tr><td>Lápices Nº 2 (x12)</td><td>Caja</td><td><span class="status entregado">Entregado</span></td></tr>
                <tr><td>Borradores (x2)</td><td>Sintético blanco</td><td><span class="status pendiente">Pendiente</span></td></tr>
                <tr><td>Colores (12 unidades)</td><td>Madera o cera</td><td><span class="status entregado">Entregado</span></td></tr>
                <tr><td>Regla 30 cm</td><td>Transparente</td><td><span class="status entregado">Entregado</span></td></tr>
                <tr><td>Tijeras escolares</td><td>Punta roma</td><td><span class="status pendiente">Pendiente</span></td></tr>
                <tr><td>Kit de higiene</td><td>Alcohol en gel, toallas húmedas</td><td><span class="status entregado">Entregado</span></td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </main>
  </div>
</body>
</html>


