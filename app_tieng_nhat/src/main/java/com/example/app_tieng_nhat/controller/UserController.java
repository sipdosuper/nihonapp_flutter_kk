package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.DTO.UserDTO;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.request.ForgotPasswordRequest;
import com.example.app_tieng_nhat.request.SignInRequest;
import com.example.app_tieng_nhat.request.SignUpRequest;
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

    @GetMapping("/getdto/{id}")
    public UserDTO getUserDTOById(@PathVariable Long id){return userService.getUserDTOById(id);}

    @GetMapping("/{id}")
    public Users getUserByID(@PathVariable Long id){
        return  userService.getUserByID(id);
    }

    @GetMapping("/signIn")
    public String signIn(@RequestBody SignInRequest request){
        return userService.signIn(request);
    }

    @PostMapping
    public Users createUser(@RequestBody SignUpRequest user){
        return userService.createUser(user);
    }

    @PutMapping("/update/{id}")
    public Users updateUser(Long id, Users lessons){
        return userService.updateUser(id,lessons);
    }

    @PutMapping("/forgot/{id}")
    public Users forGotPassword(@RequestBody ForgotPasswordRequest forgotPasswordRequest){return userService.forGotPassword(forgotPasswordRequest);}

    @DeleteMapping("/delete/{id}")
    public void deleteUser(@PathVariable Long id){
        userService.deleteUser(id);
    }

}
