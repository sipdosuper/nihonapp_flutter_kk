package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.Onion;
import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.repository.OnionRepository;
import com.example.app_tieng_nhat.repository.TopicRepository;
import com.example.app_tieng_nhat.request.CreateLessonRequest;
import com.example.app_tieng_nhat.request.CreateOnionRequest;
import com.example.app_tieng_nhat.request.CreateUpdateSentenceRequest;
import com.example.app_tieng_nhat.service.OnionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OnionServiceImpl implements OnionService {
    @Autowired
    private OnionRepository onionRepository;
    @Autowired
    private LevelRepository levelRepository;
    @Autowired
    private TopicRepository topicRepository;

    @Override
    public List<Onion> getAllOnion() {
        return onionRepository.findAll();
    }

    @Override
    public List<Onion> getAllOnionByLevelAndTopic(Long level, Long topic) {
        return onionRepository.findByLevelIdAndTopicId(level, topic);
    }

    @Override
    public Optional<Onion> getOnionByID(Long id) {
        return onionRepository.findById(id);
    }

    @Override
    public Onion createOnion(CreateOnionRequest onionRequest) {
        Optional<Levels> levels= levelRepository.findById(onionRequest.level_id());
        Optional<Topics> topics= topicRepository.findById(onionRequest.topic_id());

        if(levels.isPresent()&&topics.isPresent()){
            Onion newOnion= new Onion();
            newOnion.setId(onionRequest.id());
            newOnion.setTitle(onionRequest.title());
            newOnion.setContent(onionRequest.content());
            newOnion.setTopic(topics.get());
            newOnion.setLevel(levels.get());
            return onionRepository.save(newOnion);
        }
        return null;
    }

    @Override
    public Onion updateOnion(CreateOnionRequest onionRequest) {
        Optional<Onion> checkOnion= onionRepository.findById(onionRequest.id());
        Optional<Levels> levels= levelRepository.findById(onionRequest.level_id());
        Optional<Topics> topics= topicRepository.findById(onionRequest.topic_id());
        if(checkOnion.isPresent()&& levels.isPresent()&& topics.isPresent()){
            Onion updateOnion= new Onion();
            updateOnion.setId(onionRequest.id());
            updateOnion.setTitle(onionRequest.title());
            updateOnion.setContent(onionRequest.content());
            updateOnion.setTopic(topics.get());
            updateOnion.setLevel(levels.get());
            return onionRepository.save(updateOnion);
        }
        return null;
    }


    @Override
    public void deleteOnion(Long id) {
        onionRepository.deleteById(id);
    }
}
