package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.request.SendEmailRequest;
import com.example.app_tieng_nhat.request.UpdateEmailInFormationRequest;
import org.springframework.stereotype.Service;

@Service
public interface EmailService {
    void updateMailSender(UpdateEmailInFormationRequest request);
    void sendEmail(SendEmailRequest emailRequest);
}
