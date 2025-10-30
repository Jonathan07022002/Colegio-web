<%-- 
    Document   : admin-usuario
    Author     : Jonathan
--%>

<%@page import="ModeloBean.Rol"%>
<%@page import="ModeloBean.Usuario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
  /* ===== Guardia: si entra directo al JSP sin pasar por el servlet, redirige para cargar datos ===== */
  List<Usuario> lista = (List<Usuario>) request.getAttribute("listaUsuarios");
  if (lista == null) {
      response.sendRedirect("UsuarioSVL?accion=listar");
      return;
  }
%>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Usuarios</title>
  <style>
      html, body { margin: 0; padding: 0; height: 100%; width: 100%; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; }
      .app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; }
      .main { padding: 24px; background: #eef3f8; overflow-y: auto; }
      .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
      .btn-primary { background: #2563eb; color: #fff; border: none; border-radius: 8px; padding: 10px 14px; cursor: pointer; font-weight: 600; }
      .btn-primary:hover { background: #1e40af; }
      table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; }
      th, td { padding: 12px 14px; border-bottom: 1px solid #e5e7eb; }
      th { background: #f3f4f6; text-align: left; font-weight: 700; color: #111827; }

      /* Botón toggle estado */
      .btn-toggle { border: none; border-radius: 6px; padding: 8px 12px; color: #fff; cursor: pointer; font-weight: 600; }
      .btn-enable  { background: #16a34a; }   /* Habilitar */
      .btn-enable:hover  { background: #15803d; }
      .btn-disable { background: #f59e0b; }   /* Inhabilitar */
      .btn-disable:hover { background: #d97706; }

      /* Badges de estado */
      .badge { display: inline-block; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
      .badge-ok { background: #16a34a; color: #fff; }
      .badge-off { background: #6b7280; color: #fff; }

      /* Overlay / Modal */
      .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.55); z-index:1000; justify-content:center; align-items:center; }
      .modal { background:#fff; border-radius:14px; width:min(560px,92vw); padding:20px; box-shadow: 0 25px 50px -12px rgba(0,0,0,.25); }
      .field { padding:8px 10px; border:1px solid #d1d5db; border-radius:8px; }
      .label { font-weight:600; color:#111827; margin-right:6px; }
      .row { display:flex; gap:8px; align-items:center; margin-top:10px; }
      .muted { color:#64748b; font-size:14px; }
      .alert-ok { background:#dcfce7; color:#065f46; padding:8px 12px; border-radius:8px; margin-bottom:10px; }
      .alert-err { background:#fee2e2; color:#991b1b; padding:8px 12px; border-radius:8px; margin-bottom:10px; }
  </style>
</head>
<body>
  <div class="app">
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
        <%List<Rol> listaRoles = (List<Rol>) request.getAttribute("roles");%>
      <div class="header-actions">
        <h1 style="margin:0;">Gestión de Usuarios</h1>
        <div style="display:flex; gap:10px;">
          <button class="btn-primary" onclick="abrirModalIndividual()">Nuevo Usuario</button>
          <button class="btn-primary" onclick="abrirModalMasivo()">Generar Usuarios</button>
        </div>
      </div>

      <%-- Mensajes flash opcionales (si el servlet los coloca en sesión) --%>
      <%
        String ok = (String) session.getAttribute("flash_ok");
        String err = (String) session.getAttribute("flash_err");
        if (ok != null) { %>
          <div class="alert-ok"><%= ok %></div>
      <%  session.removeAttribute("flash_ok"); }
        if (err != null) { %>
          <div class="alert-err"><%= err %></div>
      <%  session.removeAttribute("flash_err"); } %>

      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Usuario</th>
            <th>Nombre Completo</th>
            <th>Estado</th>
            <th>Fecha de Creación</th>
            <th>Acción</th>
          </tr>
        </thead>
        <tbody>
          <%
            if (!lista.isEmpty()) {
              int i = 1;
              for (Usuario us : lista) {
                  
                String estadoTxt = us.getEstado() != null ? us.getEstado() : "INACTIVO";
                boolean activo = "ACTIVO".equalsIgnoreCase(estadoTxt);
                if(activo == false) continue;
          %>
          <tr>
            <td><%= i++ %></td>
            <td><%= us.getUsername() %></td>
            <td><%= us.getNombreCompleto() %></td>
            <td>
              <span class="badge <%= (activo ? "badge-ok" : "badge-off") %>"><%= estadoTxt %></span>
            </td>
            <td><%= us.getCreatedAt() %></td>
            <td>
              <form action="UsuarioSVL" method="post" style="display:inline;">
                <input type="hidden" name="accion" value="cambiarEstado">
                <input type="hidden" name="id" value="<%= us.getIdUsuario() %>">
                <button type="submit" class="btn-toggle <%= (activo ? "btn-disable" : "btn-enable") %>">
                  <%= activo ? "Inhabilitar" : "Habilitar" %>
                </button>
              </form>
            </td>
          </tr>
          <% } } else { %>
          <tr><td colspan="6" style="text-align:center;">No hay registros disponibles.</td></tr>
          <% } %>
        </tbody>
      </table>
    </main>
  </div>

  <!-- ===== MODAL: Crear Usuario Individual (por DNI) ===== -->
  <div id="modalIndividual" class="modal-overlay">
    <div class="modal">
      <h2 style="margin:0 0 14px;">Crear Usuario Individual</h2>
      <form action="UsuarioSVL" method="get" onsubmit="return validaDniNuevo();">
        <input type="hidden" name="accion" value="crearDesdeDni">
        <div class="row">
          <label class="label" for="dniNuevo">DNI:</label>
          <input type="text" name="dni" id="dniNuevo" placeholder="Ingrese DNI" maxlength="8" class="field" style="width:220px;">
          <button type="submit" class="btn-primary">Crear</button>
          <button type="button" class="btn-primary" onclick="cerrarModalIndividual()" style="background:#334155;">Cerrar</button>
        </div>
        <div id="msgDniNuevo" class="muted" style="color:#b00020; margin-top:8px; display:none;">DNI inválido (8 dígitos).</div>
        <p class="muted" style="margin-top:12px;">
          • Si la persona no tiene correo, se creará institucional con el formato:
          <i>3 primeras letras del nombre + apellido paterno + 2 primeras del materno</i> + <b>@mrn.edu.pe</b>.<br>
          • La contraseña inicial será su <b>DNI</b>.
        </p>
      </form>
    </div>
  </div>

  <!-- ===== MODAL: Generar Usuarios Masivos por Rol ===== -->
  <div id="modalMasivo" class="modal-overlay">
    <div class="modal">
      <h2 style="margin:0 0 14px;">Generar Usuarios Masivos</h2>
      <form action="UsuarioSVL" method="get" onsubmit="return validaRolMasivo();">
        <input type="hidden" name="accion" value="crearMasivoPorRol">
        <div class="row">
          <label class="label" for="rolMasivo">Rol:</label>
          <select id="rolMasivo" name="rol" class="field">
            <option value="">Seleccione rol</option>
                        
                  <option value="ALUMNO">ALUMNO</option>
                  <option value="DOCENTE">DOCENTE</option>
                  <option value="ADMINISTRADOR">ADMINISTRADOR</option>
                  
          </select>
          <button type="submit" class="btn-primary">Generar</button>
          <button type="button" class="btn-primary" onclick="cerrarModalMasivo()" style="background:#334155;">Cerrar</button>
        </div>
        <p class="muted" style="margin-top:12px;">
          • Crea usuarios faltantes y actualiza la contraseña (DNI) de los existentes para el rol elegido.<br>
          • Si la persona no tiene correo, se genera institucional como <i>nomape@mrn.edu.pe</i>.
        </p>
        <div id="msgRolMasivo" class="muted" style="color:#b00020; margin-top:8px; display:none;">Seleccione un rol válido.</div>
      </form>
    </div>
  </div>

  <script>
    /* ===== Abrir / Cerrar modales ===== */
    function abrirModalIndividual(){ document.getElementById('modalIndividual').style.display='flex'; }
    function cerrarModalIndividual(){ document.getElementById('modalIndividual').style.display='none'; }
    function abrirModalMasivo(){ document.getElementById('modalMasivo').style.display='flex'; }
    function cerrarModalMasivo(){ document.getElementById('modalMasivo').style.display='none'; }

    /* ===== Validaciones ===== */
    const dniNuevo = document.getElementById('dniNuevo');
    if (dniNuevo){
      dniNuevo.addEventListener('input', ()=>{ dniNuevo.value = dniNuevo.value.replace(/\D/g,'').slice(0,8); });
    }
    function validaDniNuevo(){
      const msg = document.getElementById('msgDniNuevo');
      if(!/^\d{8}$/.test(dniNuevo.value)){
        msg.style.display='block';
        return false;
      }
      msg.style.display='none';
      return true;
    }
    function validaRolMasivo(){
      const sel = document.getElementById('rolMasivo');
      const msg = document.getElementById('msgRolMasivo');
      if(!sel.value){
        msg.style.display='block';
        return false;
      }
      msg.style.display='none';
      return true;
    }
  </script>
</body>
</html> 