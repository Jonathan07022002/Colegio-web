/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;

/**
 *
 * @author Jonathan
 */
public class Curso {
        private int id_curso;
    private String nombre;
    private String descripcion;
    private int id_area;
    private boolean activo;

    public Curso() {}

    public Curso(int id_curso, String nombre, String descripcion, int id_area, boolean activo) {
        this.id_curso = id_curso;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.id_area = id_area;
        this.activo = activo;
    }

    public int getId_curso() { return id_curso; }
    public void setId_curso(int id_curso) { this.id_curso = id_curso; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public int getId_area() { return id_area; }
    public void setId_area(int id_area) { this.id_area = id_area; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

}
