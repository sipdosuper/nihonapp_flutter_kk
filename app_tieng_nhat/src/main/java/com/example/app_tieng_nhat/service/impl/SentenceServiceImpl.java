package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.*;
import com.example.app_tieng_nhat.repository.LessonRepository;
import com.example.app_tieng_nhat.repository.SentenceRepository;
import com.example.app_tieng_nhat.repository.VolucabularyRepository;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonIdRequest;
import com.example.app_tieng_nhat.service.SentenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class SentenceServiceImpl implements SentenceService {
    @Autowired
    private SentenceRepository sentenceRepository;
    @Autowired
    private LessonRepository lessonRepository;
    @Autowired
    private VolucabularyRepository volucabularyRepository;


    @Override
    public List<Sentence> getAllSentence() {
        return sentenceRepository.findAll();
    }



    @Override
    public List<Sentence> getSentenceByLessonId(GetSentenceByLessonIdRequest lessonIdRequest) {
        Optional<Lessons> checkLesson= lessonRepository.findById(lessonIdRequest.lesson_id());
        if(checkLesson.isPresent()){
            return sentenceRepository.findSentenceByLessonId(lessonIdRequest.lesson_id());
        }
        return null;
    }



    @Override
    public Optional<Sentence> getSentenceById(Long id) {
        return sentenceRepository.findById(id);
    }

    @Override
    public Sentence createSentence(CreateUpdateSentenceRequest sentenceRequest) {
        Optional<Lessons> lessons= lessonRepository.findById(sentenceRequest.lesson_id());
        if(lessons.isPresent()){
            Sentence newsentence= new Sentence();
            newsentence.setWord(sentenceRequest.word());
            newsentence.setMeaning(sentenceRequest.meaning());
            newsentence.setTranscription(sentenceRequest.transcription());
            newsentence.setAnswer(sentenceRequest.answer());
            newsentence.setLesson(lessons.get());

            Set<Vocabularies> vocabulariesSet=findVocabularyWithSentence(sentenceRequest.word());
            if(vocabulariesSet.isEmpty()){
                return null;
            }
            newsentence.setLitsvocabulary(vocabulariesSet);
            Sentence saveSentence= sentenceRepository.save(newsentence);
            return saveSentence;
        }
        return null;
    }

    @Override
    public Sentence updateSentence(CreateUpdateSentenceRequest sentenceRequest) {
        Optional<Lessons> lessons= lessonRepository.findById(sentenceRequest.lesson_id());
        if(lessons.isPresent()){

            Sentence newsentence= new Sentence();
            newsentence.setWord(sentenceRequest.word());
            newsentence.setMeaning(sentenceRequest.meaning());
            newsentence.setTranscription(sentenceRequest.transcription());
            newsentence.setAnswer(sentenceRequest.answer());
            newsentence.setLesson(lessons.get());
            Set<Vocabularies> vocabulariesSet=findVocabularyWithSentence(sentenceRequest.word());
            newsentence.setLitsvocabulary(vocabulariesSet);
            Sentence saveSentence= sentenceRepository.save(newsentence);
            return saveSentence;
        }
        return null;
    }
    private Set<Vocabularies> findVocabularyWithSentence(String word){
//        String[] words = word.split(" ");
        String[] words = word.split("　");

//        String[] words = word.trim().split("\\s+");
        Set<Vocabularies> vocabularies = new HashSet<Vocabularies>();

        // Step 2: Find vocabularies for each word
        for (String w : words) {
            Vocabularies vocab = volucabularyRepository.findByWord(w);
            if (vocab != null) {
                vocabularies.add(vocab);
            }
        }
        return vocabularies;
    }


    @Override
    public void deleteSentence(Long id) {
        sentenceRepository.deleteById(id);
    }

    @Override
    public String createReturnStr(CreateUpdateSentenceRequest sentenceRequest) {
        Optional<Lessons> lessons= lessonRepository.findById(sentenceRequest.lesson_id());
        if(lessons.isEmpty())return  "Lesson is not exist!";
        try {
            Sentence newsentence= new Sentence();
            newsentence.setWord(sentenceRequest.word());
            newsentence.setMeaning(sentenceRequest.meaning());
            newsentence.setTranscription(sentenceRequest.transcription());
            newsentence.setAnswer(sentenceRequest.answer());
            newsentence.setLesson(lessons.get());

            Set<Vocabularies> vocabulariesSet=findVocabularyWithSentence(sentenceRequest.word());
//        if(vocabulariesSet.isEmpty()){
//            return "Error don't find vocabulary for this sentence";
//        }
            newsentence.setLitsvocabulary(vocabulariesSet);
            sentenceRepository.save(newsentence);

            return "create sentence success";
        }catch (Exception e){
            return "Co bien roi: "+e.getMessage();
        }

    }
}
