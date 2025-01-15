package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Teacher;
import com.example.app_tieng_nhat.request.ChangeTypeTeacherRequest;
import com.example.app_tieng_nhat.request.CreateTeacherRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface TeacherService {
    List<Teacher> getAllTeacher();
    String createTeacher(CreateTeacherRequest teacherRequest);
    String changeType(ChangeTypeTeacherRequest request);
    void deleteTeacher(Long id);
}
