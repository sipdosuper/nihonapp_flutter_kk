package com.example.app_tieng_nhat.request;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

public record UpdateVocabularyRequest (Long id,
                                       String word,
                                       String meaning,
                                       String transcription,
                                       String example,
                                       Long sentence_id){
}
