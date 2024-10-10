package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Sentence;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonOnion;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface SentenceService  {
    List<Sentence> getAllSentence();
    List<Sentence> getByLessonOnion(GetSentenceByLessonOnion get);
    Optional<Sentence> getSentenceById(Long id);
    Sentence createSentence(CreateUpdateSentenceRequest sentenceRequest);
    Sentence updateSentence(CreateUpdateSentenceRequest sentenceRequest);
    void deleteSentence(Long id);
}
