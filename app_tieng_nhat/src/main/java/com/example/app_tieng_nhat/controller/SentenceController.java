package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Sentence;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import com.example.app_tieng_nhat.request.GetSentenceByLessonOnion;
import com.example.app_tieng_nhat.service.SentenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

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

    @DeleteMapping("delete/{id}")
    public void deleteSentence(@PathVariable Long id){sentenceService.deleteSentence(id);}
}
