package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.TeacherRegistrationForm;
import com.example.app_tieng_nhat.model.Time;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.repository.TeacherRegistrationFormRepository;
import com.example.app_tieng_nhat.repository.TimeRepository;
import com.example.app_tieng_nhat.request.CreateTeacherRegistrationForm;
import com.example.app_tieng_nhat.service.TeacherRegistrationFormService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TeacherRegistrationFormServiceImpl implements TeacherRegistrationFormService {
    @Autowired
    private TeacherRegistrationFormRepository teacherRegistrationFormRepository;
    @Autowired
    private LevelRepository levelRepository;
    @Autowired
    private TimeRepository timeRepository;


    @Override
    public List<TeacherRegistrationForm> getAllTeacherRegistrationForm() {
        return teacherRegistrationFormRepository.findAll();
    }

    @Override
    public String createTeacherRegistrationForm(CreateTeacherRegistrationForm teacherRegistrationForm) {
        Optional<Levels> checkLevel=levelRepository.findById(teacherRegistrationForm.level_id());
        if (checkLevel.isEmpty())return "Khong co level nay";
        Optional<Time> checkTime=timeRepository.findById(teacherRegistrationForm.workingTime_id());
        if (checkTime.isEmpty())return "Chung toi khong lam viec trong thoi gian nay";

        try {
            TeacherRegistrationForm newForm= new TeacherRegistrationForm();
            newForm.setTeacherName(teacherRegistrationForm.name());
            newForm.setEmail(teacherRegistrationForm.email());
            newForm.setPhone(teacherRegistrationForm.phone());
            newForm.setBirthDay(teacherRegistrationForm.birthDay());
            newForm.setProof(teacherRegistrationForm.proof());
            newForm.setIntroduce(teacherRegistrationForm.introduce());
            newForm.setRegisDay(teacherRegistrationForm.regisDay());
            newForm.setLevel(checkLevel.get());
            newForm.setWorkingTime(checkTime.get());
            teacherRegistrationFormRepository.save(newForm);
            return "Da tao don thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }



    @Override
    public void delete(Long id) {
        teacherRegistrationFormRepository.deleteById(id);
    }
}
