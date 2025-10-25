<%-- 
    Document   : panel-admin
    Created on : 17 oct. 2025, 10:36:42 p. m.
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

      .main {
        padding: 24px;
        background: #eef3f8;
        min-height: 100vh;
        overflow-y: auto; /* permite desplazarte solo dentro del contenido principal */
      }
      
    .cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 18px;
    }
    .card {
      background: #fff;
      border-radius: 14px;
      box-shadow: 0 6px 18px rgba(0,0,0,.06);
      padding: 20px;
      text-align: center;
      transition: transform .2s ease, box-shadow .2s ease;
    }
    .card:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 22px rgba(0,0,0,.1);
    }
    .card h3 {
      margin: 0;
      font-size: 2rem;
      color: #0b2f52;
    }
    .card p {
      margin: 6px 0 0;
      color: #64748b;
      font-weight: 600;
    }
  </style>
</head>
<body>
  <div class="app">

    <%-- Incluir el sidebar --%>
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <h2>Panel de Administración</h2>

      <section class="cards">
        <div class="card">
          <h3>1,246</h3>
          <p>Alumnos activos</p>
        </div>
        <div class="card">
          <h3>S/ 38,420</h3>
          <p>Ingresos mensuales</p>
        </div>
        <div class="card">
          <h3>92%</h3>
          <p>Asistencia promedio</p>
        </div>
        <div class="card">
          <h3>17</h3>
          <p>Comunicados vigentes</p>
        </div>
      </section>

      <section style="margin-top:40px;">
        <h3>Atajos rápidos</h3>
        <div class="cards">
          <div class="card">
            <p>Registrar nueva matrícula</p>
          </div>
          <div class="card">
            <p>Subir notas del bimestre</p>
          </div>
          <div class="card">
            <p>Ver historial de pagos</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</body>
</html>

