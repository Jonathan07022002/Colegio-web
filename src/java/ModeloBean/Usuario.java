/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;
import java.sql.Timestamp;
/**
 *
 * @author Jonathan
 */
public class Usuario {
    private long idUsuario;
    private String username;
    private String passwordHash;
    private long idPersona;
    private int idEstado;
    private Timestamp createdAt;
    private Timestamp lastLoginAt;

    private String nombreCompleto;
    private String estado;
    
    public Usuario() {}

    public Usuario(long idUsuario, String username, String passwordHash, long idPersona, int idEstado, Timestamp createdAt, Timestamp lastLoginAt) {
        this.idUsuario = idUsuario;
        this.username = username;
        this.passwordHash = passwordHash;
        this.idPersona = idPersona;
        this.idEstado = idEstado;
        this.createdAt = createdAt;
        this.lastLoginAt = lastLoginAt;
    }

    public long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(long idUsuario) { this.idUsuario = idUsuario; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public long getIdPersona() { return idPersona; }
    public void setIdPersona(long idPersona) { this.idPersona = idPersona; }

    public int getIdEstado() { return idEstado; }
    public void setIdEstado(int idEstado) { this.idEstado = idEstado; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(Timestamp lastLoginAt) { this.lastLoginAt = lastLoginAt; }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    
}
