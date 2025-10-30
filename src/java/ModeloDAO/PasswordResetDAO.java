/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import conexion.conexion;
import java.sql.*;
import java.time.LocalDateTime;

public class PasswordResetDAO {

    public Long crear(long idUsuario, String token, LocalDateTime expiresAt) {
        String sql = "INSERT INTO password_reset (id_usuario, token, expires_at) VALUES (?, ?, ?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, idUsuario);
            ps.setString(2, token);
            ps.setTimestamp(3, Timestamp.valueOf(expiresAt));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (Exception e) {
            System.out.println("PasswordResetDAO.crear: " + e.getMessage());
        }
        return null;
    }

    public boolean tokenValido(String token) {
        String sql = "SELECT 1 FROM password_reset WHERE token=? AND used=0 AND expires_at > NOW()";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) {
            System.out.println("PasswordResetDAO.tokenValido: " + e.getMessage());
        }
        return false;
    }

    public Long userIdPorToken(String token) {
        String sql = "SELECT id_usuario FROM password_reset WHERE token=? AND used=0 AND expires_at > NOW()";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (Exception e) {
            System.out.println("PasswordResetDAO.userIdPorToken: " + e.getMessage());
        }
        return null;
    }

    public void marcarUsado(String token) {
        String sql = "UPDATE password_reset SET used=1 WHERE token=?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("PasswordResetDAO.marcarUsado: " + e.getMessage());
        }
    }
    // Buscar ID de usuario por DNI + correo (persona)
public Long findUserIdByDniAndCorreo(String dni, String correo) {
    String sql = "SELECT u.id_usuario " +
                 "FROM usuario u INNER JOIN persona p ON u.id_persona = p.id_persona " +
                 "WHERE p.dni = ? AND p.correo = ?";
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, dni);
        ps.setString(2, correo);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        }
    } catch (Exception e) {
        System.out.println("UsuarioDAO.findUserIdByDniAndCorreo: " + e.getMessage());
    }
    return null;
}

// Actualiza el hash de contraseña en 'usuario.password_hash'
public boolean updatePassword(long idUsuario, String newHash) {
    String sql = "UPDATE usuario SET password_hash=? WHERE id_usuario=?";
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, newHash);
        ps.setLong(2, idUsuario);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        System.out.println("UsuarioDAO.updatePassword: " + e.getMessage());
        return false;
    }
}
public boolean existeDniCorreo(String dni, String correo) {
    String sql = "SELECT 1 FROM persona p "
               + "JOIN usuario u ON u.id_persona = p.id_persona "
               + "WHERE p.dni = ? AND (p.correo = ? OR u.username = ?) LIMIT 1";
    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, dni);
        ps.setString(2, correo);
        ps.setString(3, correo);
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    } catch (Exception e) {
        System.out.println("Error existeDniCorreo: " + e.getMessage());
        return false;
    }
}

}