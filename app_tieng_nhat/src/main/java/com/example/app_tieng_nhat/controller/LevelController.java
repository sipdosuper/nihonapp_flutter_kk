package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.request.UpdateLevelRequest;
import com.example.app_tieng_nhat.service.LevelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/level")
public class LevelController {
    @Autowired
    private LevelService levelService;

    @GetMapping
    public List<Levels> getAllLevel(){
        return levelService.getAllLevel();
    }

    @GetMapping("/{id}")
    public Optional<Levels> getLevelByID(@PathVariable Long id){
        return  levelService.getLevelByID(id);
    }

    @PostMapping
    public Levels createLevel(@RequestBody Levels level){
        return levelService.createLevel(level);
    }

    @PutMapping("/update/{id}")
    public Levels updateLevel(UpdateLevelRequest updateLevelRequest){
        return levelService.updateLevel(updateLevelRequest);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteLevel(@PathVariable Long id){
        levelService.deleteLevel(id);
    }
}
