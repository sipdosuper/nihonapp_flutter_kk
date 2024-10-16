package com.example.app_tieng_nhat.request;

public record CreateLessonRequest(Long id,
                                  String title,
                                  Long topic_id) {
}
