package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.DTO.StudentRegistrationDTO;
import com.example.app_tieng_nhat.model.StudentRegistration;
import com.example.app_tieng_nhat.request.AddStudentToClassRoomRequest;
import com.example.app_tieng_nhat.request.CreateStudentRegistrationRequest;
import com.example.app_tieng_nhat.service.StudentRegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/studentRegistration")
public class StudentRegistrationController {
    @Autowired
    private StudentRegistrationService studentRegistrationService;

    @GetMapping
    public List<StudentRegistrationDTO> getAllStudentRegistration(){
        return studentRegistrationService.getAllStudentRegistration();
    }

    @GetMapping("/{check}")
    public List<StudentRegistrationDTO> getAllByBankCheck(@PathVariable Long check){
        return studentRegistrationService.getAllByBankCheck(check);
    }

    @PostMapping
    public String createStudentRegistration(@RequestBody CreateStudentRegistrationRequest studentRegistrationRequest){
        return studentRegistrationService.registrationClassRoom(studentRegistrationRequest);
    }

    @PostMapping("/addStudent")
    public String addStudentToClassRoom(@RequestBody AddStudentToClassRoomRequest request){
        return studentRegistrationService.addStudentToClassRoom(request);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id){
        studentRegistrationService.deleteStudentRegis(id);
    }

}
