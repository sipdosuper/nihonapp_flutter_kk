package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.FlashCard;
import com.example.app_tieng_nhat.request.CreateFlashCardRequest;
import com.example.app_tieng_nhat.service.FlashCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/flashCard")
public class FlashCardController {
    @Autowired
    private FlashCardService flashCardService;

    @GetMapping
    public List<FlashCard> getAllFlashCard(){
        return flashCardService.getAllFlashCard();
    }

    @PostMapping("/{id}")
    public List<FlashCard> getAllFlashCardByFlashCardListId(@PathVariable Long id){
        return flashCardService.getFlashCardByListId(id);
    }

    @PostMapping
    public String createFlashCard(@RequestBody CreateFlashCardRequest request){
        return flashCardService.createFlashCard(request);
    }
    // tạo nhiều flashcard 1 lúc 
    @PostMapping("/multi")
    public String multiCreateFlashCard(@RequestBody List<CreateFlashCardRequest> list){
        return flashCardService.multiCreateFlashCard(list);
    }

    @DeleteMapping("/{id}")
    void delete(@PathVariable Long id){
        flashCardService.delete(id);
    }
}
