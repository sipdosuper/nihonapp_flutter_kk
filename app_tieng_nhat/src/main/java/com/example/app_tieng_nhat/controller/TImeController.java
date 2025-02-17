package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Time;
import com.example.app_tieng_nhat.request.CreateTimeRequest;
import com.example.app_tieng_nhat.request.MultiCreateTimeRequest;
import com.example.app_tieng_nhat.service.TimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/time")
public class TImeController {
    @Autowired
    private TimeService timeService;

    @GetMapping
    public List<Time> getAllTime(){
        return timeService.getAllTime();
    }

    @PostMapping
    public String createTime(@RequestBody CreateTimeRequest timeRequest){
        return timeService.createTime(timeRequest);
    }





    @DeleteMapping("/{id}")
    void deleteTime(@PathVariable Long id){
        timeService.deleteTime(id);
    }
}
