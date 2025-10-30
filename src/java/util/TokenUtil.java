/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;
import com.google.common.hash.Hashing;
import java.nio.charset.StandardCharsets;
import org.apache.commons.lang3.RandomStringUtils;

public class TokenUtil {
    public static String generarToken(String dni, String correo) {
        String base = dni + "|" + correo + "|" + System.nanoTime();
        String sha = Hashing.sha256().hashString(base, StandardCharsets.UTF_8).toString();
        return sha + RandomStringUtils.randomAlphanumeric(8);
    }
}