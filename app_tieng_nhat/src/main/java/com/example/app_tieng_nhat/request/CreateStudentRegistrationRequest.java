package com.example.app_tieng_nhat.request;

import java.time.LocalDate;

public record CreateStudentRegistrationRequest(String nameAndSdt,
                                               LocalDate regisDay,
                                               String bill,
                                               String email,
                                               Long classRoom_id) {
}
