package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.repository.TopicRepository;
import com.example.app_tieng_nhat.request.CreateTopicRequest;
import com.example.app_tieng_nhat.service.TopicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
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
        Topics newtopic= new Topics();
        newtopic.setId(topic.id());
        newtopic.setName(topic.name());
        return topicRepository.save(newtopic);
    }

    @Override
    public Topics updateTopic(Long id, Topics topic) {
        return null;
    }

    @Override
    public void deleteTopic(Long id) {

    }
}
