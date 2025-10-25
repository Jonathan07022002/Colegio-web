/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import ModeloBean.Grado;
import conexion.conexion;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Jonathan
 */
public class GradoDAO {
        // ✅ LISTAR GRADOS
    public List<Grado> listar() {
        List<Grado> lista = new ArrayList<>();
        String sql = """
                     SELECT g.id_grado, g.nombre_grado AS nombre, g.id_nivel, g.activo,
                            n.nombre AS nombreNivel
                     FROM grado g
                     INNER JOIN nivel n ON g.id_nivel = n.id_nivel
                     ORDER BY g.id_grado ASC""";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Grado g = new Grado();
                g.setId_grado(rs.getInt("id_grado"));
                g.setNombre(rs.getString("nombre"));
                g.setId_nivel(rs.getInt("id_nivel"));
                g.setActivo(rs.getInt("activo"));
                g.setNombreNivel(rs.getString("nombreNivel"));
                lista.add(g);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al listar grados: " + e.getMessage());
        }
        return lista;
    }

    // ✅ AGREGAR (por defecto activo = 1)
    public boolean agregar(Grado g) {
        String sql = "INSERT INTO grado (nombre_grado, id_nivel, activo) VALUES (?, ?, 1)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, g.getNombre());
            ps.setInt(2, g.getId_nivel());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error al agregar grado: " + e.getMessage());
            return false;
        }
    }

    //  BUSCAR POR ID
    public Grado buscarId(int id) {
        Grado g = null;
        String sql = """
                     SELECT g.id_grado, g.nombre_grado AS nombre, g.id_nivel, g.activo,
                            n.nombre AS nombreNivel
                     FROM grado g
                     INNER JOIN nivel n ON g.id_nivel = n.id_nivel
                     WHERE g.id_grado=?""";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    g = new Grado();
                    g.setId_grado(rs.getInt("id_grado"));
                    g.setNombre(rs.getString("nombre"));
                    g.setId_nivel(rs.getInt("id_nivel"));
                    g.setActivo(rs.getInt("activo"));
                    g.setNombreNivel(rs.getString("nombreNivel"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar grado: " + e.getMessage());
        }
        return g;
    }

    //  ACTUALIZAR (solo nombre y nivel)
    public boolean actualizar(Grado g) {
        String sql = "UPDATE grado SET nombre_grado = ?, id_nivel = ? WHERE id_grado = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, g.getNombre());
            ps.setInt(2, g.getId_nivel());
            ps.setInt(3, g.getId_grado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar grado: " + e.getMessage());
            return false;
        }
    }

    //  ELIMINAR
    public boolean eliminar(int id) {
        String sql = "DELETE FROM grado WHERE id_grado=?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println(" Error al eliminar grado: " + e.getMessage());
            return false;
        }
    }

    // TOGGLE ACTIVO
    public boolean toggleActivo(int id) {
        String sql = "UPDATE grado SET activo = CASE WHEN activo = 1 THEN 0 ELSE 1 END WHERE id_grado = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println(" Error al cambiar estado de grado: " + e.getMessage());
            return false;
        }
    }

}
