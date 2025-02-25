package com.example.app_tieng_nhat.DTO;

import lombok.Data;

import java.time.LocalDate;

@Data
public class StudentRegistrationDTO {
    private Long id;
    private String nameAndSdt;
    private String email;
    private Boolean bankCheck;
    private LocalDate regisDay;
    private String bill;
    private Boolean status;
    private Long studentId;
    private Long classRoomId;
}
