package com.example.app_tieng_nhat.request;

public record CreateUpdateSentenceRequest (
                                           String word,
                                           String meaning,
                                           String transcription,
                                           String answer,
                                           Long lesson_id){
}
