package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.HomeWork;
import com.example.app_tieng_nhat.request.CreateHomeWorkRequest;
import com.example.app_tieng_nhat.request.UpdateHomeWorkRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface HomeWorkSerVice {
    List<HomeWork> getAllHomeWork();
    String createHomeWork(CreateHomeWorkRequest homeWorkRequest);
    String updateHomeWork(UpdateHomeWorkRequest homeWorkRequest);
    void deleteHomeWork(Long id);

}
