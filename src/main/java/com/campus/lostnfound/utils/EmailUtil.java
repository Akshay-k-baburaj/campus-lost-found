package com.campus.lostnfound.utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    // Configure with your email service (Gmail example)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "noreplycampuslostandfound@gmail.com"; // Your email
    private static final String EMAIL_PASSWORD = "rfes wuxv tiqg btpt";

    /**
     * Send email notification when someone claims an item
     */
    public static boolean sendClaimNotification(String ownerEmail, String ownerName,
                                                String itemName, String claimerName,
                                                String claimerContact) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(ownerEmail));
            message.setSubject("🎉 Someone Found Your Lost Item!");

            String emailBody = String.format(
                    "Hi %s,\n\n" +
                            "Great news! Someone has claimed your item: \"%s\"\n\n" +
                            "Claimer Details:\n" +
                            "Name: %s\n" +
                            "Contact: %s\n\n" +
                            "Please contact them to arrange pickup. Once you receive your item, " +
                            "don't forget to mark it as 'Returned' in the system!\n\n" +
                            "Best regards,\n" +
                            "Campus Lost & Found Team",
                    ownerName, itemName, claimerName, claimerContact
            );

            message.setText(emailBody);
            Transport.send(message);

            return true;

        } catch (MessagingException e) {
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
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(claimerEmail));
            message.setSubject("✅ Claim Submitted - Campus Lost & Found");

            String emailBody = String.format(
                    "Hi %s,\n\n" +
                            "You have successfully claimed: \"%s\"\n\n" +
                            "The owner has been notified and their contact info is: %s\n\n" +
                            "Please coordinate with them to return/collect the item.\n\n" +
                            "Thank you for using Campus Lost & Found!\n\n" +
                            "Best regards,\n" +
                            "Campus Lost & Found Team",
                    claimerName, itemName, ownerContact
            );

            message.setText(emailBody);
            Transport.send(message);

            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}
