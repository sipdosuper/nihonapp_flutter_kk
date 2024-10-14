package com.example.app_tieng_nhat.request;

public record CreateUpdateSentenceRequest (Long id,
                                           String word,
                                           String meaning,
                                           String transcription,
                                           String answer,
                                           Long lesson_id,
                                           Long onion_id){
}
