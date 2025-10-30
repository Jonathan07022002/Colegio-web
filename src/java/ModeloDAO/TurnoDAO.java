/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import ModeloBean.Turno;
import conexion.conexion; //  usa tu clase real de conexión
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Jonathan
 */
public class TurnoDAO {
        // Lista todos los turnos
    public List<Turno> listar() {
        List<Turno> lista = new ArrayList<>();
        String sql = "SELECT id_turno, nombre_turno, activo FROM turno ORDER BY id_turno ASC";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Turno t = new Turno();
                t.setId_turno(rs.getInt("id_turno"));
                t.setNombre_turno(rs.getString("nombre_turno"));
                t.setActivo(rs.getInt("activo"));
                lista.add(t);
            }
        } catch (SQLException e) {
            System.err.println("TurnoDAO.listar -> " + e.getMessage());
        }
        return lista;
    }

    // Obtener por id
    public Turno obtenerPorId(int id) {
        Turno t = null;
        String sql = "SELECT id_turno, nombre_turno, activo FROM turno WHERE id_turno = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    t = new Turno();
                    t.setId_turno(rs.getInt("id_turno"));
                    t.setNombre_turno(rs.getString("nombre_turno"));
                    t.setActivo(rs.getInt("activo"));
                }
            }
        } catch (SQLException e) {
            System.err.println("TurnoDAO.obtenerPorId -> " + e.getMessage());
        }
        return t;
    }

    // Verifica si existe un turno con el mismo nombre (ignorando mayúsculas/minúsculas)
    public boolean existeNombre(String nombre) {
        String sql = "SELECT COUNT(*) FROM turno WHERE LOWER(nombre_turno) = LOWER(?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre == null ? "" : nombre.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("TurnoDAO.existeNombre -> " + e.getMessage());
        }
        return false;
    }

    // Verifica si existe nombre en otro id (para actualizar)
    public boolean existeNombreExcepto(String nombre, int idExcepto) {
        String sql = "SELECT COUNT(*) FROM turno WHERE LOWER(nombre_turno) = LOWER(?) AND id_turno <> ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre == null ? "" : nombre.trim());
            ps.setInt(2, idExcepto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("TurnoDAO.existeNombreExcepto -> " + e.getMessage());
        }
        return false;
    }

    // Cuenta cuántos turnos hay (para límite de 3)
    public int contarTurnos() {
        String sql = "SELECT COUNT(*) FROM turno";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("TurnoDAO.contarTurnos -> " + e.getMessage());
        }
        return 0;
    }

    // Agregar turno
    public boolean agregar(Turno t) {
        String sql = "INSERT INTO turno (nombre_turno, activo) VALUES (?, ?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getNombre_turno());
            ps.setInt(2, t.getActivo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("TurnoDAO.agregar -> " + e.getMessage());
            return false;
        }
    }

    // Actualizar turno
    public boolean actualizar(Turno t) {
        String sql = "UPDATE turno SET nombre_turno = ?, activo = ? WHERE id_turno = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getNombre_turno());
            ps.setInt(2, t.getActivo());
            ps.setInt(3, t.getId_turno());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("TurnoDAO.actualizar -> " + e.getMessage());
            return false;
        }
    }

    // ToggleActivo (alternar)
    public boolean toggleActivo(int id) {
        String sql = "UPDATE turno SET activo = CASE WHEN activo = 1 THEN 0 ELSE 1 END WHERE id_turno = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("TurnoDAO.toggleActivo -> " + e.getMessage());
            return false;
        }
    }

}


