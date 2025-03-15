package com.example.app_tieng_nhat.request;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

public record SignUpRequest(
                            String email,
                            String username,
                            Boolean sex,
                            String password,
                            String rePassword,
                            Long role_id) {
}
