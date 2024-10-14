package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.UserProgress;
import com.example.app_tieng_nhat.service.UserProgressService;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class UserProgressServiceImpl implements UserProgressService {
    @Override
    public List<UserProgress> getAllUserProgress() {
        return List.of();
    }

    @Override
    public UserProgress getUserProgressByID(Long id) {
        return null;
    }

    @Override
    public UserProgress createUserProgress(UserProgress userProgres) {
        return null;
    }

    @Override
    public UserProgress updateUserProgress(Long id, UserProgress userProgres) {
        return null;
    }

    @Override
    public void deleteUserProgress(Long id) {

    }
}
