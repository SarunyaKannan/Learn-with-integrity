/*package Module5;

import Module1.DbConnection;
import jakarta.servlet.ServletContext;

import java.io.File;
import java.nio.file.*;
import java.sql.*;

public class CertificateService {

    public static String issueCertificate(String username, int courseId, String courseTitle, ServletContext ctx) throws Exception {
        int templateId;
        String templatePath;

        // pick first template from certificates table
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT certificate_id, template_path FROM certificates LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                throw new IllegalStateException("No certificate template found!");
            }
            templateId = rs.getInt("certificate_id");
            templatePath = rs.getString("template_path");
        }

        // Resolve PNG real path
        String templateRealPath = ctx.getRealPath("/" + templatePath);

        // Generate PDF bytes
        byte[] pdfBytes = CertificateGenerator.generateCertificate(username, courseTitle, templateRealPath);

        // Ensure output dir
        String outDirRelative = "certs";
        String outDirReal = ctx.getRealPath("/" + outDirRelative);
        Path outDir = Paths.get(outDirReal);
        if (!Files.exists(outDir)) Files.createDirectories(outDir);

        // Write file
        String safeName = username.replaceAll("[^A-Za-z0-9_\\-]", "_");
        String fileName = safeName + "_" + courseId + "_" + System.currentTimeMillis() + ".pdf";
        Path outPath = outDir.resolve(fileName);
        Files.write(outPath, pdfBytes);

        String relativeFilePath = outDirRelative + "/" + fileName;

        // Save DB record
        CertificateDAO.saveUserCertificate(username, courseId, templateId, relativeFilePath);
        
        

        return relativeFilePath;
    }
}*/
package Module5;

import Module1.DbConnection;
import jakarta.servlet.ServletContext;

import java.io.File;
import java.nio.file.*;
import java.sql.*;

public class CertificateService {

    public static String issueCertificate(String username, int courseId, String courseTitle, ServletContext ctx) throws Exception {
        int templateId;
        String templatePath;

        // pick first template from certificates table
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT certificate_id, template_path FROM certificates LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                throw new IllegalStateException("No certificate template found!");
            }
            templateId = rs.getInt("certificate_id");
            templatePath = rs.getString("template_path");
        }

        // Resolve PNG real path
        String templateRealPath = ctx.getRealPath("/" + templatePath);

        // Generate PDF bytes
      

        byte[] pdfBytes =   CertificateGenerator.generateCertificate(username, courseTitle, templateRealPath, ctx);

        // Ensure output dir (WebContent/certs)
        String outDirRelative = "certs";
        String outDirReal = ctx.getRealPath("/" + outDirRelative+"/");
        if (outDirReal == null) {
            throw new IllegalStateException("Cannot resolve real path for /" + outDirRelative);
        }
        Path outDir = Paths.get(outDirReal);
        if (!Files.exists(outDir)) Files.createDirectories(outDir);

        // Write file
        String safeName = username.replaceAll("[^A-Za-z0-9_\\-]", "_");
        String fileName = safeName + "_" + courseId + "_" + System.currentTimeMillis() + ".pdf";
        Path outPath = outDir.resolve(fileName);
        Files.write(outPath, pdfBytes);

        String relativeFilePath = outDirRelative + "/" + fileName;

        // Save DB record
        CertificateDAO.saveUserCertificate(username, courseId, templateId, relativeFilePath);

        return relativeFilePath;
    }
}

