package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.Onion;
import com.example.app_tieng_nhat.model.Sentence;
import com.example.app_tieng_nhat.repository.LessonRepository;
import com.example.app_tieng_nhat.repository.OnionRepository;
import com.example.app_tieng_nhat.repository.SentenceRepository;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonIdRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonOnion;
import com.example.app_tieng_nhat.request.GetSentenceByOnionRequest;
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
    private OnionRepository onionRepository;

    @Override
    public List<Sentence> getAllSentence() {
        return sentenceRepository.findAll();
    }

    @Override
    public List<Sentence> getByLessonOnion(GetSentenceByLessonOnion get) {
        Optional<Lessons> lessons=lessonRepository.findById(get.lesson_id());
        Optional<Onion> onion = onionRepository.findById(get.onion_id());
        List<Sentence> listSen= sentenceRepository.findAll();
        if(lessons.isPresent()&& onion.isPresent()){
            List<Sentence> list= new ArrayList<Sentence>();
            for(Sentence sentence : listSen){
                if(sentence.getLesson().getId().equals(get.lesson_id())&&sentence.getOnion().getId().equals(get.onion_id())){
                    list.add(sentence);
                }
            }
            return list;
        }
        return null;
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
    public List<Sentence> getSentenceByOnionId(GetSentenceByOnionRequest onionRequest) {
        Optional<Lessons> checkLesson= lessonRepository.findById(onionRequest.onion_id());
        if(checkLesson.isPresent()){
            return sentenceRepository.findSentenceByLessonId(onionRequest.onion_id());
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
        Optional<Onion> onion= onionRepository.findById(sentenceRequest.onion_id());
        if(lessons.isPresent()&& onion.isPresent()){
            Sentence newsentence= new Sentence();
            newsentence.setId(sentenceRequest.id());
            newsentence.setWord(sentenceRequest.word());
            newsentence.setMeaning(sentenceRequest.meaning());
            newsentence.setTranscription(sentenceRequest.transcription());
            newsentence.setAnswer(sentenceRequest.answer());
            newsentence.setLesson(lessons.get());
            newsentence.setOnion(onion.get());
            return sentenceRepository.save(newsentence);
        }
        return null;
    }

    @Override
    public Sentence updateSentence(CreateUpdateSentenceRequest sentenceRequest) {
        Optional<Sentence> checkSentence= sentenceRepository.findById(sentenceRequest.id());
        Optional<Lessons> lessons= lessonRepository.findById(sentenceRequest.lesson_id());
        Optional<Onion> onion= onionRepository.findById(sentenceRequest.onion_id());
        if(checkSentence.isPresent()&& lessons.isPresent()&& onion.isPresent()){
            Sentence newsentence= new Sentence();
            newsentence.setId(sentenceRequest.id());
            newsentence.setWord(sentenceRequest.word());
            newsentence.setMeaning(sentenceRequest.meaning());
            newsentence.setTranscription(sentenceRequest.transcription());
            newsentence.setAnswer(sentenceRequest.answer());
            newsentence.setLesson(lessons.get());
            newsentence.setOnion(onion.get());
            return sentenceRepository.save(newsentence);
        }
        return null;
    }

    @Override
    public void deleteSentence(Long id) {
        sentenceRepository.deleteById(id);
    }
}
