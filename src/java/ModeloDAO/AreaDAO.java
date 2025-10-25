/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import java.sql.*;
import java.util.*;
import ModeloBean.Area;
import conexion.conexion;

/**
 *
 * @author Jonathan
 */
public class AreaDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<Area> listar() {
        List<Area> lista = new ArrayList<>();
        String sql = "SELECT * FROM area";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Area a = new Area();
                a.setId_area(rs.getInt("id_area"));
                a.setNombre(rs.getString("nombre"));
                a.setDescripcion(rs.getString("descripcion"));
                a.setActivo(rs.getBoolean("activo"));
                lista.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public boolean agregar(Area a) {
        String sql = "INSERT INTO area (nombre, descripcion, activo) VALUES (?, ?, ?)";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, a.getNombre());
            ps.setString(2, a.getDescripcion());
            ps.setBoolean(3, true);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM area WHERE id_area=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean toggleActivo(int id) {
        String sql = "UPDATE area SET activo = NOT activo WHERE id_area=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Area obtenerPorId(int id) {
        Area a = null;
        String sql = "SELECT * FROM area WHERE id_area=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                a = new Area();
                a.setId_area(rs.getInt("id_area"));
                a.setNombre(rs.getString("nombre"));
                a.setDescripcion(rs.getString("descripcion"));
                a.setActivo(rs.getBoolean("activo"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return a;
    }

    public boolean actualizar(Area a) {
        String sql = "UPDATE area SET nombre=?, descripcion=? WHERE id_area=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, a.getNombre());
            ps.setString(2, a.getDescripcion());
            ps.setInt(3, a.getId_area());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

}
