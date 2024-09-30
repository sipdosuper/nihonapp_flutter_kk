package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Vocabularies;
import com.example.app_tieng_nhat.service.VocabularyService;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class VocabularyServiceImple implements VocabularyService {
    @Override
    public List<Vocabularies> getAllVocabularies() {
        return List.of();
    }

    @Override
    public Vocabularies getVocabulariesByID(Long id) {
        return null;
    }

    @Override
    public Vocabularies createVocabularies(Vocabularies vocabulary) {
        return null;
    }

    @Override
    public Vocabularies updateVocabularies(Long id, Vocabularies vocabulary) {
        return null;
    }

    @Override
    public void deleteVocabularies(Long id) {

    }
}
