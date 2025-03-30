package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.DTO.ClassRoomDTO;
import com.example.app_tieng_nhat.DTO.UserDTO;
import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.request.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface UserService {
    List<UserDTO> getAllUser();
    Users getUserByID(Long id);
    Map<Integer,Long> getUserSignUpStats(int year);
    Users createUser(SignUpRequest user);
    String updateUserLevel(UpdateUserLevelRequest request);
    void deleteUser(Long id);
    Users forGotPassword(ForgotPasswordRequest forgotPasswordRequest);
    UserDTO getUserDTOById(Long id);
    String signIn(SignInRequest signIn);
    List<ClassRoomDTO> recommentedCouse(String email);
}
