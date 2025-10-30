/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public final class EmailUtil {

    private EmailUtil() {}

    // === Config SMTP (Gmail) ===
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int    SMTP_PORT = 587; // TLS
    private static final String SMTP_USER = "mrncolegiojlo@gmail.com";
    private static final String SMTP_PASS = "yhfopqvepbxilsgf"; // contraseña de app
    private static final String FROM_NAME = "Intranet MRN";

    // Cache de sesión (lazy, thread-safe)
    private static volatile Session CACHED_SESSION;

    private static Session session() {
        if (CACHED_SESSION == null) {
            synchronized (EmailUtil.class) {
                if (CACHED_SESSION == null) {
                    Properties props = new Properties();
                    props.put("mail.smtp.auth", "true");
                    props.put("mail.smtp.starttls.enable", "true");
                    props.put("mail.smtp.starttls.required", "true");
                    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
                    props.put("mail.smtp.host", SMTP_HOST);
                    props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
                    props.put("mail.smtp.ssl.trust", SMTP_HOST);

                    CACHED_SESSION = Session.getInstance(props, new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
                        }
                    });

                    // Activa si necesitas ver el detalle en consola:
                    // CACHED_SESSION.setDebug(true);
                }
            }
        }
        return CACHED_SESSION;
    }

    public static void enviarCodigo(String to, String codigo) throws Exception {
        String asunto = "Código de verificación - Recuperar contraseña";
        String html = "<div style='font-family:Segoe UI,Arial,sans-serif'>"
                + "<h2>Recuperar contraseña</h2>"
                + "<p>Tu código de verificación es:</p>"
                + "<div style='font-size:28px;font-weight:700;letter-spacing:3px;"
                + "background:#111827;color:#fff;display:inline-block;padding:10px 16px;border-radius:8px'>"
                + codigo + "</div>"
                + "<p style='margin-top:18px'>Este código vence en <b>15 minutos</b>.</p>"
                + "</div>";

        enviarHtml(to, asunto, html);
    }

    public static void enviarLink(String to, String link) throws Exception {
        String asunto = "Enlace para restablecer tu contraseña";
        String html = "<div style='font-family:Segoe UI,Arial,sans-serif'>"
                + "<h2>Restablecer contraseña</h2>"
                + "<p>Haz clic en el botón para establecer una nueva contraseña:</p>"
                + "<p><a href='" + link + "' style='background:#2563EB;color:#fff;text-decoration:none;"
                + "padding:10px 16px;border-radius:8px;display:inline-block'>Restablecer contraseña</a></p>"
                + "<p>El enlace vence en <b>15 minutos</b>.</p>"
                + "</div>";

        enviarHtml(to, asunto, html);
    }

private static void enviarHtml(String to, String subject, String html) throws Exception {
    Message msg = new MimeMessage(session());
    msg.setFrom(new InternetAddress(SMTP_USER, FROM_NAME, "UTF-8"));
    msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));

    // Si tu JavaMail no soporta setSubject(String, String):
    String encoded = MimeUtility.encodeText(subject, "UTF-8", "B");
    msg.setSubject(encoded); // ← sin charset aquí

    MimeBodyPart body = new MimeBodyPart();
    body.setContent(html, "text/html; charset=UTF-8");

    Multipart mp = new MimeMultipart();
    mp.addBodyPart(body);
    msg.setContent(mp);

    Transport.send(msg);
}
}
