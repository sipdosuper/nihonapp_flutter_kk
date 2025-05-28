package com.example.app_tieng_nhat.request;

public record StudentAnswerRequest(String student_answer,
                                   String audio,
                                   String teacher_note,
                                   Float point,
                                   Long homeWork_id,
                                   String email) {
}
