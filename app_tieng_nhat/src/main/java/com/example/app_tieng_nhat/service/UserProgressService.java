package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.UserProgress;
import com.example.app_tieng_nhat.request.CreateUserProgressRequest;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public interface UserProgressService {
    List<UserProgress> getAllUserProgress();
    UserProgress getUserProgressByUser(String email);
    UserProgress getUserProgressByLesson(Long lessonId);
    UserProgress createUserProgress(CreateUserProgressRequest userProgressRequest);
    void deleteUserProgressById(Long id);
}
