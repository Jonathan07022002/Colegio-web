/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;

/**
 *
 * @author Jonathan
 */
public class Apoderado {
    private int id;
    private int alumnoId;       // persona_rol.id del alumno
    private int apoderadoId;    // persona_rol.id del apoderado
    private int parentescoId;

    // Campos adicionales para mostrar en UI (no persistidos en tabla apoderado)
    private String nombreAlumno;
    private String nombreApoderado;
    private String nombreParentesco;

    public Apoderado() {}

    public Apoderado(int id, int alumnoId, int apoderadoId, int parentescoId) {
        this.id = id;
        this.alumnoId = alumnoId;
        this.apoderadoId = apoderadoId;
        this.parentescoId = parentescoId;
    }

    // Getters / Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAlumnoId() { return alumnoId; }
    public void setAlumnoId(int alumnoId) { this.alumnoId = alumnoId; }

    public int getApoderadoId() { return apoderadoId; }
    public void setApoderadoId(int apoderadoId) { this.apoderadoId = apoderadoId; }

    public int getParentescoId() { return parentescoId; }
    public void setParentescoId(int parentescoId) { this.parentescoId = parentescoId; }

    public String getNombreAlumno() { return nombreAlumno; }
    public void setNombreAlumno(String nombreAlumno) { this.nombreAlumno = nombreAlumno; }

    public String getNombreApoderado() { return nombreApoderado; }
    public void setNombreApoderado(String nombreApoderado) { this.nombreApoderado = nombreApoderado; }

    public String getNombreParentesco() { return nombreParentesco; }
    public void setNombreParentesco(String nombreParentesco) { this.nombreParentesco = nombreParentesco; }
}
