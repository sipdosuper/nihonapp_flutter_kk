package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.request.SendEmailRequest;
import com.example.app_tieng_nhat.request.UpdateEmailInFormationRequest;
import com.example.app_tieng_nhat.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/email")
public class EmailController {

    @Autowired
    private EmailService emailService;

    public EmailController(EmailService mailService) {
        this.emailService = mailService;
    }

    @PostMapping("/update")
    public String updateMailConfig(@RequestBody UpdateEmailInFormationRequest request) {
        emailService.updateMailSender(request);
        return "Cập nhật email gửi thành công!";
    }

    @PostMapping("/send")
    public ResponseEntity<String> sendEmail(@RequestBody SendEmailRequest emailRequest) {
        try {
            emailService.sendEmail(emailRequest);
            return ResponseEntity.ok("Email sent successfully to " + emailRequest.to());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Failed to send email: " + e.getMessage());
        }
    }
}
