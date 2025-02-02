package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Teacher;
import com.example.app_tieng_nhat.request.AddTeacherToClassRoomRequest;
import com.example.app_tieng_nhat.request.CreateTeacherRequest;
import com.example.app_tieng_nhat.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/teacher")
public class TeacherController {
    @Autowired
    private TeacherService teacherService;

    @GetMapping
    public List<Teacher> getAllTeacher(){
        return teacherService.getAllTeacher();
    }
    @PostMapping
    public String createTeacher(@RequestBody CreateTeacherRequest teacherRequest){
        return teacherService.createTeacher(teacherRequest);
    }

    @PostMapping("/addTeacher")
    public String addTeacherToClassRoom(@RequestBody AddTeacherToClassRoomRequest request){
        return teacherService.addTeacherToClassRoom(request);
    }

    @DeleteMapping("/{id}")
    void deleteTeacher(@PathVariable Long id){
        teacherService.deleteTeacher(id);
    }
}
