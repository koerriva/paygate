import org.apache.http.conn.ssl.SSLConnectionSocketFactory;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import java.io.*;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;

/**
 * Created by yangyy on 17-2-14.
 */
public class HttpsRequest {

    public static String get(String url) {
        try {
            ssl();
            URL _url = new URL(url);
            HttpsURLConnection conn = (HttpsURLConnection) _url.openConnection();
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            conn.setConnectTimeout(1000);
            conn.connect();
            int bodyLen = conn.getContentLength();
            char[] buff = new char[bodyLen];
            StringBuffer content = new StringBuffer();
            Reader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            reader.read(buff);
            content.append(buff);
            System.err.printf("%s\n", content);
            return content.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String post(String url, String data) {
        try {
            ssl();
            System.err.printf("%s\n", data);
            URL _url = new URL(url);
            HttpsURLConnection conn = (HttpsURLConnection) _url.openConnection();
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("content-type", "text/plain");
            conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            conn.setConnectTimeout(1000);
            conn.setDoInput(true);
            conn.setDoOutput(true);
            Writer writer = new PrintWriter(conn.getOutputStream());
            writer.write(data);
            writer.flush();
            int bodyLen = conn.getContentLength();
            char[] buff = new char[bodyLen];
            StringBuffer content = new StringBuffer();
            Reader reader = new InputStreamReader(conn.getInputStream());
            reader.read(buff);
            content.append(buff);
            System.err.printf("%s\n", content);
            return content.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static void ssl() {
        try {
            KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
            FileInputStream in = new FileInputStream("cert/apiclient_cert.p12");
            ks.load(in, "1262986701".toCharArray());

            TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
            tmf.init(ks);
            SSLContext ctx = SSLContext.getInstance("TLS");
            ctx.init(null, tmf.getTrustManagers(), null);

            SSLConnectionSocketFactory sslSocketFactory = new SSLConnectionSocketFactory(ctx);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (CertificateException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (KeyStoreException e) {
            e.printStackTrace();
        } catch (KeyManagementException e) {
            e.printStackTrace();
        }
    }
}
