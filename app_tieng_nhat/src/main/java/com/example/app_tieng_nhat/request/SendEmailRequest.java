package com.example.app_tieng_nhat.request;

public record SendEmailRequest(String form,
                                String to,
                                String subject,
                                String text) {
}
