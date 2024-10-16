package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Sentence;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonIdRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonOnion;
import com.example.app_tieng_nhat.request.GetSentenceByOnionRequest;
import com.example.app_tieng_nhat.service.SentenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@RestController
@RequestMapping("/api/sentence")
public class SentenceController {
    @Autowired
    private SentenceService sentenceService;

    @GetMapping
    public List<Sentence> getAllSentence(){
        return sentenceService.getAllSentence();
    }

    @GetMapping("/{id}")
    public Optional<Sentence> getSentenceById(@PathVariable Long id){
        return sentenceService.getSentenceById(id);
    }

    @GetMapping("/getByLesson")
    public List<Sentence> getSentenceByLessonId(@RequestBody GetSentenceByLessonIdRequest lessonIdRequest){
        return  sentenceService.getSentenceByLessonId(lessonIdRequest);
    }

    @GetMapping("/getByOnion")
    public List<Sentence> getSentenceByOnionId(@RequestBody GetSentenceByOnionRequest onionRequest){
        return  sentenceService.getSentenceByOnionId(onionRequest);
    }

    @GetMapping("/byLessonOnion")
    public List<Sentence> getSentenceByLessonOnion(@RequestBody GetSentenceByLessonOnion get){
        return sentenceService.getByLessonOnion(get);
    }

    @PostMapping
    public Sentence createSentence(@RequestBody CreateUpdateSentenceRequest sentenceRequest){
        return sentenceService.createSentence(sentenceRequest);
    }

    @PutMapping
    public Sentence updateSentence(@RequestBody CreateUpdateSentenceRequest sentenceRequest){
        return  sentenceService.updateSentence(sentenceRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteSentence(@PathVariable Long id){sentenceService.deleteSentence(id);}
}
