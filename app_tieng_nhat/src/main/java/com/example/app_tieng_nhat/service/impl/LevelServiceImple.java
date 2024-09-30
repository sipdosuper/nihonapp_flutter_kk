package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.request.UpdateLevelRequest;
import com.example.app_tieng_nhat.service.LevelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
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
    public Optional<Levels> getLevelByID(Long id) {
        return levelRepository.findById(id);
    }

    @Override
    public Levels createLevel(Levels level) {
        if (level == null ) {
            throw new IllegalArgumentException("Level is exist");
        }
        if (level.getId()==null ) {
            throw new IllegalArgumentException("Level_Id null");
        }

        if(levelRepository.findById(level.getId())==null)
            throw new RuntimeException("This lever is found");

        return  (Levels) this.levelRepository.save(level);
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
