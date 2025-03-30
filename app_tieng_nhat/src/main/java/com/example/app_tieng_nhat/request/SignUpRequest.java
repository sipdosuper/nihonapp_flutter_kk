package com.example.app_tieng_nhat.request;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

import java.time.LocalDate;

public record SignUpRequest(
                            String email,
                            String username,
                            Boolean sex,
                            String password,
                            String rePassword,
                            LocalDate signupDate,
                            Long role_id) {
}
