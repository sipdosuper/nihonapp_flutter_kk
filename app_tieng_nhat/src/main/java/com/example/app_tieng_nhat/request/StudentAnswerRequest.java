package com.example.app_tieng_nhat.request;

public record StudentAnswerRequest(String student_answer,
                                   String teacher_note,
                                   Float point,
                                   Long homeWork_id,
                                   Long student_id) {
}
