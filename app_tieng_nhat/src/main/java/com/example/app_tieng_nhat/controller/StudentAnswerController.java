package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.User_HomeWork;
import com.example.app_tieng_nhat.request.StudentAnswerRequest;
import com.example.app_tieng_nhat.request.TeacherGrandingHomeWorkRequest;
import com.example.app_tieng_nhat.service.StudentAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/answer")
public class StudentAnswerController {
    @Autowired
    public StudentAnswerService studentAnswerService;

    @GetMapping
    List<User_HomeWork> getAllStudentAnswer(){
        return studentAnswerService.getAllUser_HomeWork();
    }

    @PostMapping
    public String createStudentAnswer(@RequestBody StudentAnswerRequest answerRequest){
        return studentAnswerService.createAnswer(answerRequest);
    }

    @PostMapping("/grading")
    public String teacherGradingHomeWork(@RequestBody TeacherGrandingHomeWorkRequest grandingHomeWorkRequest){
        return studentAnswerService.teacherUpdatePointAndNote(grandingHomeWorkRequest);
    }

    @DeleteMapping("/{id}")
    void deleteAnswer(@PathVariable Long id){
        studentAnswerService.deleteAnswer(id);
    }
}
