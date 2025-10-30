/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import ModeloBean.GradoSeccion;
import conexion.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Jonathan
 */
public class GradoSeccionDAO {
            Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<GradoSeccion> listar() {
        List<GradoSeccion> lista = new ArrayList<>();
        String sql = """
           SELECT gs.id_grado_seccion, g.nombre_grado AS nombre_grado, s.nombre_seccion AS nombre_seccion, t.nombre_turno AS nombre_turno, n.nombre AS nombre_nivel, gs.vacantes AS vacante, gs.anio_escolar AS anio,gs.activo, g.id_grado, s.id_seccion, t.id_turno FROM grado_seccion gs INNER JOIN grado g ON gs.id_grado = g.id_grado INNER JOIN seccion s ON gs.id_seccion = s.id_seccion INNER JOIN turno t ON gs.id_turno = t.id_turno INNER JOIN nivel n ON g.id_nivel = n.id_nivel;
        """;

        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                GradoSeccion gs = new GradoSeccion();
                gs.setId_grado_seccion(rs.getInt("id_grado_seccion"));
                gs.setNombreGrado(rs.getString("nombre_grado"));
                gs.setNombreSeccion(rs.getString("nombre_seccion"));
                gs.setNombreTurno(rs.getString("nombre_turno"));
                gs.setNombreNivel(rs.getString("nombre_nivel"));
                gs.setVacante(rs.getInt("vacante"));
                gs.setAnio(rs.getInt("anio"));
                gs.setActivo(rs.getInt("activo"));
                gs.setId_grado(rs.getInt("id_grado"));
                gs.setId_seccion(rs.getInt("id_seccion"));
                gs.setId_turno(rs.getInt("id_turno"));
                lista.add(gs);
            }

        } catch (SQLException e) {
            System.out.println(" Error al listar GradoSeccion: " + e.getMessage());
        }

        return lista;
    }

    public boolean insertar(GradoSeccion gs) {
        String sql = "INSERT INTO grado_seccion(id_grado, id_seccion, id_turno, vacantes, anio_escolar, activo) VALUES (?, ?, ?, ?, ?, ?);";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, gs.getId_grado());
            ps.setInt(2, gs.getId_seccion());
            ps.setInt(3, gs.getId_turno());
            ps.setInt(4, gs.getVacante());
            ps.setInt(5, 2025);
            ps.setInt(6, 1);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(" Error al insertar GradoSeccion: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return false;
    }

    public GradoSeccion obtenerPorId(int id) {
        GradoSeccion gs = null;
        String sql = "SELECT * FROM grado_seccion WHERE id_grado_seccion = ?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                gs = new GradoSeccion();
                gs.setId_grado_seccion(rs.getInt("id_grado_seccion"));
                gs.setId_grado(rs.getInt("id_grado"));
                gs.setId_seccion(rs.getInt("id_seccion"));
                gs.setId_turno(rs.getInt("id_turno"));
                gs.setVacante(rs.getInt("vacante"));
                gs.setAnio(rs.getInt("anio"));
                gs.setActivo(rs.getInt("activo"));
            }
        } catch (SQLException e) {
            System.out.println(" Error al obtener GradoSeccion: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return gs;
    }

    public boolean actualizar(GradoSeccion gs) {
        String sql = "UPDATE grado_seccion SET id_grado=?, id_seccion=?, id_turno=?, vacante=?, anio=?, activo=? WHERE id_grado_seccion=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, gs.getId_grado());
            ps.setInt(2, gs.getId_seccion());
            ps.setInt(3, gs.getId_turno());
            ps.setInt(4, gs.getVacante());
            ps.setInt(5, gs.getAnio());
            ps.setInt(6, gs.getActivo());
            ps.setInt(7, gs.getId_grado_seccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(" Error al actualizar GradoSeccion: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM grado_seccion WHERE id_grado_seccion=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(" Error al eliminar GradoSeccion: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return false;
    }


}
