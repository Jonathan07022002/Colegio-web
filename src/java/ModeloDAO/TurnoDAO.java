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
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<Turno> listar() {
        List<Turno> lista = new ArrayList<>();
        String sql = "SELECT * FROM turno";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Turno t = new Turno();
                t.setId_turno(rs.getInt("id_turno"));
                t.setNombre_turno(rs.getString("nombre_turno"));
                t.setActivo(rs.getInt("activo"));
                lista.add(t);
            }
        } catch (SQLException e) {
            System.out.println(" Error al listar turnos: " + e.getMessage());
        }
        return lista;
    }

    public Turno obtenerPorId(int id) {
        Turno t = null;
        String sql = "SELECT * FROM turno WHERE id_turno=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                t = new Turno();
                t.setId_turno(rs.getInt("id_turno"));
                t.setNombre_turno(rs.getString("nombre_turno"));
                t.setActivo(rs.getInt("activo"));
            }
        } catch (SQLException e) {
            System.out.println(" Error al obtener turno: " + e.getMessage());
        }
        return t;
    }

    public boolean agregar(Turno t) {
        String sql = "INSERT INTO turno (nombre_turno, activo) VALUES (?, ?)";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, t.getNombre_turno());
            ps.setInt(2, t.getActivo());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println(" Error al agregar turno: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Turno t) {
        String sql = "UPDATE turno SET nombre_turno=?, activo=? WHERE id_turno=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, t.getNombre_turno());
            ps.setInt(2, t.getActivo());
            ps.setInt(3, t.getId_turno());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println(" Error al actualizar turno: " + e.getMessage());
            return false;
        }
    }

    public void eliminar(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}


