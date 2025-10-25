/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import ModeloBean.Apoderado;
import conexion.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Jonathan
 */
public class ApoderadoDAO {
    public List<Apoderado> listar() {
        List<Apoderado> lista = new ArrayList<>();
        String sql = "SELECT a.id, a.alumno_id, a.apoderado_id, a.parentesco_id," +
                     "pa.nombre AS parentesco_nombre, " +
                     "CONCAT(p1.nombres, ' ', p1.apellido_paterno, ' ', p1.apellido_materno) AS nombre_alumno, " +
                     "CONCAT(p2.nombres, ' ', p2.apellido_paterno, ' ', p2.apellido_materno) AS nombre_apoderado " +
                     "FROM apoderado a " +
                     "LEFT JOIN parentesco pa ON a.parentesco_id = pa.id_parentesco " +
                     "LEFT JOIN persona_rol pr1 ON a.alumno_id = pr1.id " +
                     "LEFT JOIN persona pr_persona1 ON pr1.persona_id = pr_persona1.id " +
                     "LEFT JOIN persona_rol pr2 ON a.apoderado_id = pr2.id " +
                     "LEFT JOIN persona pr_persona2 ON pr2.persona_id = pr_persona2.id " +
                     "LEFT JOIN persona p1 ON pr1.persona_id = p1.id " +   // compatibilidad nombres
                     "LEFT JOIN persona p2 ON pr2.persona_id = p2.id " +
                     "ORDER BY a.id DESC";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Apoderado a = new Apoderado();
                a.setId(rs.getInt("id"));
                a.setAlumnoId(rs.getInt("alumno_id"));
                a.setApoderadoId(rs.getInt("apoderado_id"));
                a.setParentescoId(rs.getInt("parentesco_id"));
                // nombres (pueden ser null si faltan joins)
                String nombreAlumno = null;
                String nombreApoderado = null;
                try { nombreAlumno = rs.getString("nombre_alumno"); } catch (Exception ex) {}
                try { nombreApoderado = rs.getString("nombre_apoderado"); } catch (Exception ex) {}
                a.setNombreAlumno(nombreAlumno != null ? nombreAlumno : "");
                a.setNombreApoderado(nombreApoderado != null ? nombreApoderado : "");
                try { a.setNombreParentesco(rs.getString("parentesco_nombre")); } catch (Exception ex) { a.setNombreParentesco(""); }
                lista.add(a);
            }
        } catch (Exception e) {
            System.out.println("Error listar Apoderado: " + e.getMessage());
        }
        return lista;
    }

    // Registrar nueva asociación (apoderado - alumno)
    public boolean registrar(Apoderado a) {
        String sql = "INSERT INTO apoderado (alumno_id, apoderado_id, parentesco_id) VALUES (?,?,?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, a.getAlumnoId());
            ps.setInt(2, a.getApoderadoId());
            ps.setInt(3, a.getParentescoId());
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("Error registrar Apoderado: " + e.getMessage());
            return false;
        }
    }

    // Obtener hijos (alumnos) de un apoderado (por persona_rol apoderado_id)
    public List<Apoderado> listarPorApoderadoPersonaRolId(int personaRolApoderadoId) {
        List<Apoderado> lista = new ArrayList<>();
        String sql = "SELECT a.id, a.alumno_id, a.apoderado_id, a.parentesco_id, " +
                     "CONCAT(p.nombres,' ',p.apellido_paterno,' ',p.apellido_materno) AS nombre_alumno, " +
                     "pr_alumno.persona_id AS persona_id_alumno, pr_alumno.id AS persona_rol_alumno, p.dni AS dni_alumno " +
                     "FROM apoderado a " +
                     "LEFT JOIN persona_rol pr_alumno ON a.alumno_id = pr_alumno.id " +
                     "LEFT JOIN persona p ON pr_alumno.persona_id = p.id " +
                     "WHERE a.apoderado_id = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, personaRolApoderadoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Apoderado a = new Apoderado();
                    a.setId(rs.getInt("id"));
                    a.setAlumnoId(rs.getInt("alumno_id"));
                    a.setApoderadoId(rs.getInt("apoderado_id"));
                    a.setParentescoId(rs.getInt("parentesco_id"));
                    a.setNombreAlumno(rs.getString("nombre_alumno"));
                    lista.add(a);
                }
            }
        } catch (Exception e) {
            System.out.println("Error listarPorApoderadoPersonaRolId: " + e.getMessage());
        }
        return lista;
    }

    // Inhabilitar asociación (soft delete)
    public boolean inhabilitar(int id) {
        String sql = "UPDATE apoderado SET activo = 0 WHERE id = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("Error inhabilitar Apoderado: " + e.getMessage());
            return false;
        }
    }

    // Eliminar asociación
    public boolean eliminar(int id) {
        String sql = "DELETE FROM apoderado WHERE id = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("Error eliminar Apoderado: " + e.getMessage());
            return false;
        }
    }
}
