/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import ModeloBean.Usuario;
import ModeloBean.Persona;
import conexion.conexion;

import java.sql.*;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {

    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    String sql = "";

    // ====== LISTAR (como ya usabas) ======
    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        sql = "SELECT u.id_usuario, CONCAT(p.nombres,' ',p.apellido_paterno,' ',p.apellido_materno) AS nombre_completo, " +
              "u.username, u.created_at, e.nombre_estado AS estado " +
              "FROM usuario u " +
              "JOIN persona p ON u.id_persona = p.id_persona " +
              "JOIN estado_usuario e ON u.id_estado = e.id_estado " +
              "ORDER BY u.id_usuario";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getLong("id_usuario"));
                u.setNombreCompleto(rs.getString("nombre_completo"));
                u.setUsername(rs.getString("username"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setEstado(rs.getString("estado"));
                lista.add(u);
            }
        } catch (Exception e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
        } finally {
            cerrarSilencioso();
        }
        return lista;
    }

    public Usuario obtenerPorId(long id) {
        Usuario u = null;
        sql = "SELECT u.*, e.nombre_estado AS estado " +
              "FROM usuario u JOIN estado_usuario e ON u.id_estado=e.id_estado WHERE id_usuario=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setLong(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                u = new Usuario();
                u.setIdUsuario(rs.getLong("id_usuario"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setIdPersona(rs.getLong("id_persona"));
                u.setIdEstado(rs.getInt("id_estado"));
                u.setEstado(rs.getString("estado"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setLastLoginAt(rs.getTimestamp("last_login_at"));
            }
        } catch (Exception e) {
            System.out.println("Error obtenerPorId: " + e.getMessage());
        } finally {
            cerrarSilencioso();
        }
        return u;
    }

    public boolean cambiarEstado(long idUsuario, int nuevoEstadoId) {
        sql = "UPDATE usuario SET id_estado=? WHERE id_usuario=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, nuevoEstadoId);
            ps.setLong(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error cambiarEstado: " + e.getMessage());
            return false;
        } finally {
            cerrarSilencioso();
        }
    }

    // ====== LOGIN con bcrypt + migración si encuentra texto plano ======
    public Usuario validarLogin(String username, String passwordIngresada) {
        String q = "SELECT u.id_usuario, u.username, u.password_hash, u.id_persona, u.id_estado " +
                   "FROM usuario u WHERE u.username = ?";
        try (Connection c = conexion.getConexion();
             PreparedStatement p = c.prepareStatement(q)) {
            p.setString(1, username);
            try (ResultSet r = p.executeQuery()) {
                if (!r.next()) return null;

                long idUsuario = r.getLong("id_usuario");
                long idPersona = r.getLong("id_persona");
                int idEstado  = r.getInt("id_estado");
                String hashDB = r.getString("password_hash");

                if (hashDB == null) return null;

                boolean ok = false;

                // Caso normal: bcrypt válido
                if (hashDB.startsWith("$2a$") || hashDB.startsWith("$2b$") || hashDB.startsWith("$2y$")) {
                    ok = BCrypt.checkpw(passwordIngresada, hashDB);
                } else {
                    // Posible residuo de formatos antiguos ($12$...) o texto plano.
                    // Migración: si coincide en texto, re-hashear.
                    if (hashDB.equals(passwordIngresada) || hashDB.startsWith("$12$")) {
                        ok = true; // acepta por única vez y migra
                        String nuevoHash = BCrypt.hashpw(passwordIngresada, BCrypt.gensalt(12));
                        actualizarPasswordPorUsuarioConHash(idUsuario, nuevoHash);
                    }
                }

                if (!ok) return null;

                Usuario u = new Usuario();
                u.setIdUsuario(idUsuario);
                u.setIdPersona(idPersona);
                u.setUsername(username);
                u.setIdEstado(idEstado);
                return u;
            }
        } catch (Exception e) {
            System.out.println("Error validarLogin: " + e.getMessage());
            return null;
        }
    }

    // ====== Existe usuario por persona ======
    public boolean existeUsuarioPorPersona(long idPersona) {
        String q = "SELECT 1 FROM usuario WHERE id_persona=? LIMIT 1";
        try (Connection c = conexion.getConexion();
             PreparedStatement p = c.prepareStatement(q)) {
            p.setLong(1, idPersona);
            try (ResultSet r = p.executeQuery()) {
                return r.next();
            }
        } catch (Exception e) {
            System.out.println("Error existeUsuarioPorPersona: " + e.getMessage());
            return false;
        }
    }

    // ====== Actualizar password (hasheando dentro) por persona con texto (por ejemplo DNI) ======
    public boolean actualizarPasswordPorPersona(long idPersona, String textoPlano) {
        
        String q = "UPDATE usuario SET password_hash=? WHERE id_persona=?";
        try (Connection c = conexion.getConexion();
             PreparedStatement p = c.prepareStatement(q)) {
            p.setString(1, textoPlano);
            p.setLong(2, idPersona);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error actualizarPasswordPorPersona: " + e.getMessage());
            return false;
        }
    }

    // ====== ✅ NUEVO: Actualizar password con HASH ya generado (para ResetPasswordSVL) ======
    public boolean actualizarPasswordPorPersonaConHash(long idPersona, String hashBcrypt) {
        String q = "UPDATE usuario SET password_hash=? WHERE id_persona=?";
        try (Connection c = conexion.getConexion();
             PreparedStatement p = c.prepareStatement(q)) {
            p.setString(1, hashBcrypt);
            p.setLong(2, idPersona);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error actualizarPasswordPorPersonaConHash: " + e.getMessage());
            return false;
        }
    }

    // (útil para migración por id_usuario si lo necesitas)
    private boolean actualizarPasswordPorUsuarioConHash(long idUsuario, String hashBcrypt) {
        String q = "UPDATE usuario SET password_hash=? WHERE id_usuario=?";
        try (Connection c = conexion.getConexion();
             PreparedStatement p = c.prepareStatement(q)) {
            p.setString(1, hashBcrypt);
            p.setLong(2, idUsuario);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error actualizarPasswordPorUsuarioConHash: " + e.getMessage());
            return false;
        }
    }

    // ====== Crear usuario individual para Persona ======
    public boolean crearUsuarioParaPersona(Persona p, String dniPassword) {
        String username = (p.getCorreo() != null && !p.getCorreo().trim().isEmpty())
                ? generarCorreoInstitucional(p)
                : p.getCorreo().trim().toLowerCase();

        String q = "INSERT INTO usuario (username, password_hash, id_persona, id_estado, created_at) " +
                   "VALUES (?, ?, ?, 1, NOW())";
        try (Connection c = conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(q)) {
            ps.setString(1, username);
            ps.setString(2, dniPassword);
            ps.setInt(3, p.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error crearUsuarioParaPersona: " + e.getMessage());
            return false;
        }
    }

    // ====== Generación MASIVA por Rol (crea o actualiza pass= DNI) ======
    public int crearMasivoPorRol(String nombreRol) {
        int afectados = 0;
        String q = "SELECT p.* " +
                   "FROM persona p " +
                   "JOIN persona_rol pr ON pr.id_persona = p.id_persona " +
                   "JOIN rol r ON r.id_rol = pr.id_rol " +
                   "WHERE r.nombre_rol = ?";

        try (Connection c = conexion.getConexion();
             PreparedStatement psL = c.prepareStatement(q)) {

            psL.setString(1, nombreRol);
            try (ResultSet rs = psL.executeQuery()) {
                while (rs.next()) {
                    Persona p = mapPersona(rs);

                    if (existeUsuarioPorPersona(p.getId())) {
                        if (p.getDni() != null && p.getDni().matches("\\d{8}")) {
                            if (actualizarPasswordPorPersona(p.getId(), p.getDni())) {
                                afectados++;
                            }
                        }
                    } else {
                        String dni = p.getDni();
                        if (dni == null || !dni.matches("\\d{8}")) {
                            continue;
                        }
                        if (crearUsuarioParaPersona(p, dni)) {
                            afectados++;
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error crearMasivoPorRol: " + e.getMessage());
        }
        return afectados;
    }

    // ===== Helpers =====
    private Persona mapPersona(ResultSet rs) throws SQLException {
        Persona p = new Persona();
        p.setId(rs.getInt("id_persona"));
        p.setNombres(rs.getString("nombres"));
        p.setApellidoPaterno(rs.getString("apellido_paterno"));
        p.setApellidoMaterno(rs.getString("apellido_materno"));
        p.setDni(rs.getString("dni"));
        p.setCorreo(rs.getString("correo"));
        return p;
    }

    private static String normaliza(String s) {
        if (s == null) return "";
        String t = Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
        t = t.toLowerCase().replaceAll("[^a-z]", "");
        return t;
    }

    // 3 primeras de nombres + apellido_paterno + 2 primeras de apellido_materno + @mrn.edu.pe
    private String generarCorreoInstitucional(Persona p) {
        String nom = normaliza(p.getNombres());
        String ap1 = normaliza(p.getApellidoPaterno());
        String ap2 = normaliza(p.getApellidoMaterno());

        String a = nom.length() >= 3 ? nom.substring(0, 3) : nom;
        String b = ap1;
        String c = ap2.length() >= 2 ? ap2.substring(0, 2) : ap2;

        return (a + b + c) + "@mrn.edu.pe";
    }

    private void cerrarSilencioso() {
        try { if (rs != null) rs.close(); } catch (Exception ignore) {}
        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
        try { if (con != null) con.close(); } catch (Exception ignore) {}
    }

    public boolean actualizarPasswordPorToken(String token, String hash) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public String generarYGuardarTokenParaPersona(long idPersona, int i) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public long obtenerIdPersonaPorTokenVigente(String token) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}