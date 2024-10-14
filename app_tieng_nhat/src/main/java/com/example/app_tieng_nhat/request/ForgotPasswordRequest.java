package com.example.app_tieng_nhat.request;

public record ForgotPasswordRequest(String email,
                                    String newPassword,
                                    String reNewPassword) {
}
