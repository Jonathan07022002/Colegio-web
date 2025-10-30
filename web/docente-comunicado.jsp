<%-- 
    Document   : docente-comunicado
    Created on : 27 oct. 2025, 7:34:01 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MRN Docente — Comunicados</title>
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
        .grid-2{display:grid;grid-template-columns:1.2fr 1fr;gap:18px}
        .card{background:#fff;border-radius:14px;box-shadow:var(--shadow);padding:20px}
        .field{display:flex;flex-direction:column;margin:10px 0}
        .field>span{font-size:13px;color:#4a5a70;margin-bottom:6px}
        .input{border:1px solid #d8e0ea;border-radius:10px;padding:10px;background:#f7f9fc}
        textarea.input{resize:none}
        .btn{border:none;border-radius:10px;background:var(--red);color:#fff;padding:10px 14px;font-weight:700;cursor:pointer}
        .btn:hover{opacity:0.9}
        .btn.ghost{background:#fff;color:var(--red);border:1px solid var(--red)}
        .list{list-style:none;padding:0;margin:0}
        .list li{padding:10px 12px;border-bottom:1px dashed #e6edf5}
        .list li strong{display:block;font-size:14px;color:var(--ink)}
        .list li span{font-size:12px;color:var(--ink-2)}
        .row{display:flex;gap:10px;align-items:center}
        .row-right{justify-content:flex-end;display:flex;gap:10px}
        @media(max-width:960px){.grid-2{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="sidebar-docente.jsp" />

    <main class="main">
        <h2>Comunicados</h2>
        <div class="grid-2">
            <!-- FORMULARIO NUEVO COMUNICADO -->
            <div class="card">
                <h3>Nuevo comunicado</h3>
                <form action="ComunicadoSVL" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="accion" value="crearComunicado">
                    <div class="field">
                        <span>Tipo de destinatario</span>
                        <select class="input" name="tipoDestinatario">
                            <option value="alumnos">Alumnos</option>
                            <option value="docentes">Docentes</option>
                            <option value="director">Director</option>
                            <option value="general">Todos</option>
                            <option value="individual">Individual</option>
                        </select>
                    </div>
                    <div class="row">
                        <label class="field" style="flex:1">
                            <span>Grado</span>
                            <select class="input" name="grado">
                                <option value="">-- Seleccione --</option>
                                <option>1°</option><option>2°</option><option>3°</option>
                                <option>4°</option><option>5°</option><option>6°</option>
                            </select>
                        </label>
                        <label class="field" style="flex:1">
                            <span>Sección</span>
                            <select class="input" name="seccion">
                                <option value="">-- Seleccione --</option>
                                <option>A</option><option>B</option><option>C</option>
                            </select>
                        </label>
                        <label class="field" style="flex:1">
                            <span>Turno</span>
                            <select class="input" name="turno">
                                <option value="">-- Seleccione --</option>
                                <option>Mañana</option>
                                <option>Tarde</option>
                            </select>
                        </label>
                    </div>
                    <label class="field">
                        <span>Título</span>
                        <input type="text" class="input" name="titulo" placeholder="Ej. Reunión de coordinación del lunes">
                    </label>
                    <label class="field">
                        <span>Mensaje</span>
                        <textarea class="input" name="mensaje" rows="6" placeholder="Escribe el comunicado..."></textarea>
                    </label>
                    <label class="field">
                        <span>Adjunto (opcional)</span>
                        <input type="file" class="input" name="archivo">
                    </label>
                    <div class="row-right">
                        <button type="reset" class="btn ghost">Limpiar</button>
                        <button type="submit" class="btn">Enviar</button>
                    </div>
                </form>
            </div>

            <!-- COMUNICADOS PUBLICADOS -->
            <div class="card">
                <h3>Publicados</h3>
                <ul class="list">
                    <li>
                        <strong>Reunión de docentes</strong>
                        <span>Enviado al director — 25/10/2025</span>
                    </li>
                    <li>
                        <strong>Salida pedagógica - 3° Grado</strong>
                        <span>Enviado a 3°A y 3°B — 22/10/2025</span>
                    </li>
                    <li>
                        <strong>Recordatorio de tareas</strong>
                        <span>General — 20/10/2025</span>
                    </li>
                </ul>
            </div>
        </div>
    </main>
</div>
</body>
</html>

