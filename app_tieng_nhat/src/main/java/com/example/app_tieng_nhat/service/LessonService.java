package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Users;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface LessonService {
    List<Lessons> getAllLesson();
    Lessons getLessonByID(Long id);
    Lessons createLesson(Lessons lesson);
    Lessons updateLesson(Long id, Lessons lessonDetal);
    void deleteLesson(Long id);
}
