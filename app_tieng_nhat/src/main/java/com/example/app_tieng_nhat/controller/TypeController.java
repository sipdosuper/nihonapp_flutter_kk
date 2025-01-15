package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.TypeMode;
import com.example.app_tieng_nhat.request.CreateTypeRequest;
import com.example.app_tieng_nhat.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/type")
public class TypeController {
    @Autowired
    private TypeService typeService;

    @GetMapping
    public List<TypeMode> getAllType(){
        return typeService.getAllType();
    }

    @PostMapping
    public String createType(@RequestBody CreateTypeRequest typeRequest){
        return typeService.createType(typeRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteType(@PathVariable Long id){
        typeService.deleteType(id);
    }
}
