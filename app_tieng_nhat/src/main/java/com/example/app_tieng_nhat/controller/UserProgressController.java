package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.UserProgress;
import com.example.app_tieng_nhat.request.CreateUserProgressRequest;
import com.example.app_tieng_nhat.service.UserProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/userProgress")
public class UserProgressController {
    @Autowired
    private UserProgressService userProgressService;

    @GetMapping
    List<UserProgress> getAllUserProgress(){
        return userProgressService.getAllUserProgress();
    }

    @GetMapping("/byEmail")
    UserProgress getByEmail(@RequestBody String email){
        return userProgressService.getUserProgressByUser(email);
    }

    @PostMapping
    UserProgress createAndUpdate(@RequestBody CreateUserProgressRequest userProgressRequest){
        return userProgressService.createUserProgress(userProgressRequest);
    }

    @DeleteMapping("/{id}")
    void deleteById(@PathVariable Long id){
        userProgressService.deleteUserProgressById(id);
    }
}
