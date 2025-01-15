package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.HomeWork;
import com.example.app_tieng_nhat.model.User_HomeWork;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.HomeWorkRepository;
import com.example.app_tieng_nhat.repository.UserHomeWorkRepository;
import com.example.app_tieng_nhat.repository.UserRepository;
import com.example.app_tieng_nhat.request.StudentAnswerRequest;
import com.example.app_tieng_nhat.request.TeacherGrandingHomeWorkRequest;
import com.example.app_tieng_nhat.service.StudentAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StudentAnswerServiceImpl implements StudentAnswerService {
    @Autowired
    private UserHomeWorkRepository userHomeWorkRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private HomeWorkRepository homeWorkRepository;
    @Autowired
    private ClassRepository classRepository;


    @Override
    public List<User_HomeWork> getAllUser_HomeWork() {
        return userHomeWorkRepository.findAll();
    }

    @Override
    public String createAnswer(StudentAnswerRequest studentAnswerRequest) {
        HomeWork homeWork=homeWorkRepository.findById(studentAnswerRequest.homeWork_id()).orElse(null);
        if (homeWork==null) return "Khong ton tai home work";
//        boolean checkStudent= classRepository.existsUserInClass(homeWork.getClassroom().getId(), studentAnswerRequest.student_id());
//        if(!checkStudent)return "Sinh vien nay khong co trong lop";
        Optional<Users> checkStudent=userRepository.findById(studentAnswerRequest.student_id());
        if(checkStudent.isEmpty()) return "Khong ton tai hs nay roi";
        try{
            User_HomeWork newAnswer= new User_HomeWork();
            newAnswer.setStudent_answer(studentAnswerRequest.student_answer());
            newAnswer.setHomeWork(homeWork);
            newAnswer.setStudent(checkStudent.get());
            newAnswer.setTeacher_note(studentAnswerRequest.teacher_note());
            userHomeWorkRepository.save(newAnswer);
            return "Nop bai thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }

    @Override
    public String teacherUpdatePointAndNote(TeacherGrandingHomeWorkRequest gradingHomeWorkRequest) {
        Optional<User_HomeWork> checkAnswer=userHomeWorkRepository.findById(gradingHomeWorkRequest.answer_id());
        if(checkAnswer.isEmpty())return "Khong ton tai answer nay";
        try{
            User_HomeWork user_homeWork=userHomeWorkRepository.findById(gradingHomeWorkRequest.answer_id()).orElse(null);
            user_homeWork.setTeacher_note(gradingHomeWorkRequest.teacher_note());
            user_homeWork.setPoint(gradingHomeWorkRequest.point());
            userHomeWorkRepository.save(user_homeWork);
            return "Cham diem thanh cong";
        }catch (Exception e){
            return "Co loi roi "+e.getMessage();
        }
    }



    @Override
    public void deleteAnswer(Long id) {
        userHomeWorkRepository.deleteById(id);
    }
}
