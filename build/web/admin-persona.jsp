<%-- 
    Document   : admin-persona
    Created on : 17 oct. 2025, 11:09:02 p. m.
    Author     : Jonathan
--%>

<%@page import="ModeloBean.Rol"%>
<%@page import="ModeloDAO.rolDAO"%>
<%@page import="ModeloBean.Persona"%>
<%@page import="java.util.List"%>

<%@page import="ModeloDAO.PersonaDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
            
            .brand {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 25px;
    }
    .brand img {
      width: 40px;
    }
    .menu a {
      display: block;
      color: #b5b5c3;
      padding: 10px 12px;
      border-radius: 8px;
      text-decoration: none;
      transition: 0.3s;
    }
    .menu a.active, .menu a:hover {
      background: #154e83;
      color: #fff;
    }

    /* Contenido */
    .main {
      padding: 24px;
      overflow-y: auto;
    }

    .header-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .header-actions h1 {
      font-size: 1.8rem;
      color: #0b2f52;
    }

    .btn-primary {
      background: #2563eb;
      color: #fff;
      border: none;
      padding: 10px 18px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: 0.3s;
    }
    .btn-primary:hover { background: #1e4bb3; }

    /* Filtros */
    .filters {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      background: #fff;
      padding: 14px;
      border-radius: 10px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      margin-bottom: 20px;
    }
    .filters input, .filters select {
      padding: 8px 12px;
      border: 1px solid #ccc;
      border-radius: 8px;
      outline: none;
    }

    /* Tabla */
    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 14px;
      border-bottom: 1px solid #e6e6e6;
    }
    th {
      background: #f5f6fa;
      color: #333;
      font-weight: 600;
    }
    tr:hover { background: #f9f9ff; }
    .actions button {
      padding: 6px 12px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 500;
    }
    .btn-edit { background: #0b63f3; color: #fff; }
    .btn-disable { background: #ef4444; color: #fff; }

    /* Paginación */
    .pagination {
      display: flex;
      justify-content: center;
      gap: 6px;
      margin-top: 16px;
    }
    .pagination button {
      border: none;
      background: #ddd;
      padding: 6px 10px;
      border-radius: 6px;
      cursor: pointer;
    }
    .pagination button.active {
      background: #2563eb;
      color: white;
    }

    /* Modal */
    .modal-overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(15, 23, 42, 0.65);
    justify-content: center;
    align-items: center;
    z-index: 1000;
    backdrop-filter: blur(3px);
  }

  .modal-overlay {
  display: none;
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(15, 23, 42, 0.55);
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(3px);
}

.modal {
  background: #fff;
  width: 720px;
  border-radius: 12px;
  box-shadow: 0 12px 40px rgba(0,0,0,0.25);
  padding: 32px 36px;
  animation: modalFadeIn 0.35s ease;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

@keyframes modalFadeIn {
  from { opacity: 0; transform: translateY(-20px) scale(0.97); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

.modal h2 {
  margin: 0 0 18px 0;
  font-size: 1.6rem;
  color: #1e3a8a;
  border-bottom: 2px solid #2563eb;
  padding-bottom: 8px;
}

/* GRID ESTRUCTURA */
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 22px 24px; /* más espacio entre filas y columnas */
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  color: #1f2937;
  font-weight: 600;
  font-size: 0.93rem;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 11px 13px;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  outline: none;
  font-size: 0.95rem;
  transition: all 0.25s ease;
  background: #f9fafb;
}

.form-group input:focus,
.form-group select:focus {
  background: #fff;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
}

/* Rol en una sola fila */
.form-group[style*="grid-column: span 2"] {
  margin-top: 10px;
}

/* Botones */
.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 28px;
}

.btn-secondary {
  background: #e5e7eb;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 500;
  color: #374151;
  transition: background 0.25s;
}

.btn-secondary:hover { background: #d1d5db; }

.btn-primary {
  background: #2563eb;
  color: #fff;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 500;
  transition: background 0.25s;
}

.btn-primary:hover { background: #1d4ed8; }

/* Sombra al pasar el mouse */
.modal:hover {
  box-shadow: 0 14px 45px rgba(0,0,0,0.28);
}

.modal::-webkit-scrollbar {
  width: 6px;
}
.modal::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 6px;
}
.modal::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* Botón flotante (si lo usas mucho) */
#btnOpenModal {
  box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);
}
      .btn-disable {
  background-color: #ff4d4d;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 6px;
  cursor: pointer;
}

.btn-enable {
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 6px;
  cursor: pointer;
}
        </style>
    </head>
    <body>
  <div class="app">

    <%-- Incluir el sidebar --%>
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
        
<%
    List<Persona> lista = (List<Persona>) request.getAttribute("personas");
    List<Rol> listaRoles = (List<Rol>) request.getAttribute("roles");
%>
      <div class="header-actions">
        <h1>Gestión de Personas</h1>
        <button class="btn-primary" id="btnOpenModal">+ Crear Persona</button>
      </div>

      <div class="filters">
        <input type="text" id="filtroNombre" placeholder="Buscar por nombre">
        <input type="text" id="filtroDni" placeholder="Buscar por DNI">
        <select id="filtroRol">
            <option value="">TODOS</option>
            <%
                if (listaRoles != null) {
                    for (Rol r : listaRoles) {
            %>
                <option value="<%= r.getNombre() %>"><%= r.getNombre() %></option>
            <%
                    }
                }
            %>
          </select>
         <select id="filtroActivo" name="filtroactivo">
        <option value="1" selected>Activos</option>
        <option value="0">Inactivos</option>
        <option value="3">Todos</option>
      </select>
        <button class="btn-primary" id="btnFiltrar">Filtrar</button>
      </div>
        <% if (lista == null || lista.isEmpty()) { %>
          <p style="background: #fff; padding: 14px; border-radius: 8px; color: #555;">
            No hay personas registradas.
          </p>
        <% } else { %>
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>DNI</th>
            <th>Nombre completo</th>
            <th>Correo</th>
            <th>Teléfono</th>
            <th>Rol(es)</th>
            <th>Estado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody id="tablaPersonas">
          <% int i=0;
        for (Persona p : lista) {
            
            if (p.getActivo() != 1) continue;
            i++;
      %>
        <tr>
          <td><%= i %></td>
          <td><%= p.getDni() %></td>
          <td><%= p.getNombresCompletos()%></td>
          <td><%= p.getCorreo() %></td>
          <td><%= p.getTelefono() %></td>
          <td><%= p.getRol() != null ? p.getRol() : "Sin rol" %></td>
          <td><%= p.getActivo() == 1 ? "Activo" : "Inactivo" %></td>
          <td>
            <button type="button" class="btn-edit" 
                    onclick="abrirModalEditar('<%= p.getId() %>', '<%= p.getDni() %>', '<%= p.getNombresCompletos() %>', 
                                              '<%= p.getCorreo() %>', '<%= p.getTelefono() %>', 
                                              '<%= p.getDireccion()%>', '<%= p.getRol()%>')">
              Editar
            </button>
            <form action="PersonaSVL" method="post" style="display:inline;">
                <input type="hidden" name="accion" value="cambiarEstado">
                <input type="hidden" name="id" value="<%= p.getId() %>">
                <input type="hidden" name="activo" value="<%= p.getActivo() %>">
                    
                <button type="submit" class="btn-toggle <%= (p.getActivo()==1 ? "btn-disable" : "btn-enable") %>">
                  <%= p.getActivo()==1 ? "Inhabilitar" : "Habilitar" %>
                </button>
              </form>
          </td>
        </tr>
      <%
        }
      %>
        </tbody>
      </table>
    <%}%>
      <div class="pagination">
        <button>&laquo;</button>
        <button class="active">1</button>
        <button>2</button>
        <button>3</button>
        <button>&raquo;</button>
      </div>
    </main>
  </div>
<!-- Modal Crear Persona -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal">
    <h2>Nueva Persona</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div style="color: red; background: #fee2e2; padding: 8px; border-radius: 6px; margin-bottom: 10px;">
        <%= request.getAttribute("error") %>
    </div>
<% } %>
    <form id="formPersona" action="PersonaSVL" method="post" onsubmit="return validarFormulario()">
      <input type="hidden" name="accion" value="agregar">
      
      <div class="form-grid">

        <!-- DNI -->
        <div class="form-group">
            <label>DNI <span style="color:red">*</span></label>
            <div style="display: flex; gap: 8px;">
              <input type="text" name="dni" id="dni" maxlength="8" required placeholder="campo obligatorio" style="flex:1;">
              <button type="button" onclick="consultarDNI()" class="btn-primary" style="white-space: nowrap;">Buscar</button>
            </div>
            <small id="errorDni" style="color:red; display:none;">El DNI debe tener 8 dígitos numéricos.</small>
          </div>

        <!-- Nombres -->
        <div class="form-group">
          <label>Nombres <span style="color:red">*</span></label>
          <!-- Este campo es obligatorio -->
          <input type="text" name="nombres" id="nombres" required placeholder="Ingrese nombres" readonly="readonly">
        </div>

        <!-- Apellido Paterno -->
        <div class="form-group">
          <label>Apellido Paterno <span style="color:red">*</span></label>
          <!-- Este campo es obligatorio -->
          <input type="text" name="apellido_paterno" id="apellido_paterno" readonly="readonly" required>
        </div>

        <!-- Apellido Materno -->
        <div class="form-group">
          <label>Apellido Materno <span style="color:red">*</span></label>
          <!-- Este campo es obligatorio -->
          <input type="text" name="apellido_materno" id="apellido_materno" readonly="readonly" required>
        </div>

        <!-- Fecha de Nacimiento -->
        <div class="form-group">
          <label>Fecha de Nacimiento</label>
          <input type="date" name="fecha_nacimiento" id="fecha_nacimiento" required>
          <small id="errorFecha" style="color:red; display:none;"></small>
        </div>

        <!-- Dirección -->
        <div class="form-group">
          <label>Dirección</label>
          <input type="text" name="direccion" id="direccion">
        </div>

        <!-- Teléfono -->
        <div class="form-group">
          <label>Teléfono</label>
          <input type="text" name="telefono" id="telefono">
        </div>

        <!-- Correo -->
        <div class="form-group">
          <label>Correo <span style="color:red">*</span></label>
          <!-- Este campo es obligatorio -->
          <input type="email" name="correo" id="correo" required placeholder="campo obligatorio">
          <small id="errorCorreo" style="color:red; display:none;">Ingrese un correo válido (ejemplo@correo.com)</small>
        </div>

        <!-- Rol -->
        <div class="form-group" style="grid-column: span 2;">
          <label>Rol <span style="color:red">*</span></label>
          <!-- Este campo es obligatorio -->
          <select id="rol" name="rol" required>
            <%
                for (Rol r : listaRoles) {
                    if(r.getActivo() != 1) continue;
            %>
                <option value="<%= r.getId() %>"><%= r.getNombre() %></option>
            <%
                }
            %>
          </select>
        </div>
      </div>

      <div class="modal-actions">
        <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
        <button type="submit" class="btn-primary">Guardar</button>
      </div>
    </form>
  </div>
          <div id="resultado" style="margin-top: 15px; font-weight: bold;"></div>
</div>

<!-- ============= VALIDACIONES JAVASCRIPT ============= -->
<script>
    
    async function consultarDNI() {
            var dni = document.getElementById("dni").value.trim();
            const resultadoDiv = document.getElementById("resultado");
            resultadoDiv.innerHTML = "Consultando...";

            if (!dni) {
                alert("Por favor, ingrese un DNI.");
                resultadoDiv.innerHTML = "";
                return;
            }
            
            fetch(
                "https://apiperu.dev/api/dni/"+
                dni+
                "?api_token=20b0f85cab7fd4f9d98a7278ab3ca9ad419436448cc6d0e53e66a1f54b086313"
            )
            .then((res)=>res.json())
            .then((data) =>{
                document.getElementById("nombres").value = data.data.nombres || "";
                document.getElementById("apellido_paterno").value = data.data.apellido_paterno || "";
                document.getElementById("apellido_materno").value = data.data.apellido_materno || "";
                document.getElementById("direccion").value = data.data.direccion || "";
  });
    }
function validarFormulario() {
  let valido = true;

  // DNI
  const dni = document.getElementById("dni").value.trim();
  const errorDni = document.getElementById("errorDni");
  if (!/^\d{8}$/.test(dni)) {
    errorDni.style.display = "block";
    valido = false;
  } else {
    errorDni.style.display = "none";
  }

  // CORREO
  const correo = document.getElementById("correo").value.trim();
  const errorCorreo = document.getElementById("errorCorreo");
  const regexCorreo = /^[\w\.-]+@[\w\.-]+\.\w{2,}$/;
  if (!regexCorreo.test(correo)) {
    errorCorreo.style.display = "block";
    valido = false;
  } else {
    errorCorreo.style.display = "none";
  }

  // FECHA DE NACIMIENTO
  const fecha = document.getElementById("fecha_nacimiento").value;
  const errorFecha = document.getElementById("errorFecha");
  if (fecha) {
    const fechaIngresada = new Date(fecha);
    const limite = new Date();
    if (fechaIngresada > hoy) {
      errorFecha.style.display = "block";
      valido = false;
    } else {
      errorFecha.style.display = "none";
    }
  }

  return valido;
}
</script>

  <script>
    const btnOpen = document.getElementById('btnOpenModal');
  const btnCancel = document.getElementById('btnCancelar');
  const modal = document.getElementById('modalOverlay');
  const form = document.getElementById('formPersona');
  const selectRol = document.getElementById('rol');

  // Abrir y cerrar modal
  btnOpen.addEventListener('click', () => modal.style.display = 'flex');
  btnCancel.addEventListener('click', () => modal.style.display = 'none');
  modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });


  // Inicializar roles al abrir el modal
btnOpen.addEventListener('click', () => modal.style.display = 'flex');

const filtroNombre = document.getElementById("filtroNombre");
  const filtroDni = document.getElementById("filtroDni");
  const filtroRol = document.getElementById("filtroRol");
  const tablaPersonas = document.getElementById("tablaPersonas");
  const paginacion = document.querySelector(".pagination");

  const filasOriginales = Array.from(tablaPersonas.rows);
  const filasPorPagina = 10;
  let paginaActual = 1;

  function obtenerFilasFiltradas() {
    const textoNombre = filtroNombre.value.toLowerCase();
    const textoDni = filtroDni.value.toLowerCase();
    const textoRol = filtroRol.value.toLowerCase();

    return filasOriginales.filter(fila => {
      const dni = fila.cells[1].textContent.toLowerCase();
      const nombre = fila.cells[2].textContent.toLowerCase();
      const rol = fila.cells[5].textContent.toLowerCase();

      const coincideDni = dni.includes(textoDni);
      const coincideNombre = nombre.includes(textoNombre);
      const coincideRol = textoRol === "" || rol.includes(textoRol);

      return coincideDni && coincideNombre && coincideRol;
    });
  }

  function mostrarPagina(pagina) {
    const filasFiltradas = obtenerFilasFiltradas();
    const totalPaginas = Math.ceil(filasFiltradas.length / filasPorPagina);

    if (pagina < 1) pagina = 1;
    if (pagina > totalPaginas) pagina = totalPaginas;
    paginaActual = pagina;

    tablaPersonas.innerHTML = "";

    const inicio = (pagina - 1) * filasPorPagina;
    const fin = inicio + filasPorPagina;
    const filasPagina = filasFiltradas.slice(inicio, fin);

    filasPagina.forEach(f => tablaPersonas.appendChild(f));

    renderizarPaginacion(totalPaginas);
  }

  function renderizarPaginacion(totalPaginas) {
    paginacion.innerHTML = "";

    if (totalPaginas <= 1) return; // no mostrar si solo hay 1 página

    const btnPrev = document.createElement("button");
    btnPrev.innerHTML = "&laquo;";
    btnPrev.disabled = (paginaActual === 1);
    btnPrev.addEventListener("click", () => mostrarPagina(paginaActual - 1));
    paginacion.appendChild(btnPrev);

    for (let i = 1; i <= totalPaginas; i++) {
      const btn = document.createElement("button");
      btn.textContent = i;
      if (i === paginaActual) btn.classList.add("active");
      btn.addEventListener("click", () => mostrarPagina(i));
      paginacion.appendChild(btn);
    }

    const btnNext = document.createElement("button");
    btnNext.innerHTML = "&raquo;";
    btnNext.disabled = (paginaActual === totalPaginas);
    btnNext.addEventListener("click", () => mostrarPagina(paginaActual + 1));
    paginacion.appendChild(btnNext);
  }

  function actualizarTabla() {
    mostrarPagina(1);
  }

  // Eventos de filtrado
  filtroNombre.addEventListener("keyup", actualizarTabla);
  filtroDni.addEventListener("keyup", actualizarTabla);
  filtroRol.addEventListener("change", actualizarTabla);
  document.getElementById("btnFiltrar").addEventListener("click", actualizarTabla);

  // Inicializar
  mostrarPagina(1);


  </script>
<script>
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("formPersona");

  if (!form) return;

  form.addEventListener("submit", function(event) {
    const dni = document.getElementById("dni").value.trim();
    const fecha = document.getElementById("fecha_nacimiento").value;
    const errores = [];

    if (!/^\d{8}$/.test(dni)) {
      errores.push("El DNI debe tener exactamente 8 dígitos numéricos.");
    }

    if (fecha) {
      const f = new Date(fecha);
      const hoy = new Date();
      if (f > hoy) {
        errores.push("La fecha de nacimiento no puede ser posterior a hoy.");
      }
    }

    if (errores.length > 0) {
      event.preventDefault();
      alert(errores.join("\n"));
    }
  });
});
</script>
<script>
document.addEventListener("DOMContentLoaded", () => {
  const mostrar = "<%= request.getAttribute("mostrarModal") != null ? request.getAttribute("mostrarModal") : false %>";
  if (mostrar === "true") {
    document.getElementById("modalOverlay").style.display = "flex";
  }
});

function abrirModalEditar(id, dni, nombreCompleto, correo, telefono, direccion, rol) {
  const modal = document.getElementById('modalOverlay');
  const form = document.getElementById('formPersona');

  // Cambiar título y acción del formulario
  modal.querySelector('h2').textContent = 'Editar Persona';
  form.action = 'PersonaSVL';
  form.querySelector('[name="accion"]').value = 'actualizar';
  
  // Dividir nombres completos si es necesario
  const partes = nombreCompleto.split(' ');
  const nombres = partes.slice(0, -2).join(' ');
  const apellidos = partes.slice(-2).join(' ');

  // Llenar datos
  document.getElementById('dni').value = dni;
  document.getElementById('nombres').value = nombres;
  document.getElementById('apellido_paterno').value = apellidos.split(' ')[0] || '';
  document.getElementById('apellido_materno').value = apellidos.split(' ')[1] || '';
  document.getElementById('correo').value = correo;
  document.getElementById('telefono').value = telefono;
  document.getElementById('direccion').value = direccion;
  document.getElementById('rol').value = rol;

  // Bloquear campos que no deben modificarse
  document.getElementById('dni').readOnly = true;
  document.getElementById('nombres').readOnly = true;
  document.getElementById('apellido_paterno').readOnly = true;
  document.getElementById('apellido_materno').readOnly = true;

  // Mostrar el modal
  modal.style.display = 'flex';
}


function cambiarEstado(id, estadoActual) {
  const accion = estadoActual === 1 ? "inhabilitar" : "habilitar";
  const confirmar = confirm(
    `¿Seguro que deseas \${accion === "inhabilitar" ? "inhabilitar" : "habilitar"} a esta persona \${id}?`
  );

  if (!confirmar) return;

  fetch(`PersonaSVL?accion=${accion}&id=${id}`,{
  method: "POST"
    })
    .then(res => res.text())
    .then(res => {
      if (res.ok) {
        alert(`Persona \${accion === "inhabilitar" ? "inhabilitada" : "habilitada"} correctamente`);
        location.reload();
      } else {
        alert("Ocurrió un error al cambiar el estado");
      }
    })
    .catch(() => alert("Error en la conexión"));
}

// Restablecer el modal al abrir para "Crear Persona"
document.getElementById("btnOpenModal").addEventListener("click", () => {
  const modal = document.getElementById('modalOverlay');
  const form = document.getElementById('formPersona');

  modal.querySelector('h2').textContent = 'Nueva Persona';
  form.reset();
  form.querySelector('[name="accion"]').value = 'agregar';

  // Desbloquear todos los campos
  document.getElementById('dni').readOnly = false;
    document.getElementById('nombres').readOnly = true;
  document.getElementById('apellido_paterno').readOnly = true;
  document.getElementById('apellido_materno').readOnly = true;
});

const filtroActivo = document.getElementById("filtroActivo");
const filasOriginales = Array.from(document.querySelectorAll("#tablaPersonas tr"));

filtroActivo.addEventListener("change", () => {
  const valor = filtroActivo.value;
  const cuerpoTabla = document.getElementById("tablaPersonas");
  cuerpoTabla.innerHTML = ""; // limpiar

  filasOriginales.forEach(fila => {
    const estadoTexto = fila.cells[6].textContent.trim().toLowerCase(); // Columna Estado
    const esActivo = estadoTexto === "activo";

    if (
      (valor === "1" && esActivo) ||
      (valor === "0" && !esActivo) ||
      (valor === "todos")
    ) {
      cuerpoTabla.appendChild(fila);
    }
  });
});
</script>
</body>
</html>
