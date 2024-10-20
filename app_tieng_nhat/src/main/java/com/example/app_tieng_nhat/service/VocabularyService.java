package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Vocabularies;
import com.example.app_tieng_nhat.request.CreateVocabularyRequest;
import com.example.app_tieng_nhat.request.UpdateVocabularyRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface VocabularyService {
    List<Vocabularies> getAllVocabularies();
    Vocabularies getVocabulariesByID(Long id);
    Vocabularies createVocabularies(CreateVocabularyRequest vocabularyRequest);
    Vocabularies updateVocabularies(UpdateVocabularyRequest vocabularyRequest);
    void deleteVocabularies(Long id);
    Vocabularies getByWord(String w);
}
