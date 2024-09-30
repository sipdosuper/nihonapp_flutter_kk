package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.request.UpdateLevelRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface LevelService {
    List<Levels> getAllLevel();
    Optional<Levels> getLevelByID(Long id);
    Levels createLevel(Levels level);
    Levels updateLevel(UpdateLevelRequest updateLevelRequest);
    void deleteLevel(Long id);
}
