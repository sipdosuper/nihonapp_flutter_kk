package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.DTO.UserDTO;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.request.ForgotPasswordRequest;
import com.example.app_tieng_nhat.request.SignInRequest;
import com.example.app_tieng_nhat.request.SignUpRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface UserService {
    List<Users> getAllUser();
    Users getUserByID(Long id);
    Users createUser(SignUpRequest user);
    Users updateUser(Long id, Users user);
    void deleteUser(Long id);
    Users forGotPassword(ForgotPasswordRequest forgotPasswordRequest);
    UserDTO getUserDTOById(Long id);
    String signIn(SignInRequest signIn);
}
