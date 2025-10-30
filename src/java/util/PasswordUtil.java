/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;


public final class PasswordUtil {

    private PasswordUtil() {}

    /** Devuelve la misma contraseña sin encriptar */
    public static String hash(String plain) {
        // Sin encriptación
        return plain;
    }

    /** Compara directamente texto plano */
    public static boolean matches(String plain, String stored) {
        if (plain == null || stored == null) return false;
        return plain.equals(stored);
    }

    /** No hay hash bcrypt */
    public static boolean isBcrypt(String stored) {
        return false;
    }

    /** Sin normalización */
    public static String normalizeWeirdBcrypt(String stored) {
        return stored;
    }
}
