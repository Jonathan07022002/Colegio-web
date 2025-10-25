/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;
import conexion.conexion;
import ModeloBean.Usuario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Jonathan
 */
public class UsuarioDAO {
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    String sql = "";

    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        sql = "SELECT u.id_usuario, CONCAT(p.nombres, ' ', p.apellido_paterno, ' ', p.apellido_materno) AS nombre_completo," +
                "u.username, " +
                "u.created_at, \n" +
                "e.nombre_estado AS estado \n" +
                "FROM usuario u\n" +
                "INNER JOIN persona p ON u.id_persona = p.id_persona \n" +
                "INNER JOIN estado_usuario e ON u.id_estado = e.id_estado;";
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
        }
        return lista;
    }

    public Usuario obtenerPorId(long id) {
        Usuario u = null;
        sql = "SELECT * FROM usuario WHERE id_usuario = ?";
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
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setLastLoginAt(rs.getTimestamp("last_login_at"));
            }
        } catch (Exception e) {
            System.out.println("Error al obtener usuario: " + e.getMessage());
        }
        return u;
    }

    public boolean insertar(Usuario u) {
        sql = "INSERT INTO usuario (username, password_hash, id_persona, id_estado, created_at) VALUES (?, ?, ?, ?, NOW())";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPasswordHash());
            ps.setLong(3, u.getIdPersona());
            ps.setInt(4, u.getIdEstado());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al insertar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Usuario u) {
        sql = "UPDATE usuario SET username=?, password_hash=?, id_persona=?, id_estado=?, last_login_at=? WHERE id_usuario=?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPasswordHash());
            ps.setLong(3, u.getIdPersona());
            ps.setInt(4, u.getIdEstado());
            ps.setTimestamp(5, u.getLastLoginAt());
            ps.setLong(6, u.getIdUsuario());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(long id) {
        sql = "DELETE FROM usuario WHERE id_usuario = ?";
        try {
            con = conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setLong(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }
}
