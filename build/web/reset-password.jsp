<%-- 
    Document   : reset-password
    Created on : 30 oct. 2025, 12:13:21 a. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Restablecer contraseña</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root{
      --bg:#eef3f8;--card:#fff;--muted:#6b7280;--text:#0b2f52;
      --primary:#2563eb;--ring:rgba(37,99,235,.15);
      --cta:#ff7a59;--cta-hover:#ff6a45;--shadow:0 10px 20px rgba(0,0,0,.06),0 6px 6px rgba(0,0,0,.04);
      --radius:18px;
      --ok:#0a7a35;--err:#b91c1c;
    }
    *{box-sizing:border-box}
    html,body{height:100%;margin:0;font-family:'Segoe UI',Tahoma,sans-serif;background:var(--bg);color:var(--text)}
    .wrap{min-height:100vh;display:grid;place-items:center;padding:32px}
    .panel{width:min(560px,94vw);background:var(--card);border-radius:var(--radius);box-shadow:var(--shadow);padding:30px}
    .brand{display:flex;align-items:center;gap:12px;margin-bottom:10px}
    .brand img{width:42px;height:42px;border-radius:10px}
    h2{margin:.25rem 0 1.25rem;font-size:1.5rem;font-weight:800}
    .muted{color:var(--muted);font-size:.95rem;margin:0 0 18px}
    label{display:block;font-size:.9rem;margin:8px 2px 6px;color:#0f172a;font-weight:600}
    input{width:100%;padding:13px 14px;border-radius:12px;border:1px solid #e5e7eb;background:#fff;outline:none;font-size:1rem;transition:.15s border,.15s box-shadow}
    input:focus{border-color:var(--primary);box-shadow:0 0 0 4px var(--ring)}
    .actions{margin-top:16px;display:flex;gap:10px;align-items:center;justify-content:space-between}
    .btn{display:inline-block;border:none;cursor:pointer;font-weight:700;letter-spacing:.2px;padding:12px 16px;border-radius:14px}
    .btn-cta{background:var(--cta);color:#fff}.btn-cta:hover{background:var(--cta-hover)}
    .link{color:#2563eb;text-decoration:none;font-weight:600}
    .msg{margin:10px 2px;font-size:.95rem}.msg.ok{color:#0a7a35}.msg.err{color:#b00020}

    /* checklist & progress */
    #pw-helper{margin-top:12px}
    #pwChecklist{list-style:none;padding-left:0;margin-top:6px;line-height:1.7}
    #pwChecklist li{color:var(--err);display:flex;align-items:center;gap:6px;font-size:.9rem;transition:.2s}
    #pwChecklist li.ok{color:var(--ok)}
    #pw-bar{height:6px;border-radius:4px;background:#ddd;margin-top:10px;overflow:hidden}
    #pw-fill{height:100%;width:0;background:linear-gradient(90deg,#ef4444,#f59e0b,#22c55e);transition:width .25s}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="panel">
      <div class="brand">
        <img src="<%=request.getContextPath()%>/assets/img/logo.png" alt="MRN" />
        <h1>Intranet MRN</h1>
      </div>
      <h2>Verifica tu código</h2>
      <p class="muted">Hemos enviado un código de 6 dígitos a tu correo. Ingresa el código y tu nueva contraseña.</p>

      <form action="ResetPassword" method="post" id="frmCode" novalidate>
        <input type="hidden" name="accion" value="confirmarCodigo">
        <input type="hidden" name="dni" value="<%= request.getParameter("dni") != null ? request.getParameter("dni") : "" %>">
        <input type="hidden" name="correo" value="<%= request.getParameter("correo") != null ? request.getParameter("correo") : "" %>">

        <label for="codigo">Código</label>
        <input id="codigo" name="codigo" type="text" maxlength="6" required>

        <label for="pass1">Nueva contraseña</label>
        <input id="pass1" name="pass1" type="password" required>

        <label for="pass2">Repite la nueva contraseña</label>
        <input id="pass2" name="pass2" type="password" required>

        <!-- checklist visual -->
        <div id="pw-helper">
          <ul id="pwChecklist">
            <li data-check="len">• Mínimo 8 caracteres</li>
            <li data-check="upper">• Al menos 1 mayúscula</li>
            <li data-check="lower">• Al menos 1 minúscula</li>
            <li data-check="num">• Al menos 1 número</li>
            <li data-check="sym">• Al menos 1 carácter especial</li>
            <li data-check="match">• Las contraseñas coinciden</li>
          </ul>
          <div id="pw-bar"><div id="pw-fill"></div></div>
        </div>

        <% if (request.getAttribute("msg") != null) { %>
          <div class="msg err"><%= request.getAttribute("msg") %></div>
        <% } %>
        <% if (request.getAttribute("info") != null) { %>
          <div class="msg ok"><%= request.getAttribute("info") %></div>
        <% } %>

        <div class="actions">
          <a class="link" href="forgot-password.jsp">Volver</a>
          <button id="btnCambiar" class="btn btn-cta" type="submit" disabled>Cambiar contraseña</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    const codigo = document.getElementById('codigo');
    codigo.addEventListener('input', ()=>{ codigo.value = codigo.value.replace(/\D/g,'').slice(0,6); });

    const pass1 = document.getElementById('pass1');
    const pass2 = document.getElementById('pass2');
    const checklist = document.getElementById('pwChecklist');
    const btn = document.getElementById('btnCambiar');
    const bar = document.getElementById('pw-fill');

    const hasLen = s => s.length >= 8;
    const hasUpper = s => /[A-Z]/.test(s);
    const hasLower = s => /[a-z]/.test(s);
    const hasNum = s => /\d/.test(s);
    const hasSym = s => /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?`~]/.test(s);

    function toggle(item, ok) {
      const li = checklist.querySelector(`li[data-check="${item}"]`);
      if (!li) return;
      li.classList.toggle('ok', ok);
      li.innerHTML = ok
        ? `<svg width="16" height="16" fill="#0a7a35"><path d="M6 10l-2-2 1.5-1.5L6 7l4.5-4.5L12 4l-6 6z"/></svg>` + li.textContent.replace(/^✔ |^• /,'')
        : `<svg width="16" height="16" fill="#b91c1c"><circle cx="8" cy="8" r="7"/></svg>` + li.textContent.replace(/^✔ |^• /,'');
    }

    function validate() {
      const p1 = pass1.value || '';
      const p2 = pass2.value || '';
      const v = {
        len: hasLen(p1),
        upper: hasUpper(p1),
        lower: hasLower(p1),
        num: hasNum(p1),
        sym: hasSym(p1),
        match: p1.length>0 && p1 === p2
      };
      Object.keys(v).forEach(k => toggle(k, v[k]));

      const okCount = Object.values(v).filter(Boolean).length;
      bar.style.width = (okCount / 6 * 100) + '%';
      btn.disabled = okCount < 6;
    }

    ['input','blur'].forEach(evt => {
      pass1.addEventListener(evt, validate);
      pass2.addEventListener(evt, validate);
    });
  </script>
</body>
</html>
