package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.request.CreateLessonRequest;
import com.example.app_tieng_nhat.request.GetLessonByTopicLevelRequest;
import com.example.app_tieng_nhat.request.UpdateLessonRequest;
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

    @GetMapping("/getByTopicLevel")
    public List<Lessons>getAllLessonByLevelAndTopic(@RequestBody GetLessonByTopicLevelRequest lesson){
        return lessonService.getAllLessonByTopic(lesson);
    }

    @GetMapping("/{id}")
    public Lessons getLessonByID(@PathVariable Long id){
        return  lessonService.getLessonByID(id);
    }

    @PostMapping
    public Lessons createLesson(@RequestBody CreateLessonRequest lessons){
        return lessonService.createLesson(lessons);
    }

    //Create lesson and return a String
    @PostMapping("/cre")
    public String createLessonReturnString(@RequestBody CreateLessonRequest lessonRequest){
        return lessonService.createReturnStr(lessonRequest);
    }

    @PutMapping
    public Lessons updateLesson(@RequestBody UpdateLessonRequest lessonRequest){
        return lessonService.updateLesson(lessonRequest);
    }

    @PutMapping("/up")
    public String updateLessonReturnString(@RequestBody UpdateLessonRequest lessonRequest){
        return lessonService.updateReturnStr(lessonRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteLesson(@PathVariable Long id){
        lessonService.deleteLesson(id);
    }


}
