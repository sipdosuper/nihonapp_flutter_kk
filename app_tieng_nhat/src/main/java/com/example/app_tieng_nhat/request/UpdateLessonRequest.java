package com.example.app_tieng_nhat.request;

public record UpdateLessonRequest (Long id,
                                   String title,
                                   Long topic_id){
}
