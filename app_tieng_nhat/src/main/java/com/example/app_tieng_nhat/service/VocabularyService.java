package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Vocabularies;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface VocabularyService {
    List<Vocabularies> getAllVocabularies();
    Vocabularies getVocabulariesByID(Long id);
    Vocabularies createVocabularies(Vocabularies vocabulary);
    Vocabularies updateVocabularies(Long id, Vocabularies vocabulary);
    void deleteVocabularies(Long id);
}
