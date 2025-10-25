<%-- 
    Document   : admin-usuario
    Created on : 18 oct. 2025, 1:05:02 p. m.
    Author     : Jonathan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Usuarios</title>
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

      .sidebar {
        height: 100vh;
      }

      .main {
        padding: 24px;
        background: #eef3f8;
        min-height: 100vh;
        overflow-y: auto;
      }

      .header-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
      }
      .btn-primary {
        background: #2563eb;
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 8px 12px;
        cursor: pointer;
      }
      .btn-primary:hover { background: #1e40af; }
      .btn-green { background: #16a34a; }
      .btn-green:hover { background: #15803d; }

      table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
      }
      th, td { padding: 10px 14px; border-bottom: 1px solid #e5e7eb; }
      th { background: #f3f4f6; text-align: left; }
      .actions button {
        padding: 5px 8px;
        border-radius: 6px;
        border: none;
        cursor: pointer;
        color: #fff;
      }
      .btn-edit { background: #16a34a; }
      .btn-delete { background: #dc2626; }
      .btn-edit:hover { background: #15803d; }
      .btn-delete:hover { background: #b91c1c; }

      /* MODALES */
      .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0,0,0,0.5);
        justify-content: center;
        align-items: center;
        z-index: 1000;
      }
      .modal {
        background: #fff;
        border-radius: 12px;
        width: 500px;
        padding: 20px;
        animation: fadeIn .3s ease;
      }
      @keyframes fadeIn {
        from {opacity:0; transform: translateY(-10px);}
        to {opacity:1; transform: translateY(0);}
      }
      .modal h2 { margin-bottom: 15px; }
      .modal input, .modal select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 8px;
        margin-bottom: 12px;
      }
      .modal button { margin-right: 8px; }
      .tabla-preview {
        width: 100%;
        border-collapse: collapse;
        background: #f9fafb;
        border-radius: 8px;
        margin-top: 8px;
      }
      .tabla-preview th, .tabla-preview td {
        padding: 6px;
        border: 1px solid #e5e7eb;
        font-size: 13px;
      }
  </style>
</head>
<body id="page-users">
  <div class="app">
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
      <div class="header-actions">
        <h1>Gestión de Usuarios</h1>
        <div style="display:flex; gap:10px;">
          <button class="btn-primary" onclick="abrirModalIndividual()">Nuevo Usuario</button>
          <button class="btn-primary" onclick="abrirModalMasivo()">Generar Usuarios</button>
        </div>
      </div>

      <!-- TABLA PRINCIPAL -->
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Usuario</th>
            <th>Nombre Completo</th>
            <th>Estado</th>
            <th>Fecha de Creación</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <%-- Ejemplo temporal, luego se llena desde servlet --%>
          <tr>
            <td>1</td>
            <td>cargarciar@mrn.edu.pe</td>
            <td>Carlos Alberto García Ramos</td>
            <td>Activo</td>
            <td>2025-10-18</td>
            <td class="actions">
              <button class="btn-edit">Editar</button>
              <button class="btn-delete">Inhabilitar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </main>
  </div>

  <!-- MODAL INDIVIDUAL -->
  <div class="modal-overlay" id="modalIndividual">
    <div class="modal">
      <h2>Crear Usuario Individual</h2>
      <label>DNI:</label>
      <div style="display:flex; gap:10px;">
        <input type="text" id="dniBuscar" placeholder="Ingrese DNI">
        <button class="btn-primary" onclick="buscarPersona()">Buscar</button>
      </div>

      <div id="infoPersona" style="display:none; margin-top:10px;">
        <p><strong>Nombre:</strong> <span id="nombrePersona"></span></p>
        <button class="btn-primary" onclick="crearUsuario()">Crear Usuario</button>
      </div>

      <div style="text-align:right; margin-top:10px;">
          <button class="btn-primary" onclick="cerrarModalIndividual()">Cerrar</button>
      </div>
    </div>
  </div>

  <!-- MODAL MASIVO -->
  <div class="modal-overlay" id="modalMasivo">
    <div class="modal">
      <h2>Generar Usuarios</h2>
      <label>Rol:</label>
      <select id="rolFiltro">
        <option value="">Seleccione rol</option>
        <option value="Alumno">Alumno</option>
        <option value="Docente">Docente</option>
        <option value="Apoderado">Apoderado</option>
      </select>

      <div id="filtrosAcademicos" style="display:none;">
        <label>Nivel:</label>
        <select id="nivelFiltro">
          <option value="">Seleccione nivel</option>
          <option value="Inicial">Inicial</option>
          <option value="Primaria">Primaria</option>
          <option value="Secundaria">Secundaria</option>
        </select>

        <label>Grado:</label>
        <select id="gradoFiltro"></select>

        <label>Sección:</label>
        <select id="seccionFiltro"></select>
      </div>

      <button class="btn-primary" onclick="previsualizarUsuarios()">Previsualizar</button>

      <div id="contenedorPreview" style="display:none; max-height:200px; overflow-y:auto;">
        <table class="tabla-preview" id="tablaPreview">
          <thead><tr><th>DNI</th><th>Nombre</th><th>Estado</th></tr></thead>
          <tbody></tbody>
        </table>
      </div>

      <div style="margin-top:10px;">
        <button class="btn-primary" onclick="crearUsuariosMasivos()">Generar Usuarios</button>
        <button class="btn-primary" onclick="cerrarModalMasivo()">Cerrar</button>
      </div>
    </div>
  </div>

  <script>
    const modalIndividual = document.getElementById('modalIndividual');
    const modalMasivo = document.getElementById('modalMasivo');
    let personaSeleccionada = null;

    // --- INDIVIDUAL ---
    function abrirModalIndividual() { modalIndividual.style.display = 'flex'; }
    function cerrarModalIndividual() { modalIndividual.style.display = 'none'; }

    function buscarPersona() {
      const dni = document.getElementById('dniBuscar').value.trim();
      if (!dni) return alert("Ingrese un DNI para buscar.");

      fetch(`UsuarioController?accion=buscarPersona&dni=${dni}`)
        .then(r => r.json())
        .then(data => {
          if (data && data.id) {
            personaSeleccionada = data;
            document.getElementById('nombrePersona').textContent =
              data.nombres + ' ' + data.apellido_paterno + ' ' + data.apellido_materno;
            document.getElementById('infoPersona').style.display = 'block';
          } else alert('No se encontró persona con ese DNI.');
        });
    }

    function crearUsuario() {
      if (!personaSeleccionada) return;

      fetch('UsuarioController?accion=crear', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ personaId: personaSeleccionada.id })
      })
      .then(r => r.text())
      .then(res => {
        if (res === 'ok') {
          alert('Usuario creado correctamente');
          location.reload();
        } else alert('Error: ' + res);
      });
    }

    // --- MASIVO ---
    document.getElementById('rolFiltro').addEventListener('change', e => {
      document.getElementById('filtrosAcademicos').style.display =
        (e.target.value === 'Alumno') ? 'block' : 'none';
    });

    function abrirModalMasivo() { modalMasivo.style.display = 'flex'; }
    function cerrarModalMasivo() { modalMasivo.style.display = 'none'; }

    function previsualizarUsuarios() {
      const rol = document.getElementById('rolFiltro').value;
      const nivel = document.getElementById('nivelFiltro').value;
      const grado = document.getElementById('gradoFiltro').value;
      const seccion = document.getElementById('seccionFiltro').value;

      if (!rol) return alert('Seleccione un rol.');
      fetch(`UsuarioController?accion=listarSinUsuario&rol=${rol}&nivel=${nivel}&grado=${grado}&seccion=${seccion}`)
        .then(r => r.json())
        .then(data => {
          const tbody = document.querySelector('#tablaPreview tbody');
          tbody.innerHTML = '';
          data.forEach(p => {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td>${p.dni}</td><td>${p.nombres} ${p.apellido_paterno}</td><td>${p.estado || 'Sin usuario'}</td>`;
            tbody.appendChild(tr);
          });
          document.getElementById('contenedorPreview').style.display = 'block';
        });
    }

    function crearUsuariosMasivos() {
      const rol = document.getElementById('rolFiltro').value;
      const nivel = document.getElementById('nivelFiltro').value;
      const grado = document.getElementById('gradoFiltro').value;
      const seccion = document.getElementById('seccionFiltro').value;
      if (!rol) return alert('Seleccione un rol.');

      if (!confirm(`¿Desea generar usuarios para todos los ${rol}s seleccionados?`)) return;

      fetch('UsuarioController?accion=crearMasivo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ rol, nivel, grado, seccion })
      })
      .then(r => r.text())
      .then(res => {
        if (res === 'ok') {
          alert('Usuarios generados correctamente.');
          location.reload();
        } else alert('Error: ' + res);
      });
    }

    modalIndividual.addEventListener('click', e => { if (e.target === modalIndividual) cerrarModalIndividual(); });
    modalMasivo.addEventListener('click', e => { if (e.target === modalMasivo) cerrarModalMasivo(); });
  </script>
</body>
</html>