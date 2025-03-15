package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.DTO.ClassRoomDTO;
import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.request.CreateClassroomRequest;
import com.example.app_tieng_nhat.request.GetClassRoomByEmailRequest;
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
    public List<ClassRoomDTO> getAllClassRoom(){
        return classRoomService.getAllClassRoom();
    }

    //lấy ra danh sách lớp của user theo email
    @GetMapping("/dto")
    public List<ClassRoomDTO> getAllClassRoomDTO(@RequestBody GetClassRoomByEmailRequest request){
        return classRoomService.getAllClassRoomDTO(request.email());
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
