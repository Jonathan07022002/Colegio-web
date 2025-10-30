/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;

/**
 *
 * @author Jonathan
 */
public class Nivel {
    
    private int id_nivel;
    private String nombre;
    private int activo;

    public Nivel() {}

    public Nivel(int id_nivel, String nombre, int activo) {
        this.id_nivel = id_nivel;
        this.nombre = nombre;
        this.activo = activo;
    }

    public int getId_nivel() {
        return id_nivel;
    }

    public void setId_nivel(int id_nivel) {
        this.id_nivel = id_nivel;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getActivo() {
        return activo;
    }

    public void setActivo(int activo) {
        this.activo = activo;
    }
 

}
