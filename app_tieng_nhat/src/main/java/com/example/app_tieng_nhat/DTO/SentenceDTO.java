package com.example.app_tieng_nhat.DTO;

import com.example.app_tieng_nhat.model.Vocabularies;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.util.Set;

@Data
public class SentenceDTO {
    private Long id;
    private String word;
    private String meaning;
    private String transcription;
    private Set<Vocabularies> vocabularies;

}
