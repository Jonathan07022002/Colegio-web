package ModeloDAO;

import ModeloBean.Persona;
import ModeloBean.Rol;
import conexion.conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PersonaDAO {

    /* -------------------- LISTAR -------------------- */
    public List<Persona> listarPersonas() {
        List<Persona> lista = new ArrayList<>();
        String sql = """
            SELECT 
                p.id_persona,
                p.dni,
                CONCAT(p.nombres,' ',p.apellido_paterno,' ',p.apellido_materno) AS nombre_completo,
                p.correo,
                p.telefono,
                GROUP_CONCAT(r.nombre_rol SEPARATOR ', ') AS roles,
                p.activo
            FROM persona p
            LEFT JOIN persona_rol pr ON p.id_persona = pr.id_persona
            LEFT JOIN rol r ON pr.id_rol = r.id_rol
            GROUP BY p.id_persona, p.dni, nombre_completo, p.correo, p.telefono
            ORDER BY p.id_persona DESC
        """;
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Persona per = new Persona();
                per.setId(rs.getInt("id_persona"));              // usa setId (consistente)
                per.setDni(rs.getString("dni"));
                per.setNombresCompletos(rs.getString("nombre_completo"));
                per.setCorreo(rs.getString("correo"));
                per.setTelefono(rs.getString("telefono"));
                per.setRol(rs.getString("roles"));
                per.setActivo(rs.getInt("activo"));
                lista.add(per);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /* -------------------- INSERTAR + ROLES -------------------- */
    public boolean agregar(Persona persona, List<Integer> rolesIds) {
        String sqlPersona = """
            INSERT INTO persona
            (dni, nombres, apellido_paterno, apellido_materno,
             fecha_nacimiento, direccion, telefono, correo, activo)
            VALUES (?,?,?,?,?,?,?,?, 1)
        """;
        String sqlIntermedia = "INSERT INTO persona_rol(id_persona, id_rol) VALUES(?,?)";

        Connection con = null;
        PreparedStatement psPersona = null;
        PreparedStatement psRol = null;
        ResultSet rsKeys = null;

        try {
            con = conexion.getConexion();
            con.setAutoCommit(false);

            psPersona = con.prepareStatement(sqlPersona, Statement.RETURN_GENERATED_KEYS);
            psPersona.setString(1, persona.getDni());
            psPersona.setString(2, persona.getNombres());
            psPersona.setString(3, persona.getApellidoPaterno());
            psPersona.setString(4, persona.getApellidoMaterno());
            psPersona.setDate(5, persona.getFechaNacimiento()); // java.sql.Date en tu bean
            psPersona.setString(6, persona.getDireccion());
            psPersona.setString(7, persona.getTelefono());
            psPersona.setString(8, persona.getCorreo());
            psPersona.executeUpdate();

            rsKeys = psPersona.getGeneratedKeys();
            int idPersona = 0;
            if (rsKeys.next()) idPersona = rsKeys.getInt(1);

            if (rolesIds != null && !rolesIds.isEmpty()) {
                psRol = con.prepareStatement(sqlIntermedia);
                for (Integer idRol : rolesIds) {
                    psRol.setInt(1, idPersona);
                    psRol.setInt(2, idRol);
                    psRol.addBatch();
                }
                psRol.executeBatch();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (rsKeys != null) rsKeys.close(); } catch (SQLException ignored) {}
            try { if (psRol != null) psRol.close(); } catch (SQLException ignored) {}
            try { if (psPersona != null) psPersona.close(); } catch (SQLException ignored) {}
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (SQLException ignored) {}
        }
    }

    /* -------------------- QUERIES BÁSICAS -------------------- */

    /** Buscar persona por DNI (usa TRIM para evitar padding en CHAR) */
    public Persona buscarPorDni(String dni) {
        String sql = "SELECT * FROM persona WHERE TRIM(dni)=? LIMIT 1";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Persona p = new Persona();
                    p.setId(rs.getInt("id_persona"));                 // usa setId (consistente)
                    p.setDni(rs.getString("dni"));
                    p.setNombres(rs.getString("nombres"));
                    p.setApellidoPaterno(rs.getString("apellido_paterno"));
                    p.setApellidoMaterno(rs.getString("apellido_materno"));
                    p.setCorreo(rs.getString("correo"));
                    return p;
                }
            }
        } catch (Exception e) {
            System.out.println("Error buscarPorDni: " + e.getMessage());
        }
        return null;
    }

    
    /** Alias conveniente si en otros lados llaman obtenerPorDni */
    public Persona obtenerPorDni(String dni) { return buscarPorDni(dni); }

    public Persona obtenerPorId(int idPersona) {
        String sql = "SELECT * FROM persona WHERE id_persona=? LIMIT 1";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPersona);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Persona p = new Persona();
                    p.setId(rs.getInt("id_persona"));
                    p.setDni(rs.getString("dni"));
                    p.setNombres(rs.getString("nombres"));
                    p.setApellidoPaterno(rs.getString("apellido_paterno"));
                    p.setApellidoMaterno(rs.getString("apellido_materno"));
                    p.setCorreo(rs.getString("correo"));
                    return p;
                }
            }
        } catch (Exception e) {
            System.out.println("Error obtenerPorId: " + e.getMessage());
        }
        return null;
    }
public long obtenerIdPersonaPorDniCorreo(String dni, String correo) {
        String sql = "SELECT id_persona FROM persona WHERE dni = ? AND correo = ?";
        try (Connection c = conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, dni);
            ps.setString(2, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("id_persona");
            }
        } catch (Exception e) {
            System.out.println("Error obtenerIdPersonaPorDniCorreo: " + e.getMessage());
        }
        return 0L;
    }

public boolean cambiarEstado(int id, int nuevoEstado) {
    String sql = "UPDATE persona SET activo=? WHERE id_persona=?";
    try (Connection c = conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, nuevoEstado);
                ps.setInt(2, id);
                if (ps.executeUpdate() > 0) {
            // También actualizar estado en usuario
                String sqlUsuario = "UPDATE usuario SET id_estado = ? WHERE id_persona = ?";
                try (PreparedStatement ps2 = c.prepareStatement(sqlUsuario)) {
                if(nuevoEstado == 0){
                    ps2.setInt(1,2);
                }else{
                    ps2.setInt(1, 1);
                }
                ps2.setInt(2, id);
                ps2.executeUpdate();
            }
        }
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

public void actualizarDatosBasicos(Persona p) throws SQLException {
    String sql = "UPDATE persona SET correo=?, telefono=?, direccion=? WHERE id=?";
    try(Connection c = conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
        
        ps.setString(1, p.getCorreo());
        ps.setString(2, p.getTelefono());
        ps.setString(3, p.getDireccion());
        ps.setInt(4, p.getId());
        ps.executeUpdate();
    }
}

    // 🔁 Mantén la firma que ya invoca tu servlet AJAX:
    public boolean existeDniCorreo(String dni, String correo) {
        return obtenerIdPersonaPorDniCorreo(dni, correo) > 0;
    }
    /* -------------------- ROLES DE UNA PERSONA -------------------- */
    public List<Rol> obtenerRolesPorPersona(int idPersona) {
        List<Rol> roles = new ArrayList<>();
        String sql = """
            SELECT r.id_rol, r.nombre_rol, r.descripcion
            FROM rol r
            INNER JOIN persona_rol pr ON r.id_rol = pr.id_rol
            WHERE pr.id_persona = ?
        """;
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPersona);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roles.add(new Rol(
                            rs.getInt("id_rol"),
                            rs.getString("nombre_rol"),
                            rs.getString("descripcion")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }
}