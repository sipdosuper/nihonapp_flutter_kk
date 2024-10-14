package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.UserProgress;
import com.example.app_tieng_nhat.service.UserProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/userprogress")
public class UserProgressController {
    @Autowired
    private UserProgressService userProgressService;

    @GetMapping
    public List<UserProgress> getAllUserProgress(){
        return userProgressService.getAllUserProgress();
    }

    @GetMapping("/{id}")
    public UserProgress getUserProgressByID(@PathVariable Long id){
        return  userProgressService.getUserProgressByID(id);
    }

    @PostMapping
    public UserProgress createUserProgress(@RequestBody UserProgress userProgress){
        return userProgressService.createUserProgress(userProgress);
    }

    @PutMapping("/{id}")
    public UserProgress updateUserProgress(Long id, UserProgress userProgress){
        return userProgressService.updateUserProgress(id,userProgress);
    }

    @DeleteMapping("/{id}")
    public void deleteUserProgress(@PathVariable Long id){
        userProgressService.deleteUserProgress(id);
    }
}
