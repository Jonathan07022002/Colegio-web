/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import ModeloBean.Nivel;
import conexion.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Jonathan
 */
public class NivelDAO {
        // ✅ LISTAR niveles
    public List<Nivel> listar() {
        List<Nivel> lista = new ArrayList<>();
        String sql = "SELECT * FROM nivel";

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Nivel n = new Nivel();
                n.setId_nivel(rs.getInt("id_nivel"));
                n.setNombre(rs.getString("nombre"));
                n.setActivo(rs.getInt("activo"));
                lista.add(n);
            }

            System.out.println("🟢 Niveles cargados: " + lista.size());
        } catch (SQLException e) {
            System.err.println("❌ Error al listar niveles: " + e.getMessage());
        }
        return lista;
    }

    // ✅ AGREGAR nivel (SIEMPRE ACTIVO)
    public boolean agregar(Nivel n) {
        String sql = "INSERT INTO nivel(nombre, activo) VALUES (?, 1)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, n.getNombre());
            int filas = ps.executeUpdate();

            if (filas > 0) {
                System.out.println("✅ Nivel creado activo por defecto: " + n.getNombre());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("❌ Error al agregar nivel: " + e.getMessage());
        }
        return false;
    }

    // ✅ BUSCAR por ID
    public Nivel buscarId(int id) {
        Nivel n = null;
        String sql = "SELECT * FROM nivel WHERE id_nivel=?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    n = new Nivel(rs.getInt("id_nivel"), rs.getString("nombre"), rs.getInt("activo"));
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al buscar nivel: " + e.getMessage());
        }
        return n;
    }

    // ✅ ACTUALIZAR nivel (solo nombre)
    public boolean actualizar(Nivel n) {
        String sql = "UPDATE nivel SET nombre=? WHERE id_nivel=?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, n.getNombre());
            ps.setInt(2, n.getId_nivel());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al actualizar nivel: " + e.getMessage());
            return false;
        }
    }

    // ✅ ELIMINAR nivel
    public boolean eliminar(int id) {
        String sql = "DELETE FROM nivel WHERE id_nivel=?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(" Error al eliminar nivel: " + e.getMessage());
            return false;
        }
    }

    // CAMBIAR ESTADO ACTIVO / INACTIVO
    public boolean toggleActivo(int id) {
        String sql = "UPDATE nivel SET activo = CASE WHEN activo = 1 THEN 0 ELSE 1 END WHERE id_nivel=?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(" Error al cambiar estado de nivel: " + e.getMessage());
            return false;
        }
    }

}
