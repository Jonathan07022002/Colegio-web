/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import ModeloBean.Parentesco;
import conexion.conexion;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Jonathan
 */
public class ParentescoDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // ✅ Listar roles
    public List<Parentesco> listar() {
        List<Parentesco> lista = new ArrayList<>();
        String sql = "SELECT * FROM parentesco";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Parentesco parentesco = new Parentesco();
                parentesco.setId(rs.getInt("id_parentesco"));
                parentesco.setNombre(rs.getString("nombre"));
                parentesco.setActivo(rs.getInt("activo"));
                lista.add(parentesco);
            }
        } catch (Exception e) {
            System.out.println("❌ Error al listar " + e.getMessage());
        }
        return lista;
    }

    // ✅ Agregar nuevo rol
    public boolean agregar(Parentesco parentesco) {
        String sql = "INSERT INTO parentesco (nombre, activo) VALUES (?, ?)";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, parentesco.getNombre());
            ps.setInt(2, parentesco.getActivo());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error al agregar rol: " + e.getMessage());
            return false;
        }
    }

    // ✅ Obtener rol por ID
    public Parentesco obtenerPorId(int id) {
        Parentesco parentesco = null;
        String sql = "SELECT * FROM parentesco WHERE id_parentesco = ?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                parentesco = new Parentesco(rs.getInt("id_parentesco"), rs.getString("nombre"), rs.getInt("activo"));
            }
        } catch (Exception e) {
            System.out.println("❌ Error al obtener rol: " + e.getMessage());
        }
        return parentesco;
    }

    // ✅ Actualizar rol
    public boolean actualizar(Parentesco parentesco) {
        String sql = "UPDATE parentesco SET nombre=?, activo=? WHERE id_parentesco=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, parentesco.getNombre());
            ps.setInt(2, parentesco.getActivo());
            ps.setInt(3, parentesco.getId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error al actualizar rol: " + e.getMessage());
            return false;
        }
    }

    // ✅ Eliminar rol
    public boolean eliminar(int id) {
    String sql = "DELETE FROM parentesco WHERE id_parentesco = ?";
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        int filas = ps.executeUpdate();
        return filas > 0;

    } catch (Exception e) {
        System.out.println("Error al eliminar parentesco: " + e.getMessage());
        return false;
    }
}

}
