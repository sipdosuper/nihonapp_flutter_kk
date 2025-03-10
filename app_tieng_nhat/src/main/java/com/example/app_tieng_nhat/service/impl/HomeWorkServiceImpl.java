package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.DTO.StudentRegistrationDTO;
import com.example.app_tieng_nhat.DTO.User_HomeWorkDTO;
import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.HomeWork;
import com.example.app_tieng_nhat.model.StudentRegistration;
import com.example.app_tieng_nhat.model.User_HomeWork;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.HomeWorkRepository;
import com.example.app_tieng_nhat.repository.UserHomeWorkRepository;
import com.example.app_tieng_nhat.request.CreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.MultiCreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.UpdateHomeWorkRequest;
import com.example.app_tieng_nhat.service.HomeWorkSerVice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class HomeWorkServiceImpl implements HomeWorkSerVice {
    @Autowired
    private HomeWorkRepository homeWorkRepository;
    @Autowired
    private ClassRepository classRepository;
    @Autowired
    private UserHomeWorkRepository userHomeWorkRepository;

    private User_HomeWorkDTO convertToDTO(User_HomeWork user_homeWork) {
        User_HomeWorkDTO dto = new User_HomeWorkDTO();
        dto.setId(user_homeWork.getId());
        dto.setStudent_answer(user_homeWork.getStudent_answer());
        dto.setAudio(user_homeWork.getAudio());
        dto.setTeacher_note(user_homeWork.getTeacher_note());
        dto.setPoint(user_homeWork.getPoint());
        dto.setUserId(user_homeWork.getStudent().getId());
        dto.setHomeworkId(user_homeWork.getHomeWork().getId());
        return dto;
    }


    @Override
    public List<HomeWork> getAllHomeWork() {
        return homeWorkRepository.findAll();
    }

    @Override
    public List<HomeWork> getHomeWorkByClassRoomId(Long classRoom_id) {
        Optional<ClassRoom> checkClass = classRepository.findById(classRoom_id);
        if(checkClass.isEmpty())return null;
        return checkClass.get().getHomeWorks();

    }

    @Override
    public String createHomeWork(CreateHomeWorkRequest homeWorkRequest) {
        Optional<ClassRoom> checkClassRoom=classRepository.findById(homeWorkRequest.classRoom_id());
        if ((checkClassRoom.isEmpty()))return "Khong co lop nay dau ban tre";
        try {
            HomeWork newHomeWork= new HomeWork();
            newHomeWork.setName(homeWorkRequest.name());
            newHomeWork.setQuestion(homeWorkRequest.question());
            newHomeWork.setClassroom(checkClassRoom.get());
            homeWorkRepository.save(newHomeWork);
            return "Da them bai tap thanh cong!";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }



    @Override
    public String updateHomeWork(UpdateHomeWorkRequest homeWorkRequest) {
        Optional<HomeWork> checkHomeWork= homeWorkRepository.findById(homeWorkRequest.id());
        Optional<ClassRoom> checkClassRoom= classRepository.findById(homeWorkRequest.classRoom_id());
        if (checkHomeWork.isEmpty())return "Home Work khong ton tai";
        if (checkClassRoom.isEmpty()) return "ClassRoom khong ton tai";
        try {
            HomeWork update= homeWorkRepository.findById(homeWorkRequest.id()).orElse(null);
            update.setName(homeWorkRequest.name());
            update.setQuestion(homeWorkRequest.question());
            update.setClassroom(checkClassRoom.get());
            homeWorkRepository.save(update);
            return "Updated!";
        }catch (Exception e){
            return "Khong on roi: "+e.getMessage();
        }
    }

    @Override
    public void deleteHomeWork(Long id) {
        homeWorkRepository.deleteById(id);
    }

    @Override
    public List<User_HomeWorkDTO> getAllUserHomeWork() {
        return userHomeWorkRepository.findAll()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<User_HomeWorkDTO> getAllUserHomeWorkByHomeWorkId(Long id) {

        return userHomeWorkRepository.findAllByHomeWorkId(id)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
}
