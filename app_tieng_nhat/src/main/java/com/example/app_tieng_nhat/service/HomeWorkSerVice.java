package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.DTO.User_HomeWorkDTO;
import com.example.app_tieng_nhat.model.HomeWork;
import com.example.app_tieng_nhat.request.CreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.MultiCreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.UpdateHomeWorkRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface HomeWorkSerVice {
    List<HomeWork> getAllHomeWork();
    List<HomeWork> getHomeWorkByClassRoomId(Long classRoom_id);
    String createHomeWork(CreateHomeWorkRequest homeWorkRequest);
    String updateHomeWork(UpdateHomeWorkRequest homeWorkRequest);
    void deleteHomeWork(Long id);
    List<User_HomeWorkDTO> getAllUserHomeWork();
    List<User_HomeWorkDTO> getAllUserHomeWorkByHomeWorkId(Long id);
}
