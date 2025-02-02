package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.TeacherRegistrationForm;
import com.example.app_tieng_nhat.request.CreateTeacherRegistrationForm;
import com.example.app_tieng_nhat.service.TeacherRegistrationFormService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/teacherRegistration")
public class TeacherRegistrationFormController {
    @Autowired
    private TeacherRegistrationFormService teacherRegistrationFormService;

    @GetMapping
    public List<TeacherRegistrationForm> getAllTeacherRegistrationForm(){
        return teacherRegistrationFormService.getAllTeacherRegistrationForm();
    }

    @PostMapping
    public String createTeacherRegistrationForm(@RequestBody CreateTeacherRegistrationForm teacherRegistrationForm){
        return teacherRegistrationFormService.createTeacherRegistrationForm(teacherRegistrationForm);
    }

    @DeleteMapping("/{id}")
    void delete(@PathVariable Long id){
        teacherRegistrationFormService.delete(id);
    }
}
