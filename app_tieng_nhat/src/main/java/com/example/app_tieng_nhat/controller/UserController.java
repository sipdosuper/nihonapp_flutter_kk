package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.DTO.ClassRoomDTO;
import com.example.app_tieng_nhat.DTO.UserDTO;
import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.request.ForgotPasswordRequest;
import com.example.app_tieng_nhat.request.SignInRequest;
import com.example.app_tieng_nhat.request.SignUpRequest;
import com.example.app_tieng_nhat.request.UpdateUserLevelRequest;
import com.example.app_tieng_nhat.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userService;
    @GetMapping
    public List<UserDTO> getAllUser(){
        return userService.getAllUser();
    }

    @GetMapping("/getdto/{id}")
    public UserDTO getUserDTOById(@PathVariable Long id){return userService.getUserDTOById(id);}

    @GetMapping("/signup-stats")
    public ResponseEntity<Map<Integer, Long>> getUserSignupStats(
            @RequestParam("year") int year) {

        Map<Integer, Long> stats = userService.getUserSignUpStats(year);
        return ResponseEntity.ok(stats);
    }


    @GetMapping("/recommented")
    public List<ClassRoomDTO> recommentedCouse(@RequestParam("email") String email){
        return userService.recommentedCouse(email);
    }

    @GetMapping("/{id}")
    public Users getUserByID(@PathVariable Long id){
        return  userService.getUserByID(id);
    }

    @PostMapping("/signIn")
    public String signIn(@RequestBody SignInRequest request){
        return userService.signIn(request);
    }

    @PostMapping
    public Users createUser(@RequestBody SignUpRequest user){
        return userService.createUser(user);
    }

    @PostMapping("/update")
    public String updateUser(@RequestBody UpdateUserLevelRequest request){
        return userService.updateUserLevel(request);
    }

    @PutMapping("/forgot/{id}")
    public Users forGotPassword(@RequestBody ForgotPasswordRequest forgotPasswordRequest){return userService.forGotPassword(forgotPasswordRequest);}

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id){
        userService.deleteUser(id);
    }

}
