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
    <title>Recuperar contraseña</title>
</head>
<body>
    <h2>Recuperar contraseña</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>

    <% if (request.getAttribute("mensaje") != null) { %>
        <p style="color:green;"><%= request.getAttribute("mensaje") %></p>
    <% } %>

    <form action="LoginServlet" method="post">
        <input type="hidden" name="accion" value="recuperar">
        <label for="username">Usuario:</label>
        <input type="text" id="username" name="username" required>
        <button type="submit">Recuperar contraseña</button>
    </form>

    <a href="login.jsp">Volver al login</a>
</body>
</html>

