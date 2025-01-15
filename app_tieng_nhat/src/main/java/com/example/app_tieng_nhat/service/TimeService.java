package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Time;
import com.example.app_tieng_nhat.request.CreateTimeRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface TimeService {
    List<Time> getAllTime();
    String createTime(CreateTimeRequest timeRequest);
    void deleteTime(Long id);
}
