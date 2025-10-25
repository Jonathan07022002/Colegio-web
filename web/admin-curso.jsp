<%-- 
    Document   : admin-curso
    Created on : 18 oct. 2025, 12:11:14 a. m.
    Author     : Jonathan
--%>

<%@page import="ModeloBean.Area"%>
<%@page import="ModeloBean.Curso"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestión de Áreas y Cursos</title>
<style>
html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow-x: hidden; background: #eef3f8; }
.app { display: grid; grid-template-columns: 270px 1fr; height: 100vh; width: 100vw; margin: 0; }
.sidebar { height: 100vh; }
.main { padding: 24px; background: #eef3f8; min-height: 100vh; overflow-y: auto; }
.header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.header-actions h1 { font-size: 1.8rem; color: #333; }
.btn-primary { background: #007bff; color: #fff; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: 0.3s; }
.btn-primary:hover { background: #0056b3; }
.tabs { display: flex; gap: 10px; margin-bottom: 20px; }
.tab { background: #f5f6fa; border: none; padding: 10px 18px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: 0.3s; }
.tab.active { background: #007bff; color: #fff; }
table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e6e6e6; }
th { background: #f5f6fa; color: #333; font-weight: 600; }
tr:hover { background: #f9f9ff; }
.modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); justify-content: center; align-items: center; z-index: 1000; }
.modal { background: #fff; width: 420px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); padding: 24px; animation: fadeIn 0.3s ease; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
.modal h2 { margin-top: 0; color: #333; }
.form-group { margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
.form-group input, .form-group textarea, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; outline: none; font-family: inherit; }
.form-group textarea { resize: none; height: 80px; }
.modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; }
.btn-secondary { background: #ccc; border: none; padding: 8px 16px; border-radius: 8px; cursor: pointer; font-weight: 500; }
.btn-secondary:hover { background: #bbb; }
.tab-content { display: none; }
.tab-content.active { display: block; }
.btn-action { padding: 6px 12px; margin-right: 4px; border-radius: 6px; border: none; cursor: pointer; font-weight: 500; transition: 0.3s; }
.btn-edit { background: #17a2b8; color: #fff; }
.btn-edit:hover { background: #138496; }
.btn-toggle { background: #ffc107; color: #fff; }
.btn-toggle:hover { background: #e0a800; }
</style>
</head>
<body>
<div class="app">

    <%-- Sidebar --%>
    <jsp:include page="sidebar-admin.jsp" />

    <main class="main">
        <div class="header-actions">
            <h1>Gestión de Áreas y Cursos</h1>
        </div>

        <div class="tabs">
            <button class="tab active" data-tab="areas">Áreas</button>
            <button class="tab" data-tab="cursos">Cursos</button>
        </div>

        <%-- TAB ÁREAS --%>
        <div id="areas" class="tab-content active">
            <div class="header-actions">
                <button class="btn-primary" id="btnOpenAreaModal">+ Crear Área</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Activo</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Area> listaAreas = (List<Area>) request.getAttribute("listaAreas");
                        if (listaAreas != null) {
                            for (Area a : listaAreas) {
                    %>
                    <tr>
                        <td><%= a.getId_area() %></td>
                        <td><%= a.getNombre() %></td>
                        <td><%= a.getDescripcion() %></td>
                        <td><%= a.isActivo() ? "Sí" : "No" %></td>
                        <td>
                            <button type="button" class="btn-action btn-edit"
                                onclick="editarArea('<%= a.getId_area() %>', '<%= a.getNombre() %>', '<%= a.getDescripcion() %>')">Editar</button>
                            <form style="display:inline" action="AreaSVL" method="post">
                                <input type="hidden" name="id_area" value="<%= a.getId_area() %>">
                                <button type="submit" name="accion" value="toggleActivo" class="btn-action btn-toggle">
                                    <%= a.isActivo() ? "Inactivar" : "Activar" %>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%  } } %>
                </tbody>
            </table>
        </div>

        <%-- TAB CURSOS --%>
        <div id="cursos" class="tab-content">
            <div class="header-actions">
                <button class="btn-primary" id="btnOpenCursoModal">+ Crear Curso</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Curso</th>
                        <th>Área</th>
                        <th>Descripción</th>
                        <th>Activo</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Curso> listaCursos = (List<Curso>) request.getAttribute("listaCursos");
                        List<Area> listaAreasSelect = (List<Area>) request.getAttribute("listaAreas");
                        if (listaCursos != null) {
                            for (Curso c : listaCursos) {
                                String nombreArea = "";
                                for (Area a : listaAreasSelect) {
                                    if (a.getId_area() == c.getId_area()) {
                                        nombreArea = a.getNombre();
                                        break;
                                    }
                                }
                    %>
                    <tr>
                        <td><%= c.getId_curso() %></td>
                        <td><%= c.getNombre() %></td>
                        <td><%= nombreArea %></td>
                        <td><%= c.getDescripcion() %></td>
                        <td><%= c.isActivo() ? "Sí" : "No" %></td>
                        <td>
                            <button type="button" class="btn-action btn-edit"
                                onclick="editarCurso('<%= c.getId_curso() %>', '<%= c.getNombre() %>', '<%= c.getDescripcion() %>', '<%= c.getId_area() %>')">Editar</button>
                            <form style="display:inline" action="CursoSVL" method="post">
                                <input type="hidden" name="id_curso" value="<%= c.getId_curso() %>">
                                <button type="submit" name="accion" value="toggleActivo" class="btn-action btn-toggle">
                                <%= c.isActivo() ? "Inactivar" : "Activar" %>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%  } } %>
                </tbody>
            </table>
        </div>

    </main>
</div>

<!-- MODAL ÁREA -->
<div class="modal-overlay" id="modalArea">
    <div class="modal">
        <h2 id="tituloArea">Nueva Área</h2>
        <form id="formArea" action="AreaSVL" method="post">
            <input type="hidden" name="accion" value="agregar">
            <input type="hidden" name="id_area" id="idArea">
            <div class="form-group">
                <label for="nombreArea">Nombre del Área</label>
                <input type="text" id="nombreArea" name="nombre" required>
            </div>
            <div class="form-group">
                <label for="descripcionArea">Descripción</label>
                <textarea id="descripcionArea" name="descripcion" required></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" id="btnCancelArea">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL CURSO -->
<div class="modal-overlay" id="modalCurso">
    <div class="modal">
        <h2 id="tituloCurso">Nuevo Curso</h2>
        <form id="formCurso" action="CursoSVL" method="post">
            <input type="hidden" name="accion" value="agregar">
            <input type="hidden" name="id_curso" id="idCurso">
            <div class="form-group">
                <label for="areaCurso">Área</label>
                <select id="areaCurso" name="id_area" required>
                    <option value="">-- Selecciona un área --</option>
                    <%
                        if (listaAreasSelect != null) {
                            for (Area a : listaAreasSelect) {
                    %>
                    <option value="<%= a.getId_area() %>"><%= a.getNombre() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label for="nombreCurso">Nombre del Curso</label>
                <input type="text" id="nombreCurso" name="nombre" required>
            </div>
            <div class="form-group">
                <label for="descripcionCurso">Descripción</label>
                <textarea id="descripcionCurso" name="descripcion" required></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary" id="btnCancelCurso">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Tabs
    const tabs = document.querySelectorAll('.tab');
    const contents = document.querySelectorAll('.tab-content');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));
            tab.classList.add('active');
            document.getElementById(tab.dataset.tab).classList.add('active');
        });
    });

    // Modal base
    function toggleBodyScroll(disable) { document.body.style.overflow = disable ? 'hidden' : 'auto'; }

    // ÁREA
    const modalArea = document.getElementById('modalArea');
    const btnOpenArea = document.getElementById('btnOpenAreaModal');
    const btnCancelArea = document.getElementById('btnCancelArea');
    btnOpenArea.onclick = () => { abrirModalArea('agregar'); };
    btnCancelArea.onclick = () => { cerrarModal(modalArea); };
    function editarArea(id, nombre, descripcion) {
        document.getElementById('tituloArea').innerText = 'Editar Área';
        document.querySelector('#formArea input[name=accion]').value = 'actualizar';
        document.getElementById('idArea').value = id;
        document.getElementById('nombreArea').value = nombre;
        document.getElementById('descripcionArea').value = descripcion;
        modalArea.style.display = 'flex'; toggleBodyScroll(true);
    }

    // CURSO
    const modalCurso = document.getElementById('modalCurso');
    const btnOpenCurso = document.getElementById('btnOpenCursoModal');
    const btnCancelCurso = document.getElementById('btnCancelCurso');
    btnOpenCurso.onclick = () => { abrirModalCurso('agregar'); };
    btnCancelCurso.onclick = () => { cerrarModal(modalCurso); };
    function editarCurso(id, nombre, descripcion, idArea) {
        document.getElementById('tituloCurso').innerText = 'Editar Curso';
        document.querySelector('#formCurso input[name=accion]').value = 'actualizar';
        document.getElementById('idCurso').value = id;
        document.getElementById('nombreCurso').value = nombre;
        document.getElementById('descripcionCurso').value = descripcion;
        document.getElementById('areaCurso').value = idArea;
        modalCurso.style.display = 'flex'; toggleBodyScroll(true);
    }

    function abrirModalArea(modo) {
        document.getElementById('tituloArea').innerText = 'Nueva Área';
        document.querySelector('#formArea input[name=accion]').value = 'agregar';
        document.getElementById('formArea').reset();
        modalArea.style.display = 'flex'; toggleBodyScroll(true);
    }

    function abrirModalCurso(modo) {
        document.getElementById('tituloCurso').innerText = 'Nuevo Curso';
        document.querySelector('#formCurso input[name=accion]').value = 'agregar';
        document.getElementById('formCurso').reset();
        modalCurso.style.display = 'flex'; toggleBodyScroll(true);
    }

    function cerrarModal(modal) {
        modal.style.display = 'none'; toggleBodyScroll(false);
    }

    [modalArea, modalCurso].forEach(modal => {
        modal.addEventListener('click', e => { if (e.target === modal) cerrarModal(modal); });
    });
</script>

</body>
</html>
