package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.HomeWork;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.HomeWorkRepository;
import com.example.app_tieng_nhat.request.CreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.MultiCreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.UpdateHomeWorkRequest;
import com.example.app_tieng_nhat.service.HomeWorkSerVice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HomeWorkServiceImpl implements HomeWorkSerVice {
    @Autowired
    private HomeWorkRepository homeWorkRepository;
    @Autowired
    private ClassRepository classRepository;
    @Override
    public List<HomeWork> getAllHomeWork() {
        return homeWorkRepository.findAll();
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
}
