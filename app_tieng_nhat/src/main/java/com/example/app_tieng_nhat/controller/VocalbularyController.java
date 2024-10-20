package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Vocabularies;
import com.example.app_tieng_nhat.request.CreateVocabularyRequest;
import com.example.app_tieng_nhat.request.UpdateVocabularyRequest;
import com.example.app_tieng_nhat.service.VocabularyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vocabulary")
public class VocalbularyController {
    @Autowired
    private VocabularyService vocabularyService;

    @GetMapping("/get/{w}")
    public Vocabularies getByWord(@PathVariable String w){
        return vocabularyService.getByWord(w);
    }

    @GetMapping
    public List<Vocabularies> getAllLesson(){
        return vocabularyService.getAllVocabularies();
    }

    @GetMapping("/{id}")
    public Vocabularies getLessonByID(@PathVariable Long id){
        return  vocabularyService.getVocabulariesByID(id);
    }

    @PostMapping
    public Vocabularies createLesson(@RequestBody CreateVocabularyRequest vocabularyRequest){
        return vocabularyService.createVocabularies(vocabularyRequest);
    }

    @PutMapping
    public Vocabularies updateLesson(@RequestBody UpdateVocabularyRequest vocabularyRequest){
        return vocabularyService.updateVocabularies(vocabularyRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteLesson(@PathVariable Long id){
        vocabularyService.deleteVocabularies(id);
    }
}
