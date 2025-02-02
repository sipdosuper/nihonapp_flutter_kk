package com.example.app_tieng_nhat.request;

import java.time.LocalDate;

public record CreateTeacherRegistrationForm(String name,
                                            String email,
                                            String phone,
                                            LocalDate birthDay,
                                            String proof,
                                            String introduce,
                                            LocalDate regisDay,
                                            Long level_id,
                                            Long workingTime_id) {
}
