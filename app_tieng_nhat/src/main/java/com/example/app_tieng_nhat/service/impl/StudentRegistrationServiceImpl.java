package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.StudentRegistration;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.StudentRegistrationRepository;
import com.example.app_tieng_nhat.repository.UserRepository;
import com.example.app_tieng_nhat.request.AddStudentToClassRoomRequest;
import com.example.app_tieng_nhat.request.CreateStudentRegistrationRequest;
import com.example.app_tieng_nhat.service.StudentRegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StudentRegistrationServiceImpl implements StudentRegistrationService {

    @Autowired
    private StudentRegistrationRepository studentRegistrationRepository;
    @Autowired
    private ClassRepository classRepository;
    @Autowired
    private UserRepository userRepository;

    @Override
    public List<StudentRegistration> getAllStudentRegistration() {
        return studentRegistrationRepository.findAll();
    }

    @Override
    public String registrationClassRoom(CreateStudentRegistrationRequest studentRegistrationRequest) {
        Users checkUser=userRepository.findUserByEmail(studentRegistrationRequest.email());
        if (checkUser==null) return "Khong ton tai user nay";
        Optional<ClassRoom> checkClassRoom=classRepository.findById(studentRegistrationRequest.classRoom_id());
        if (checkClassRoom.isEmpty())return "khong ton tai lop nay";
        try{
            StudentRegistration newRegis= new StudentRegistration();
            newRegis.setNameAndSdt(studentRegistrationRequest.nameAndSdt());
            newRegis.setBankCheck(false);
            newRegis.setRegisDay(studentRegistrationRequest.regisDay());
            newRegis.setBill(studentRegistrationRequest.bill());
            newRegis.setStatus(false);
            newRegis.setStudent(checkUser);
            newRegis.setClassRoom(checkClassRoom.get());
            studentRegistrationRepository.save(newRegis);
            return "Da gui don dang ky";
        }catch (Exception e){
            return "Co bien roi: "+e.getMessage();
        }
    }

    @Override
    public String addStudentToClassRoom(AddStudentToClassRoomRequest request) {
        ClassRoom checkClassRoom= classRepository.findById(request.classRoom_id()).orElse(null);
        if (checkClassRoom==null)return "Khong ton tai lop nay";
        Users checkUser= userRepository.findUserByEmail(request.email());
        if (checkUser==null)return "Khong ton tai hoc sinh nay";
        try {
            StudentRegistration form=studentRegistrationRepository.findById(request.regisForm_id()).orElse(null);
            form.setStatus(true);
            checkClassRoom.getStudents().add(checkUser);
            checkUser.getClasses().add(checkClassRoom);

            studentRegistrationRepository.save(form);
            classRepository.save(checkClassRoom);
            userRepository.save(checkUser);
            return "Them hoc sinh thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }

    @Override
    public void deleteStudentRegis(Long id) {
        studentRegistrationRepository.deleteById(id);
    }
}
