package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Sentence;
import com.example.app_tieng_nhat.model.Vocabularies;
import com.example.app_tieng_nhat.repository.SentenceRepository;
import com.example.app_tieng_nhat.repository.VolucabularyRepository;
import com.example.app_tieng_nhat.request.CreateVocabularyRequest;
import com.example.app_tieng_nhat.request.UpdateVocabularyRequest;
import com.example.app_tieng_nhat.service.VocabularyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class VocabularyServiceImple implements VocabularyService {
    @Autowired
    private VolucabularyRepository volucabularyRepository;
    @Autowired
    private SentenceRepository sentenceRepository;
    @Override
    public List<Vocabularies> getAllVocabularies() {
        return volucabularyRepository.findAll();
    }

    @Override
    public Vocabularies getVocabulariesByID(Long id) {
        return null;
    }

    @Override
    public Vocabularies createVocabularies(CreateVocabularyRequest vocabularyRequest) {
        Optional<Sentence> sentence= sentenceRepository.findById(vocabularyRequest.sentence_id());
        if(sentence.isPresent()){
            Vocabularies vocabularies= new Vocabularies();
            vocabularies.setId(vocabularyRequest.id());
            vocabularies.setWord(vocabularyRequest.word());
            vocabularies.setMeaning(vocabularyRequest.meaning());
            vocabularies.setTranscription(vocabularyRequest.transcription());
            vocabularies.setExample(vocabularyRequest.example());
            vocabularies.setSentence(sentence.get());
            return volucabularyRepository.save(vocabularies);
        }
        return null;
    }

    @Override
    public Vocabularies updateVocabularies(UpdateVocabularyRequest vocabularyRequest) {
        Optional<Vocabularies> checkVocabulary=volucabularyRepository.findById(vocabularyRequest.id());
        Optional<Sentence> sentence= sentenceRepository.findById(vocabularyRequest.sentence_id());
        if(sentence.isPresent()&& checkVocabulary.isPresent()){
            Vocabularies vocabularies= volucabularyRepository.findById(vocabularyRequest.id()).orElse(null);
            vocabularies.setWord(vocabularyRequest.word());
            vocabularies.setMeaning(vocabularyRequest.meaning());
            vocabularies.setTranscription(vocabularyRequest.transcription());
            vocabularies.setExample(vocabularyRequest.example());
            vocabularies.setSentence(sentence.get());
            return volucabularyRepository.save(vocabularies);
        }
        return null;
    }

    @Override
    public void deleteVocabularies(Long id) {
        volucabularyRepository.deleteById(id);
    }
}
