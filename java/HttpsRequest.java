import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;
import javax.net.ssl.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.*;
import java.security.cert.CertificateException;

import org.apache.http.conn.ssl.SSLConnectionSocketFactory;

/**
 * Created by yangyy on 17-2-14.
 */
public class HttpsRequest {
    public static String get(String url) {
        try {
            ssl();
            URL _url = new URL(url);
            URLConnection conn = _url.openConnection();
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            conn.setConnectTimeout(1000);
            conn.connect();
            Map<String, List<String>> headerFields = conn.getHeaderFields();
            for (String headerField : headerFields.keySet()) {
                System.out.printf("FIELD:%s,VALUES:%s\n", headerField, headerFields.get(headerField));
            }
            int bodyLen = conn.getContentLength();
            System.out.printf("LENS:%d\n", bodyLen);
            char[] buff = new char[bodyLen];
            StringBuffer content = new StringBuffer();
            Reader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            reader.read(buff);
            content.append(buff);
            System.out.printf("BODY:%s\n", content);
            return content.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String post(String url, String data) {
        try {
            ssl();
            System.out.printf("REQ:%s\n", data);
            URL _url = new URL(url);
            URLConnection conn = _url.openConnection();
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
            Map<String, List<String>> headerFields = conn.getHeaderFields();
            for (String headerField : headerFields.keySet()) {
                System.out.printf("FIELD:%s,VALUES:%s\n", headerField, headerFields.get(headerField));
            }
            int bodyLen = conn.getContentLength();
            System.out.printf("LENS:%d\n", bodyLen);
            char[] buff = new char[bodyLen];
            StringBuffer content = new StringBuffer();
            Reader reader = new InputStreamReader(conn.getInputStream());
            reader.read(buff);
            content.append(buff);
            System.out.printf("BODY:\n%s\n", content);
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
