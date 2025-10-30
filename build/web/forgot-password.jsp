<%-- 
    Document   : forgot-password
    Created on : 24 oct. 2025, 11:50:49 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Olvidé mi contraseña</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <style>
    :root {
      --bg:#eef3f8; --card:#fff; --muted:#6b7280; --text:#0b2f52;
      --primary:#2563eb; --primary-hover:#1e40af; --cta:#ff7a59; --cta-hover:#ff6a45;
      --ring:rgba(37,99,235,.15); --shadow:0 10px 20px rgba(0,0,0,.06), 0 6px 6px rgba(0,0,0,.04);
      --shadow-cta:0 10px 18px rgba(255,122,89,.35); --radius:18px;
    }
    *{box-sizing:border-box} html,body{height:100%;margin:0;font-family:'Segoe UI',Tahoma,sans-serif;background:var(--bg);color:var(--text)}
    .wrap{min-height:100vh;display:grid;place-items:center;padding:32px}
    .grid{width:min(1100px,94vw);display:grid;grid-template-columns:1.1fr 1fr;gap:28px;align-items:center}
    .left{min-height:420px;border-radius:22px;box-shadow:var(--shadow);
      background:#7a0f12 url('<%=request.getContextPath()%>/assets/img/banner-login.jpg') center/cover no-repeat}
    .panel{background:var(--card);border-radius:var(--radius);box-shadow:var(--shadow);padding:34px 30px}
    .brand{display:flex;align-items:center;gap:12px;margin-bottom:10px}
    .brand img{width:42px;height:42px;border-radius:10px}
    .brand h1{font-size:1.25rem;margin:0;font-weight:800;color:var(--text)}
    .title{margin:.25rem 0 1.25rem;font-size:1.5rem;font-weight:800}
    .muted{color:var(--muted);font-size:.95rem;margin:0 0 18px}
    label{display:block;font-size:.9rem;margin:8px 2px 6px;color:#0f172a;font-weight:600}
    input{width:100%;padding:13px 14px;border-radius:12px;border:1px solid #e5e7eb;background:#fff;outline:none;font-size:1rem;transition:.15s border,.15s box-shadow}
    input:focus{border-color:var(--primary);box-shadow:0 0 0 4px var(--ring)}
    .actions{margin-top:16px;display:flex;gap:10px;align-items:center;justify-content:space-between}
    .btn{display:inline-block;border:none;cursor:pointer;font-weight:700;letter-spacing:.2px;padding:12px 16px;border-radius:14px;transition:transform .06s,box-shadow .2s,background .2s}
    .btn-cta{background:var(--cta);color:#fff;box-shadow:var(--shadow-cta)}
    .btn-cta:hover{background:var(--cta-hover);transform:translateY(-1px)}
    .link{color:var(--primary);text-decoration:none;font-weight:600}
    .link:hover{color:var(--primary-hover);text-decoration:underline}
    .msg{margin:10px 2px;font-size:.95rem}.msg.ok{color:#0a7a35}.msg.err{color:#b00020}
    @media (max-width:980px){.grid{grid-template-columns:1fr}.left{order:-1;min-height:220px}}
  </style>
</head>

<body>
  <div class="wrap">
    <div class="grid">
      <div class="left"></div>
      <div class="panel">
        <div class="brand">
          <img src="<%=request.getContextPath()%>/assets/img/logo.png" alt="MRN" />
          <h1>Intranet MRN</h1>
        </div>

        <h2 class="title">Recuperar contraseña</h2>
        <p class="muted">Ingresa tu <b>DNI</b> y el <b>correo</b> registrado para enviarte un código seguro.</p>

        <form id="frmReset" method="post" novalidate>
          <label for="dni">DNI</label>
          <input id="dni" name="dni" type="text" maxlength="8" autocomplete="off" required />

          <label for="correo">Correo</label>
          <input id="correo" name="correo" type="email" autocomplete="off" required />

          <div id="mensaje" class="msg" style="display:none;"></div>

          <div class="actions">
            <a class="link" href="login.jsp">Volver a iniciar sesión</a>
            <button class="btn btn-cta" type="submit">Enviar instrucciones</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    const frm = document.getElementById('frmReset');
    const dni = document.getElementById('dni');
    const correo = document.getElementById('correo');
    const box = document.getElementById('mensaje');

    // Solo dígitos y tope 8
    dni.addEventListener('input', () => { dni.value = dni.value.replace(/\D/g,'').slice(0,8); });

    frm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const vDni = dni.value.trim();
      const vMail = correo.value.trim();

      // Validaciones front
      if (!/^\d{8}$/.test(vDni)) return showMsg('⚠️ El DNI debe tener exactamente 8 dígitos.', false);
      const emailRegex = /^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/; // ✅ regex correcta
      if (!emailRegex.test(vMail)) return showMsg('⚠️ Ingresa un correo electrónico válido.', false);

      showMsg('Verificando datos…', true, true);

      try {
        // Evita `` en JSP; usa concatenación
        const url = 'ResetPassword?accion=enviarCodigo'
                  + '&dni=' + encodeURIComponent(vDni)
                  + '&correo=' + encodeURIComponent(vMail);

        const res = await fetch(url);
        const data = await res.json();

        if (data.ok) {
          showMsg('✅ Código enviado. Revisa tu bandeja o SPAM.', true);
          // Pasa a la pantalla de código:
          window.location.href = 'reset-password.jsp'
            + '?dni=' + encodeURIComponent(vDni)
            + '&correo=' + encodeURIComponent(vMail);
        } else {
          showMsg('❌ ' + (data.msg || 'El DNI y el correo no coinciden.'), false);
        }
      } catch (err) {
        showMsg('Error de conexión con el servidor.', false);
      }
    });

    function showMsg(text, ok, loading){
      box.style.display='block';
      box.className = 'msg ' + (ok ? 'ok':'err');
      box.textContent = loading ? (text+'…') : text;
    }
  </script>
</body>
</html>