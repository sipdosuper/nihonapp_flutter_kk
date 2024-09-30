package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.service.UserService;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class UserServiceImple implements UserService {
    @Override
    public List<Users> getAllUser() {
        return List.of();
    }

    @Override
    public Users getUserByID(Long id) {
        return null;
    }

    @Override
    public Users createUser(Users user) {
        return null;
    }

    @Override
    public Users updateUser(Long id, Users user) {
        return null;
    }

    @Override
    public void deleteUser(Long id) {

    }
}
