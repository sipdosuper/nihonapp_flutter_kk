package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.service.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lesson")
public class LessonController {
    @Autowired
    private LessonService lessonService;

    @GetMapping
    public List<Lessons>getAllLesson(){
        return lessonService.getAllLesson();
    }

    @GetMapping("/{id}")
    public Lessons getLessonByID(Long id){
        return  lessonService.getLessonByID(id);
    }

    @PostMapping
    public Lessons createLesson(Lessons lessons){
        return lessonService.createLesson(lessons);
    }

    @PutMapping("/update/{id}")
    public Lessons updateLesson(Long id, Lessons lessons){
        return lessonService.updateLesson(id,lessons);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteLesson(Long id){
        lessonService.deleteLesson(id);
    }


}
