/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloBean;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
/**
 *
 * @author Jonathan
 */
public class ApiPeruService {
    private static final String TOKEN = "20b0f85cab7fd4f9d98a7278ab3ca9ad419436448cc6d0e53e66a1f54b086313";

    public static String consultarDni(String dni) {
        String respuesta = "";
        try {
            String urlApi = "https://apiperu.dev/api/dni/" + dni;
            URL url = new URL(urlApi);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + TOKEN);
            conn.setRequestProperty("Content-Type", "application/json");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();
            respuesta = sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respuesta;
    }
}
