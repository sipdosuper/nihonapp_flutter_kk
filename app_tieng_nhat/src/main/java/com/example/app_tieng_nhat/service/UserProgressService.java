package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.UserProgress;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface UserProgressService {
    List<UserProgress> getAllUserProgress();
    UserProgress getUserProgressByID(Long id);
    UserProgress createUserProgress(UserProgress userProgres);
    UserProgress updateUserProgress(Long id, UserProgress userProgres);
    void deleteUserProgress(Long id);
}
