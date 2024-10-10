package com.example.app_tieng_nhat.DTO;

import lombok.Data;

@Data
public class VocabularyDTO {
    private Long id;
    private String word;
    private String meaning;
    private String example;
}
