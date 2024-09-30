package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Users;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface UserService {
    List<Users> getAllUser();
    Users getUserByID(Long id);
    Users createUser(Users user);
    Users updateUser(Long id, Users user);
    void deleteUser(Long id);
}
