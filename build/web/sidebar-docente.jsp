<%-- 
    Document   : sidebar-docente
    Created on : 26 oct. 2025, 2:04:28 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TODO supply a title</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
         <style>
        .sidebar {
          background: #0b2f52;
          color: #fff;
          height: 100vh;
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          position: sticky;
          top: 0;
        }
        .sidebar-title {
          display: flex;
          align-items: center;
          gap: 10px;
          padding: 16px;
          color: #fff;
          font-weight: 700;
          font-size: 1.1rem;
          border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-title img {
          width: 38px;
          height: 38px;
          border-radius: 6px;
        }
        .menu {
          display: flex;
          flex-direction: column;
          padding-top: 10px;
        }
        .menu a,
        .submenu-btn {
          display: flex;
          align-items: center;
          gap: 10px;
          color: #dbeafe;
          text-decoration: none;
          padding: 10px 18px;
          transition: background 0.2s ease, color 0.2s ease;
          font-size: 0.95rem;
          cursor: pointer;
          border-left: 3px solid transparent;
        }
        .menu a:hover,
        .submenu-btn:hover {
          background: rgba(255,255,255,0.08);
          color: #fff;
        }
        .menu a.active {
          background: rgba(255,255,255,0.15);
          color: #fff;
          font-weight: 600;
          border-left: 3px solid #3b82f6;
        }
        .submenu {
          display: flex;
          flex-direction: column;
        }
        .submenu-btn {
          justify-content: space-between;
          background: none;
          border: none;
          color: #dbeafe;
          width: 100%;
          text-align: left;
        }
        .submenu-content {
          display: none;
          flex-direction: column;
          background: #0d3b66;
        }
        .submenu-content a {
          padding-left: 45px;
          font-size: 0.9rem;
          color: #cbd5e1;
        }
        .submenu-content a:hover {
          background: rgba(255,255,255,0.08);
          color: #fff;
        }
        .submenu-content.open {
          display: flex;
        }
        .submenu-btn.active .arrow {
          transform: rotate(180deg);
          transition: transform 0.2s ease;
        }
        i[data-lucide] {
          width: 18px;
          height: 18px;
        }
    </style>
    </head>
    <body>
        <aside class="sidebar">
            <div class="sidebar-title">
              <img src="assets/img/logo.png" alt="Logo">
              <span>MRN Docente</span>
            </div>

            <nav class="menu">

              <!-- PANEL PRINCIPAL -->
              <a href="docente-inicio.jsp"><i data-lucide="layout-dashboard"></i> Inicio</a>
              <a href="docente-horario.jsp"><i data-lucide="calendar-clock "></i> Mi horario</a>
              <a href="docente-comunicado.jsp"><i data-lucide="megaphone"></i> Comunicado</a>
              
              <a href="index.html"><i data-lucide="log-out"></i> Cerrar sesión</a>
            </nav>
        </aside>

<!-- ========== Scripts ========== -->
<script src="https://unpkg.com/lucide@latest"></script>
    <script>
      lucide.createIcons();

      // --- Lógica para abrir/cerrar submenús manualmente ---
      document.querySelectorAll('.submenu-btn').forEach(btn => {
        btn.addEventListener('click', () => {
          const submenu = btn.nextElementSibling;
          submenu.classList.toggle('open');
          btn.classList.toggle('active');
        });
      });

      // --- Detección automática de página activa ---
      const currentPage = window.location.pathname.split("/").pop();

      document.querySelectorAll('.menu a').forEach(link => {
        const href = link.getAttribute('href');
        if (currentPage === href) {
          link.classList.add('active');

          // Abrir automáticamente el submenú que contiene este enlace
          const submenuContent = link.closest('.submenu-content');
          if (submenuContent) {
            submenuContent.classList.add('open');
            submenuContent.previousElementSibling.classList.add('active');
          }
        }
      });
    </script>

    </body>
</html>
