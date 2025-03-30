package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.request.CreateLevelRequest;
import com.example.app_tieng_nhat.request.UpdateLevelRequest;
import com.example.app_tieng_nhat.service.LevelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class LevelServiceImple implements LevelService {
    @Autowired
    private LevelRepository levelRepository;

    @Override
    public List<Levels> getAllLevel() {
        return levelRepository.findAll();
    }

    @Override
    public Map<Long, Long> coutUserByLevel() {
        List<Object[]> results = levelRepository.countUsersByLevel();
        Map<Long, Long> levelUserMap = new HashMap<>();

        for (Object[] row : results) {
            Long levelId = (Long) row[0]; // Lấy ID level
            Long userCount = (Long) row[1];     // Lấy số lượng User
            levelUserMap.put(levelId, userCount);
        }
        return levelUserMap;
    }

    @Override
    public Optional<Levels> getLevelByID(Long id) {
        return levelRepository.findById(id);
    }

    @Override
    public Levels createLevel(CreateLevelRequest level) {

        Levels newLevel = new Levels();
        newLevel.setId(level.id());
        newLevel.setName(level.name());
        return  levelRepository.save(newLevel);
    }

    @Override
    public Levels updateLevel(UpdateLevelRequest updateLevelRequest) {
        Optional<Levels> levelCheck = levelRepository.findById(updateLevelRequest.id());
        if(levelCheck.isPresent()){
            Levels level= levelCheck.get();
            level.setName(updateLevelRequest.name());
            return(Levels) this.levelRepository.save(level);
        }else {return null;}
    }

    @Override
    public void deleteLevel(Long id) {
        this.levelRepository.deleteById(id);
    }
}
