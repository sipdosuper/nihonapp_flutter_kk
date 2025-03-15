package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.DTO.User_HomeWorkDTO;
import com.example.app_tieng_nhat.model.HomeWork;
import com.example.app_tieng_nhat.request.CreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.MultiCreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.MultiCreateTimeRequest;
import com.example.app_tieng_nhat.request.UpdateHomeWorkRequest;
import com.example.app_tieng_nhat.service.HomeWorkSerVice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;

@RestController
@RequestMapping("/api/homework")
public class HomeWorkController {
    @Autowired
    private HomeWorkSerVice homeWorkSerVice;

    @GetMapping
    public List<HomeWork> getAllHomeWork(){
        return homeWorkSerVice.getAllHomeWork();
    }

    // lấy ra user_homework
    @GetMapping("/dto")
    public List<User_HomeWorkDTO> getAllUserHomeWork(){
        return homeWorkSerVice.getAllUserHomeWork();
    }

    @GetMapping("/{id}")
    public List<HomeWork> getAllByClassRoomId(@PathVariable Long id){
        return homeWorkSerVice.getHomeWorkByClassRoomId(id);
    }

    @GetMapping("/dto/{id}")
    List<User_HomeWorkDTO> getAllUserHomeWorkByHomeWorkId(@PathVariable Long id){
        return homeWorkSerVice.getAllUserHomeWorkByHomeWorkId(id);
    }

    @PostMapping
    public String createHomeWork(@RequestBody CreateHomeWorkRequest homeWorkRequest){
        return homeWorkSerVice.createHomeWork(homeWorkRequest);
    }



    @PostMapping("/update")
    public String updateHomeWork(@RequestBody UpdateHomeWorkRequest homeWorkRequest){
        return homeWorkSerVice.updateHomeWork(homeWorkRequest);
    }

    @DeleteMapping("/{id}")
    void deleteHomeWork(@PathVariable Long id){
        homeWorkSerVice.deleteHomeWork(id);
    }
}
