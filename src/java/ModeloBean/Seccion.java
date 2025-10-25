/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;

/**
 *
 * @author Jonathan
 */
public class Seccion {
        private int id_seccion;
    private String nombre;
    private int aforo_max;
    private int activo; // nuevo campo

    public Seccion() {}

    public Seccion(int id_seccion, String nombre, int aforo_max, int activo) {
        this.id_seccion = id_seccion;
        this.nombre = nombre;
        this.aforo_max = aforo_max;
        this.activo = activo;
    }

    public int getId_seccion() {
        return id_seccion;
    }

    public void setId_seccion(int id_seccion) {
        this.id_seccion = id_seccion;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getAforo_max() {
        return aforo_max;
    }

    public void setAforo_max(int aforo_max) {
        this.aforo_max = aforo_max;
    }

    public int getActivo() {
        return activo;
    }

    public void setActivo(int activo) {
        this.activo = activo;
    }

}
