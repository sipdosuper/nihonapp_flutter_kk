package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.request.SendEmailRequest;
import org.springframework.stereotype.Service;

@Service
public interface EmailService {
    void sendEmail(SendEmailRequest emailRequest);
}
