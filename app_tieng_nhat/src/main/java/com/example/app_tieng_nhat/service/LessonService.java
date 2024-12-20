package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.request.CreateLessonRequest;
import com.example.app_tieng_nhat.request.GetLessonByTopicLevelRequest;
import com.example.app_tieng_nhat.request.UpdateLessonRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface LessonService {
    List<Lessons> getAllLesson();
    List<Lessons> getAllLessonByTopic(GetLessonByTopicLevelRequest lesson);
    Lessons getLessonByID(Long id);
    Lessons createLesson(CreateLessonRequest lesson);
    Lessons updateLesson(UpdateLessonRequest lessonRequest);
    void deleteLesson(Long id);
    String createReturnStr(CreateLessonRequest lessonRequest);
    String updateReturnStr(UpdateLessonRequest lessonRequest);
}
