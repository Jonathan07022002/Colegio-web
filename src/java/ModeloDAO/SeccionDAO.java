/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import ModeloBean.Seccion;
import conexion.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Jonathan
 */
public class SeccionDAO {
    // Listar todas las secciones
    public List<Seccion> listar() {
        List<Seccion> lista = new ArrayList<>();
        String sql = "SELECT id_seccion, nombre_seccion AS nombre, aforo_max, activo FROM seccion ORDER BY id_seccion ASC";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Seccion s = new Seccion();
                s.setId_seccion(rs.getInt("id_seccion"));
                s.setNombre(rs.getString("nombre"));
                s.setAforo_max(rs.getInt("aforo_max"));
                s.setActivo(rs.getInt("activo"));
                lista.add(s);
            }
        } catch (SQLException e) {
            System.err.println("❌ SeccionDAO.listar -> " + e.getMessage());
        }
        return lista;
    }

    // Verificar si existe una sección con el mismo nombre
    public boolean existeNombre(String nombre) {
        String sql = "SELECT COUNT(*) FROM seccion WHERE LOWER(nombre_seccion) = LOWER(?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ SeccionDAO.existeNombre -> " + e.getMessage());
        }
        return false;
    }

    // Agregar nueva sección (por defecto activa)
    public boolean agregar(Seccion s) {
        String sql = "INSERT INTO seccion (nombre_seccion, aforo_max, activo) VALUES (?, ?, 1)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getNombre());
            ps.setInt(2, s.getAforo_max());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ SeccionDAO.agregar -> " + e.getMessage());
            return false;
        }
    }

    // Obtener por id
    public Seccion obtenerPorId(int id) {
        Seccion s = null;
        String sql = "SELECT id_seccion, nombre_seccion, aforo_max, activo FROM seccion WHERE id_seccion = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    s = new Seccion();
                    s.setId_seccion(rs.getInt("id_seccion"));
                    s.setNombre(rs.getString("nombre_seccion"));
                    s.setAforo_max(rs.getInt("aforo_max"));
                    s.setActivo(rs.getInt("activo"));
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ SeccionDAO.obtenerPorId -> " + e.getMessage());
        }
        return s;
    }

    // Actualizar
    public boolean actualizar(Seccion s) {
        String sql = "UPDATE seccion SET nombre_seccion = ?, aforo_max = ? WHERE id_seccion = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getNombre());
            ps.setInt(2, s.getAforo_max());
            ps.setInt(3, s.getId_seccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ SeccionDAO.actualizar -> " + e.getMessage());
            return false;
        }
    }

    // Alternar estado activo/inactivo
    public boolean toggleActivo(int id) {
        String sql = "UPDATE seccion SET activo = CASE WHEN activo = 1 THEN 0 ELSE 1 END WHERE id_seccion = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println(" SeccionDAO.toggleActivo -> " + e.getMessage());
            return false;
        }
    }

}
