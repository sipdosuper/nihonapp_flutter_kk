package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.UserProgress;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.repository.LessonRepository;
import com.example.app_tieng_nhat.repository.UserProgressRepository;
import com.example.app_tieng_nhat.repository.UserRepository;
import com.example.app_tieng_nhat.request.CreateUserProgressRequest;
import com.example.app_tieng_nhat.service.UserProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
@Service
public class UserProgressServiceImpl implements UserProgressService {

    @Autowired
    private UserProgressRepository userProgressRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private LessonRepository lessonRepository;

    @Override
    public List<UserProgress> getAllUserProgress() {
        return userProgressRepository.findAll();
    }

    @Override
    public UserProgress getUserProgressByUser(String email) {
        return userProgressRepository.findByEmail(email);
    }

    @Override
    public UserProgress getUserProgressByLesson(Long lessonId) {
        return userProgressRepository.findByLessonId(lessonId);
    }

    @Override
    public UserProgress createUserProgress(CreateUserProgressRequest userProgressRequest) {
        UserProgress checkUserProgress=userProgressRepository.findByEmail(userProgressRequest.email());
        if(checkUserProgress==null){
            Optional<Lessons> checkLesson= lessonRepository.findById(userProgressRequest.lesson_id());
            Users checkUser =userRepository.findUserByEmail(userProgressRequest.email());
            if (checkUser!=null&&checkLesson!=null){
                UserProgress userProgress= new UserProgress();
                userProgress.setUser(checkUser);
                userProgress.setLesson(checkLesson.get());
                return userProgressRepository.save(userProgress);
            }
        }
        else {
            Optional<Lessons> checkLesson= lessonRepository.findById(userProgressRequest.lesson_id());
            Users checkUser =userRepository.findUserByEmail(userProgressRequest.email());
            if (checkUser!=null&&checkLesson!=null){
                UserProgress newUserProgress= userProgressRepository.findByEmail(userProgressRequest.email());
                newUserProgress.setLesson(checkLesson.get());
                return userProgressRepository.save(newUserProgress);
            }

        }
        return null;
    }

    @Override
    public void deleteUserProgressById(Long id) {
        userProgressRepository.deleteById(id);
    }
}
