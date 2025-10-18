/*package Module5;



import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.FileOutputStream;
import java.util.*;
import java.io.*;

public class CertificateGenerator {
	public static byte[] generateCertificate(String username, String courseName) {
	    ByteArrayOutputStream out = new ByteArrayOutputStream();
	    try {
	        Document document = new Document();
	        PdfWriter.getInstance(document, out);
	        document.open();

	        Font titleFont = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLUE);
	        Font normalFont = new Font(Font.FontFamily.HELVETICA, 14);

	        Paragraph title = new Paragraph("Certificate of Completion", titleFont);
	        title.setAlignment(Element.ALIGN_CENTER);
	        document.add(title);

	        document.add(new Paragraph("\n\nThis is to certify that", normalFont));
	        Paragraph name = new Paragraph(username, new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD));
	        name.setAlignment(Element.ALIGN_CENTER);
	        document.add(name);

	        document.add(new Paragraph("\nHas successfully completed the course:", normalFont));
	        Paragraph course = new Paragraph(courseName, new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD));
	        course.setAlignment(Element.ALIGN_CENTER);
	        document.add(course);

	        document.add(new Paragraph("\n\nDate: " + new java.util.Date(), normalFont));
	        document.add(new Paragraph("Authorized by Learn With Integrity", normalFont));

	        document.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return out.toByteArray();
	}

}*
package Module5;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.ByteArrayOutputStream;

public class CertificateGenerator {
    public static byte[] generateCertificate(String username, String courseName) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        try {
            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLUE);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 14);

            Paragraph title = new Paragraph("Certificate of Completion", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            document.add(new Paragraph("\n\nThis is to certify that", normalFont));
            Paragraph name = new Paragraph(username, new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD));
            name.setAlignment(Element.ALIGN_CENTER);
            document.add(name);

            document.add(new Paragraph("\nHas successfully completed the course:", normalFont));
            Paragraph course = new Paragraph(courseName, new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD));
            course.setAlignment(Element.ALIGN_CENTER);
            document.add(course);

            document.add(new Paragraph("\n\nDate: " + new java.util.Date(), normalFont));
            document.add(new Paragraph("Authorized by Learn With Integrity", normalFont));

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out.toByteArray();
    }
}
*
package Module5;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.ByteArrayOutputStream;

public class CertificateGenerator {

    public static byte[] generateCertificate(String fullName, String courseName, String templateRealPath) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4.rotate(), 0, 0, 0, 0);
        PdfWriter writer = PdfWriter.getInstance(document, baos);
        document.open();

        // Background image
        Image bg = Image.getInstance(templateRealPath);
        bg.setAbsolutePosition(0, 0);
        bg.scaleToFit(PageSize.A4.rotate().getWidth(), PageSize.A4.rotate().getHeight());
        document.add(bg);

        PdfContentByte canvas = writer.getDirectContent();
        BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.EMBEDDED);

        float pageWidth = PageSize.A4.rotate().getWidth();
        float pageHeight = PageSize.A4.rotate().getHeight();

        // --- Placeholders according to template you uploaded ---
        // User name (big, center between top text and line)
        canvas.beginText();
        canvas.setFontAndSize(bf, 32f);
        canvas.showTextAligned(Element.ALIGN_CENTER, fullName, pageWidth / 2f, pageHeight * 0.63f, 0);
        canvas.endText();

        // Course name (below line, bold)
        canvas.beginText();
        canvas.setFontAndSize(bf, 22f);
        canvas.showTextAligned(Element.ALIGN_CENTER, courseName, pageWidth / 2f, pageHeight * 0.48f, 0);
        canvas.endText();

        // Date (below course, small)
        canvas.beginText();
        canvas.setFontAndSize(bf, 14f);
        String dateStr = java.time.LocalDate.now().toString();
        canvas.showTextAligned(Element.ALIGN_CENTER, " " + dateStr, pageWidth / 2f, pageHeight * 0.38f, 0);
        canvas.endText();

        document.close();
        return baos.toByteArray();
    }
}
*
package Module5;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.ByteArrayOutputStream;
import java.time.format.DateTimeFormatter;

public class CertificateGenerator {

    public static byte[] generateCertificate(String fullName, String courseName, String templateRealPath) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4.rotate(), 0, 0, 0, 0);
        PdfWriter writer = PdfWriter.getInstance(document, baos);
        document.open();

        // Background image
        Image bg = Image.getInstance(templateRealPath);
        bg.setAbsolutePosition(0, 0);
        bg.scaleToFit(PageSize.A4.rotate().getWidth(), PageSize.A4.rotate().getHeight());
        document.add(bg);

        PdfContentByte canvas = writer.getDirectContent();

        float pageWidth = PageSize.A4.rotate().getWidth();
        float pageHeight = PageSize.A4.rotate().getHeight();

        // --- Load Stylish Fonts ---
        BaseFont bfName = BaseFont.createFont("fonts/GreatVibes-Regular.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        BaseFont bfCourse = BaseFont.createFont("fonts/PlayfairDisplay-Bold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        BaseFont bfDate = BaseFont.createFont("fonts/Lato-Regular.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

        // --- NAME (Elegant cursive, larger, center) ---
        canvas.beginText();
        canvas.setFontAndSize(bfName, 42f);
        canvas.setColorFill(new BaseColor(44, 62, 80)); // Dark stylish blue
        canvas.showTextAligned(Element.ALIGN_CENTER, fullName, pageWidth / 2f, pageHeight * 0.58f, 0);
        canvas.endText();

        // --- COURSE NAME (Serif bold, classy) ---
        canvas.beginText();
        canvas.setFontAndSize(bfCourse, 26f);
        canvas.setColorFill(new BaseColor(52, 73, 94)); // Slightly different dark tone
        canvas.showTextAligned(Element.ALIGN_CENTER, courseName, pageWidth / 2f, pageHeight * 0.46f, 0);
        canvas.endText();

        // --- DATE (Simple modern font, small) ---
        String dateStr = java.time.LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
        canvas.beginText();
        canvas.setFontAndSize(bfDate, 16f);
        canvas.setColorFill(new BaseColor(0, 0, 0)); // Black
        canvas.showTextAligned(Element.ALIGN_LEFT, dateStr, pageWidth - 160, pageHeight * 0.22f, 0);
        canvas.endText();

        document.close();
        return baos.toByteArray();
    }
}*/
package Module5;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.ByteArrayOutputStream;
import jakarta.servlet.ServletContext;

public class CertificateGenerator {

    public static byte[] generateCertificate(
            String fullName,
            String courseName,
            String templateRealPath,
            ServletContext context   // ✅ Pass context to resolve fonts
    ) throws Exception {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4.rotate(), 0, 0, 0, 0);
        PdfWriter writer = PdfWriter.getInstance(document, baos);
        document.open();

        // ✅ Background image
        Image bg = Image.getInstance(templateRealPath);
        bg.setAbsolutePosition(0, 0);
        bg.scaleToFit(PageSize.A4.rotate().getWidth(), PageSize.A4.rotate().getHeight());
        document.add(bg);

        PdfContentByte canvas = writer.getDirectContent();

        // ✅ Load fonts from WebContent/fonts
        String fontPathName = context.getRealPath("/fonts/GreatVibes-Regular.ttf");
        String fontPathCourse = context.getRealPath("/fonts/PlayfairDisplay-Bold.ttf");
        String fontPathDate = context.getRealPath("/fonts/Roboto-Regular.ttf");

        BaseFont bfName = BaseFont.createFont(fontPathName, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        BaseFont bfCourse = BaseFont.createFont(fontPathCourse, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        BaseFont bfDate = BaseFont.createFont(fontPathDate, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

        float pageWidth = PageSize.A4.rotate().getWidth();
        float pageHeight = PageSize.A4.rotate().getHeight();

        // --- Placeholders with custom fonts ---
        // Name (stylish, centered)
        canvas.beginText();
        canvas.setFontAndSize(bfName, 38f);
        canvas.showTextAligned(Element.ALIGN_CENTER, fullName, pageWidth / 2f, pageHeight * 0.60f, 0);
        canvas.endText();

        // Course (bold, below)
        canvas.beginText();
        canvas.setFontAndSize(bfCourse, 24f);
        canvas.showTextAligned(Element.ALIGN_CENTER, courseName, pageWidth / 2f, pageHeight * 0.48f, 0);
        canvas.endText();

        // Date (small, bottom)
        canvas.beginText();
        canvas.setFontAndSize(bfDate, 14f);
        String dateStr = java.time.LocalDate.now().toString();
        canvas.showTextAligned(Element.ALIGN_CENTER, dateStr, pageWidth / 2f, pageHeight * 0.36f, 0);
        canvas.endText();

        document.close();
        return baos.toByteArray();
    }
}

