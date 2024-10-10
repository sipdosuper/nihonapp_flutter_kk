package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Onion;
import com.example.app_tieng_nhat.request.CreateLessonRequest;
import com.example.app_tieng_nhat.request.CreateOnionRequest;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface OnionService {
    List<Onion> getAllOnion();
    List<Onion> getAllOnionByLevelAndTopic(Long level,Long topic);
    Optional<Onion> getOnionByID(Long id);
    Onion createOnion(CreateOnionRequest onionRequest);
    Onion updateOnion(CreateOnionRequest onionRequest);
    void deleteOnion(Long id);
}
