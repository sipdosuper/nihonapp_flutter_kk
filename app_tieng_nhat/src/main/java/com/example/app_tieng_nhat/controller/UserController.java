package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userService;
    @GetMapping
    public List<Users> getAllUser(){
        return userService.getAllUser();
    }

    @GetMapping("/{id}")
    public Users getUserByID(Long id){
        return  userService.getUserByID(id);
    }

    @PostMapping
    public Users createUser(Users lessons){
        return userService.createUser(lessons);
    }

    @PutMapping("/update/{id}")
    public Users updateUser(Long id, Users lessons){
        return userService.updateUser(id,lessons);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteUser(Long id){
        userService.deleteUser(id);
    }

}
