package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Vocabularies;
import com.example.app_tieng_nhat.service.VocabularyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vocalbulary")
public class VocalbularyController {
    @Autowired
    private VocabularyService vocabularyService;

    @GetMapping
    public List<Vocabularies> getAllLesson(){
        return vocabularyService.getAllVocabularies();
    }

    @GetMapping("/{id}")
    public Vocabularies getLessonByID(Long id){
        return  vocabularyService.getVocabulariesByID(id);
    }

    @PostMapping
    public Vocabularies createLesson(Vocabularies lessons){
        return vocabularyService.createVocabularies(lessons);
    }

    @PutMapping("/update/{id}")
    public Vocabularies updateLesson(Long id, Vocabularies lessons){
        return vocabularyService.updateVocabularies(id,lessons);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteLesson(Long id){
        vocabularyService.deleteVocabularies(id);
    }
}
