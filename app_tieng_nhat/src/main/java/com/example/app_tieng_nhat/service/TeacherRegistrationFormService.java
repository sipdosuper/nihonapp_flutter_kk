package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.TeacherRegistrationForm;
import com.example.app_tieng_nhat.request.CreateTeacherRegistrationForm;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface TeacherRegistrationFormService {
    List<TeacherRegistrationForm> getAllTeacherRegistrationForm();
    String createTeacherRegistrationForm(CreateTeacherRegistrationForm teacherRegistrationForm);
    void delete(Long id);
}
