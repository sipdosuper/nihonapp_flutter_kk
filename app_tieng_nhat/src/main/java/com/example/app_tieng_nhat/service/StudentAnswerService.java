package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.User_HomeWork;
import com.example.app_tieng_nhat.request.StudentAnswerRequest;
import com.example.app_tieng_nhat.request.TeacherGrandingHomeWorkRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface StudentAnswerService {
    List<User_HomeWork> getAllUser_HomeWork();
    String createAnswer(StudentAnswerRequest studentAnswerRequest);
    String teacherUpdatePointAndNote(TeacherGrandingHomeWorkRequest grandingHomeWorkRequest);
    void deleteAnswer(Long id);
}
