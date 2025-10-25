/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import ModeloBean.Persona;
import ModeloBean.Rol;
import conexion.conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Jonathan
 */
public class PersonaDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    conexion cn = new conexion();
    
     public List<Persona> listarPersonas() {
        List<Persona> lista = new ArrayList<>();
        String sql = """
            SELECT 
                p.id_persona, 
                p.dni, 
                CONCAT(p.nombres, ' ', p.apellido_paterno, ' ', p.apellido_materno) AS nombre_completo,
                p.correo,
                p.telefono,
                GROUP_CONCAT(r.nombre_rol SEPARATOR ', ') AS roles
            FROM persona p
            LEFT JOIN persona_rol pr ON p.id_persona = pr.id_persona
            LEFT JOIN rol r ON pr.id_rol = r.id_rol
            GROUP BY p.id_persona, p.dni, nombre_completo, p.correo, p.telefono
            ORDER BY p.id_persona DESC;
        """;

        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Persona per = new Persona();
                per.setId(rs.getInt("id_persona"));
                per.setDni(rs.getString("dni"));
                per.setNombresCompletos(rs.getString("nombre_completo"));
                per.setCorreo(rs.getString("correo"));
                per.setTelefono(rs.getString("telefono"));
                per.setRol(rs.getString("roles"));
                lista.add(per);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }

        return lista;
    }

    // ✅ Listar personas con sus roles
    

    // ✅ Registrar persona + múltiples roles
    public boolean agregar(Persona persona, List<Integer> rolesIds) {
        String sqlPersona = """
            INSERT INTO persona(dni, nombres, apellido_paterno, apellido_materno, 
                                fecha_nacimiento, direccion, telefono, correo) 
            VALUES(?,?,?,?,?,?,?,?)
        """;
        String sqlIntermedia = "INSERT INTO persona_rol(id_persona, id_rol) VALUES(?,?)";

        try {
            con = conexion.getConexion();
            con.setAutoCommit(false);

            // Guardar persona
            ps = con.prepareStatement(sqlPersona, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, persona.getDni());
            ps.setString(2, persona.getNombres());
            ps.setString(3, persona.getApellidoPaterno());
            ps.setString(4, persona.getApellidoMaterno());
            ps.setDate(5, persona.getFechaNacimiento());
            ps.setString(6, persona.getDireccion());
            ps.setString(7, persona.getTelefono());
            ps.setString(8, persona.getCorreo());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int idPersona = 0;
            if (rs.next()) idPersona = rs.getInt(1);

            // Insertar roles asociados
            if (rolesIds != null && !rolesIds.isEmpty()) {
                ps = con.prepareStatement(sqlIntermedia);
                for (int idRol : rolesIds) {
                    ps.setInt(1, idPersona);
                    ps.setInt(2, idRol);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { if (con != null) con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
            cerrarRecursos();
        }
    }

    // ✅ Obtener los roles de una persona
    public List<Rol> obtenerRolesPorPersona(int idPersona) {
        List<Rol> roles = new ArrayList<>();
        String sql = "SELECT r.id_rol, r.nombre_rol FROM rol r INNER JOIN persona_rol pr ON r.id_rol = pr.id_rol WHERE pr.id_persona = ?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPersona);
            rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(new Rol(rs.getInt("id_rol"), rs.getString("nombre_rol"), rs.getString("descripcion")));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }
    
     private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
     
     public Persona buscarPorDni(String dni) {
        Persona p = null;
        String sql = "SELECT * FROM persona WHERE dni = ?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            rs = ps.executeQuery();
            if (rs.next()) {
                p = new Persona();
                p.setId(rs.getInt("id_persona"));
                p.setNombres(rs.getString("nombres"));
                p.setApellidoPaterno(rs.getString("apellido_paterno"));
                p.setApellidoMaterno(rs.getString("apellido_materno"));
            }
        } catch (Exception e) {
            System.out.println("Error al buscar persona: " + e.getMessage());
        }
        return p;
    }
}
