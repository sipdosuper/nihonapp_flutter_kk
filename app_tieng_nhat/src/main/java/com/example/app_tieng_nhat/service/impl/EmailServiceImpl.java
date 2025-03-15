package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.request.SendEmailRequest;
import com.example.app_tieng_nhat.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {
    @Autowired
    private JavaMailSender mailSender;

    public void sendEmail(SendEmailRequest emailRequest) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(emailRequest.to());
        message.setSubject(emailRequest.subject());
        message.setText(emailRequest.text());
        message.setFrom(emailRequest.form()); // Thay bằng email của bạn
        mailSender.send(message);
    }
}
