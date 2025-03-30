package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.request.CreateLevelRequest;
import com.example.app_tieng_nhat.request.UpdateLevelRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public interface LevelService {
    List<Levels> getAllLevel();
    Map<Long,Long> coutUserByLevel();
    Optional<Levels> getLevelByID(Long id);
    Levels createLevel(CreateLevelRequest createLevelRequest);
    Levels updateLevel(UpdateLevelRequest updateLevelRequest);
    void deleteLevel(Long id);
}
