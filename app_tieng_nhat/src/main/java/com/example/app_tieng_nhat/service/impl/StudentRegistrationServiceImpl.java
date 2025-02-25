package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.DTO.StudentRegistrationDTO;
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
import java.util.stream.Collectors;

@Service
public class StudentRegistrationServiceImpl implements StudentRegistrationService {

    @Autowired
    private StudentRegistrationRepository studentRegistrationRepository;
    @Autowired
    private ClassRepository classRepository;
    @Autowired
    private UserRepository userRepository;

    private StudentRegistrationDTO convertToDTO(StudentRegistration studentRegistration) {
        StudentRegistrationDTO dto = new StudentRegistrationDTO();
        dto.setId(studentRegistration.getId());
        dto.setNameAndSdt(studentRegistration.getNameAndSdt());
        dto.setEmail(studentRegistration.getEmail());
        dto.setBankCheck(studentRegistration.getBankCheck());
        dto.setRegisDay(studentRegistration.getRegisDay());
        dto.setBill(studentRegistration.getBill());
        dto.setStatus(studentRegistration.getStatus());
        dto.setStudentId(studentRegistration.getStudent().getId());
        dto.setClassRoomId(studentRegistration.getClassRoom().getId());
        return dto;
    }

    @Override
    public List<StudentRegistrationDTO> getAllStudentRegistration() {
        return studentRegistrationRepository.findAll()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<StudentRegistrationDTO> getAllByBankCheck(Long check) {
        boolean bankcheck= false;
        if (check==1){
            bankcheck =true;
        }
        return studentRegistrationRepository.findByBankCheck(bankcheck)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
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
            newRegis.setEmail(studentRegistrationRequest.email());
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
            form.setBankCheck(true);
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
