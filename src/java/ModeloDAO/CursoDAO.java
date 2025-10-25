/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import java.sql.*;
import java.util.*;
import ModeloBean.Curso;
import conexion.conexion;

/**
 *
 * @author Jonathan
 */
public class CursoDAO {
        Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<Curso> listar() {
        List<Curso> lista = new ArrayList<>();
        String sql = "SELECT * FROM curso";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Curso c = new Curso();
                c.setId_curso(rs.getInt("id_curso"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setId_area(rs.getInt("id_area"));
                c.setActivo(rs.getBoolean("activo"));
                lista.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public boolean agregar(Curso c) {
        String sql = "INSERT INTO curso (nombre, descripcion, id_area, activo) VALUES (?, ?, ?, ?)";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setInt(3, c.getId_area());
            ps.setBoolean(4, true);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM curso WHERE id_curso=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean toggleActivo(int id) {
        String sql = "UPDATE curso SET activo = NOT activo WHERE id_curso=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Curso obtenerPorId(int id) {
        Curso c = null;
        String sql = "SELECT * FROM curso WHERE id_curso=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                c = new Curso();
                c.setId_curso(rs.getInt("id_curso"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setId_area(rs.getInt("id_area"));
                c.setActivo(rs.getBoolean("activo"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return c;
    }

    public boolean actualizar(Curso c) {
        String sql = "UPDATE curso SET nombre=?, descripcion=?, id_area=? WHERE id_curso=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setInt(3, c.getId_area());
            ps.setInt(4, c.getId_curso());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

}
