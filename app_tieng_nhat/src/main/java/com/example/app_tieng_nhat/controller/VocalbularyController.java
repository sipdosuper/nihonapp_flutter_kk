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
    public List<Vocabularies> getAllVocabulary(){
        return vocabularyService.getAllVocabularies();
    }

    @GetMapping("/{id}")
    public Vocabularies getVocabularyByID(@PathVariable Long id){
        return  vocabularyService.getVocabulariesByID(id);
    }

    @PostMapping
    public Vocabularies createVocabulary(@RequestBody CreateVocabularyRequest vocabularyRequest){
        return vocabularyService.createVocabularies(vocabularyRequest);
    }

    @PostMapping("/multi_add")
    public List<Vocabularies> multiCreateVOcabulary(@RequestBody List<Vocabularies> vocabularies){
        return  vocabularyService.multiCreateVocabulary(vocabularies);
    }

    @PutMapping
    public Vocabularies updateVocabulary(@RequestBody UpdateVocabularyRequest vocabularyRequest){
        return vocabularyService.updateVocabularies(vocabularyRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteVocabulary(@PathVariable Long id){
        vocabularyService.deleteVocabularies(id);
    }
}
