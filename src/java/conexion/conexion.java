package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class conexion {

    // Ajusta si quieres tu zona horaria
    private static final String URL =
        "jdbc:mysql://localhost:3307/colegio" +
        "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" +
        "&useUnicode=true&characterEncoding=UTF-8";

    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static void cerrarConexion() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public conexion() {} // no instanciable

    /** Devuelve SIEMPRE una nueva conexión. */
    public static Connection getConexion() {
        try {
            // (Desde JDBC 4 no es obligatorio, pero no estorba)
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection cn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Conexión nueva abierta");
            return cn;
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("No se encontró el driver MySQL", e);
        } catch (SQLException e) {
            throw new RuntimeException("Error al conectar con la BD", e);
        }
    }

    /** Cierra recursos en silencio (útil en servicios sin try-with-resources). */
    public static void closeQuietly(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}