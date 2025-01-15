package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.request.CreateClassroomRequest;
import com.example.app_tieng_nhat.service.ClassRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/classroom")
public class ClassRoomController {
    @Autowired
    private ClassRoomService classRoomService;

    @GetMapping
    public List<ClassRoom> getAllClassRoom(){
        return classRoomService.getAllClassRoom();
    }

    @PostMapping
    public String createClassRoom(@RequestBody CreateClassroomRequest classroomRequest){
        return classRoomService.createClassRoom(classroomRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteClassRoom(@PathVariable Long id){
        classRoomService.deleteClassRoom(id);
    }
}
