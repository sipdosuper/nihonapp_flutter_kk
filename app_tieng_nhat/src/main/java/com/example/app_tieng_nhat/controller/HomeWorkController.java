package com.example.app_tieng_nhat.controller;

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
