package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Time;
import com.example.app_tieng_nhat.repository.TimeRepository;
import com.example.app_tieng_nhat.request.CreateTimeRequest;
import com.example.app_tieng_nhat.request.MultiCreateTimeRequest;
import com.example.app_tieng_nhat.service.TimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class TimeServiceImpl implements TimeService {
    @Autowired
    private TimeRepository timeRepository;
    @Override
    public List<Time> getAllTime() {
        return timeRepository.findAll();
    }

    @Override
    public String createTime(CreateTimeRequest timeRequest) {
        Optional<Time> checkTime=timeRepository.findById(timeRequest.id());
        if(checkTime.isPresent())return "id da ton tai";
        Time newTime=new Time();
        newTime.setId(timeRequest.id());
        newTime.setTime(timeRequest.time());
        timeRepository.save(newTime);
        return "Tao time moi thanh cong";
    }

    @Override
    public void deleteTime(Long id) {
        timeRepository.deleteById(id);
    }



}
