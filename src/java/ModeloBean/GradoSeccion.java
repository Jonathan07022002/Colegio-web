/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;

/**
 *
 * @author Jonathan
 */
public class GradoSeccion {
        private int id_grado_seccion;
    private int id_grado;
    private int id_seccion;
    private int id_turno;
    private int vacante;
    private int anio;
    private int activo;

    // Campos relacionados
    private String nombreGrado;
    private String nombreSeccion;
    private String nombreTurno;
    private String nombreNivel;

    // Getters y Setters
    public int getId_grado_seccion() { return id_grado_seccion; }
    public void setId_grado_seccion(int id_grado_seccion) { this.id_grado_seccion = id_grado_seccion; }

    public int getId_grado() { return id_grado; }
    public void setId_grado(int id_grado) { this.id_grado = id_grado; }

    public int getId_seccion() { return id_seccion; }
    public void setId_seccion(int id_seccion) { this.id_seccion = id_seccion; }

    public int getId_turno() { return id_turno; }
    public void setId_turno(int id_turno) { this.id_turno = id_turno; }

    public int getVacante() { return vacante; }
    public void setVacante(int vacante) { this.vacante = vacante; }

    public int getAnio() { return anio; }
    public void setAnio(int anio) { this.anio = anio; }

    public int getActivo() { return activo; }
    public void setActivo(int activo) { this.activo = activo; }

    public String getNombreGrado() { return nombreGrado; }
    public void setNombreGrado(String nombreGrado) { this.nombreGrado = nombreGrado; }

    public String getNombreSeccion() { return nombreSeccion; }
    public void setNombreSeccion(String nombreSeccion) { this.nombreSeccion = nombreSeccion; }

    public String getNombreTurno() { return nombreTurno; }
    public void setNombreTurno(String nombreTurno) { this.nombreTurno = nombreTurno; }

    public String getNombreNivel() { return nombreNivel; }
    public void setNombreNivel(String nombreNivel) { this.nombreNivel = nombreNivel; }

}
