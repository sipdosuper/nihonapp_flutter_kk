package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.FlashCardList;
import com.example.app_tieng_nhat.request.CreateFlashCardListRequest;
import com.example.app_tieng_nhat.request.RenameFlashCardListRequest;
import com.example.app_tieng_nhat.service.FlashCardListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/flashCardList")
public class FlashCardListController {
    @Autowired
    private FlashCardListService flashCardListService;

    @GetMapping
    public List<FlashCardList> getAllFlashCardList(){
        return flashCardListService.getAllFlashCardList();
    }

    @PostMapping
    public String createFlashCardList(@RequestBody CreateFlashCardListRequest request){
        return flashCardListService.createFlashCardList(request);
    }

    @PostMapping("/rename")
    public String renameFlashCardList(@RequestBody RenameFlashCardListRequest request){
        return flashCardListService.renameFlashCardList(request);
    }

    @DeleteMapping("/{id}")
    void delete(@PathVariable Long id){
        flashCardListService.delete(id);
    }
}
