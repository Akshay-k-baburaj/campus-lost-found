package com.campus.lostnfound.utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "noreplycampuslostandfound@gmail.com";
    private static final String EMAIL_PASSWORD = "rfes wuxv tiqg btpt"; // Use App Password, not main password
    private static final String APP_NAME = "Campus Lost & Found";

    /**
     * Helper to create SMTP Session
     */
    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });
    }

    /**
     * Send email notification when someone claims an item (Sent to Owner)
     */
    public static boolean sendClaimNotification(String ownerEmail, String ownerName,
                                                String itemName, String claimerName,
                                                String claimerContact) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(EMAIL_FROM, APP_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(ownerEmail));
            message.setSubject("🎉 Great News! Someone Found Your " + itemName);

            String htmlBody =
                    "<div style='font-family: Segoe UI, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden;'>" +
                            "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center;'>" +
                            "<h1 style='color: white; margin: 0; font-size: 24px;'>Item Found!</h1>" +
                            "</div>" +
                            "<div style='padding: 30px; color: #2d3748;'>" +
                            "<p style='font-size: 16px;'>Hi <strong>" + ownerName + "</strong>,</p>" +
                            "<p>Someone has claimed your item: <strong style='color: #667eea;'>\"" + itemName + "\"</strong></p>" +
                            "<div style='background: #f7fafc; padding: 20px; border-radius: 12px; border: 1px solid #edf2f7; margin: 20px 0;'>" +
                            "<h4 style='margin: 0 0 10px 0; color: #4a5568; text-transform: uppercase; font-size: 12px;'>Claimer Details</h4>" +
                            "<p style='margin: 5px 0;'><strong>Name:</strong> " + claimerName + "</p>" +
                            "<p style='margin: 5px 0;'><strong>Contact:</strong> " + claimerContact + "</p>" +
                            "</div>" +
                            "<p>Please coordinate with the claimer to arrange a meeting. Once you have your item, remember to mark it as <b>Returned</b> on the portal.</p>" +
                            "<div style='text-align: center; margin-top: 30px;'>" +
                            "<a href='#' style='background: #667eea; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: bold; display: inline-block;'>View My Postings</a>" +
                            "</div>" +
                            "</div>" +
                            "<div style='background: #f1f5f9; padding: 15px; text-align: center; font-size: 12px; color: #94a3b8;'>" +
                            "Sent by " + APP_NAME + " Team" +
                            "</div>" +
                            "</div>";

            message.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Send confirmation email to claimer
     */
    public static boolean sendClaimConfirmation(String claimerEmail, String claimerName,
                                                String itemName, String ownerContact) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(EMAIL_FROM, APP_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(claimerEmail));
            message.setSubject("✅ Claim Confirmed: " + itemName);

            String htmlBody =
                    "<div style='font-family: Segoe UI, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 16px; overflow: hidden;'>" +
                            "<div style='background: #2ed573; padding: 30px; text-align: center;'>" +
                            "<h1 style='color: white; margin: 0; font-size: 24px;'>Successfully Claimed</h1>" +
                            "</div>" +
                            "<div style='padding: 30px; color: #2d3748;'>" +
                            "<p style='font-size: 16px;'>Hi <strong>" + claimerName + "</strong>,</p>" +
                            "<p>You have successfully submitted a claim for: <strong>\"" + itemName + "\"</strong></p>" +
                            "<div style='border-left: 4px solid #2ed573; padding-left: 15px; margin: 20px 0;'>" +
                            "<p style='margin: 0; font-size: 14px; color: #718096;'>The owner has been notified. You can contact them at:</p>" +
                            "<p style='font-size: 18px; font-weight: bold; color: #2d3748;'>" + ownerContact + "</p>" +
                            "</div>" +
                            "<p>Thank you for being a helpful member of our campus community!</p>" +
                            "</div>" +
                            "<div style='background: #f1f5f9; padding: 15px; text-align: center; font-size: 12px; color: #94a3b8;'>" +
                            "Sent by " + APP_NAME + " Team" +
                            "</div>" +
                            "</div>";

            message.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}