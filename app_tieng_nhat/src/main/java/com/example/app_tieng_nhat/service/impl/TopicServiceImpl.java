package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.service.TopicService;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TopicServiceImpl implements TopicService {
    @Override
    public List<Topics> getAllTopic() {
        return List.of();
    }

    @Override
    public Topics getTopicByID(Long id) {
        return null;
    }

    @Override
    public Topics createTopic(Topics topic) {
        return null;
    }

    @Override
    public Topics updateTopic(Long id, Topics topic) {
        return null;
    }

    @Override
    public void deleteTopic(Long id) {

    }
}
