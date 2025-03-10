package com.example.app_tieng_nhat.DTO;

import lombok.Data;

@Data
public class User_HomeWorkDTO {
    private Long id;

    private String student_answer;
    private String audio;

    private String teacher_note;
    private Float point;
    private Long userId;
    private Long homeworkId;
}
