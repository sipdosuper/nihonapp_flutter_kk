package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.DTO.StudentRegistrationDTO;
import com.example.app_tieng_nhat.model.StudentRegistration;
import com.example.app_tieng_nhat.request.AddStudentToClassRoomRequest;
import com.example.app_tieng_nhat.request.CreateStudentRegistrationRequest;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public interface StudentRegistrationService {
    List<StudentRegistrationDTO> getAllStudentRegistration();
    List<StudentRegistrationDTO> getAllByBankCheck(Long check);
    String registrationClassRoom(CreateStudentRegistrationRequest studentRegistrationRequest);
    String addStudentToClassRoom(AddStudentToClassRoomRequest request);
    void deleteStudentRegis(Long id);
}
