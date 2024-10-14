package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.repository.TopicRepository;
import com.example.app_tieng_nhat.request.CreateTopicRequest;
import com.example.app_tieng_nhat.request.UpdateTopicRequest;
import com.example.app_tieng_nhat.service.TopicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TopicServiceImpl implements TopicService {
    @Autowired
    private TopicRepository topicRepository;
    @Override
    public List<Topics> getAllTopic() {
        return topicRepository.findAll();
    }

    @Override
    public Topics getTopicByID(Long id) {
        return null;
    }

    @Override
    public Topics createTopic(CreateTopicRequest topic) {
        Optional<Topics> check= topicRepository.findById(topic.id());
        if(check.isEmpty()){
            Topics newtopic= new Topics();
            newtopic.setId(topic.id());
            newtopic.setName(topic.name());
            return (Topics) topicRepository.save(newtopic);
        }
        return  null;

    }

    @Override
    public Topics updateTopic(UpdateTopicRequest topicRequest) {
        Optional<Topics> check= topicRepository.findById(topicRequest.id());
        if(check.isPresent()){
            Topics update= topicRepository.findById(topicRequest.id()).orElse(null);
            update.setName(topicRequest.name());
            topicRepository.save(update);
        }
        return null;
    }

    @Override
    public void deleteTopic(Long id) {

    }
}
