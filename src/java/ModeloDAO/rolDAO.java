/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import conexion.conexion;
import ModeloBean.Rol;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Jonathan
 */
public class rolDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // ✅ Listar roles
    public List<Rol> listar() {
        List<Rol> lista = new ArrayList<>();
        String sql = "SELECT * FROM rol";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Rol rol = new Rol();
                rol.setId(rs.getInt("id_rol"));
                rol.setNombre(rs.getString("nombre_rol"));
                rol.setDescripcion(rs.getString("descripcion"));
                lista.add(rol);
            }
        } catch (Exception e) {
            System.out.println("❌ Error al listar roles: " + e.getMessage());
        }
        return lista;
    }

    // ✅ Agregar nuevo rol
    public boolean agregar(Rol rol) {
        String sql = "INSERT INTO rol (nombre_rol, descripcion) VALUES (?, ?)";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, rol.getNombre());
            ps.setString(2, rol.getDescripcion());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error al agregar rol: " + e.getMessage());
            return false;
        }
    }

    // ✅ Obtener rol por ID
    public Rol obtenerPorId(int id) {
        Rol rol = null;
        String sql = "SELECT * FROM rol WHERE id_rol = ?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                rol = new Rol(rs.getInt("id_rol"), rs.getString("nombre_rol"), rs.getString("descripcion"));
            }
        } catch (Exception e) {
            System.out.println("❌ Error al obtener rol: " + e.getMessage());
        }
        return rol;
    }

    // ✅ Actualizar rol
    public boolean actualizar(Rol rol) {
        String sql = "UPDATE rol SET nombre_rol=?, descripcion=? WHERE id_rol=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, rol.getNombre());
            ps.setString(2, rol.getDescripcion());
            ps.setInt(3, rol.getId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error al actualizar rol: " + e.getMessage());
            return false;
        }
    }

    // ✅ Eliminar rol
    public boolean eliminar(int id) {
        String sql = "DELETE FROM rol WHERE id_rol=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error al eliminar rol: " + e.getMessage());
            return false;
        }
    }

}
