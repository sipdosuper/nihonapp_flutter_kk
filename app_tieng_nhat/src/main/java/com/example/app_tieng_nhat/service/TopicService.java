package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.request.CreateTopicRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface TopicService {
    List<Topics> getAllTopic();
    Topics getTopicByID(Long id);
    Topics createTopic(CreateTopicRequest topic);
    Topics updateTopic(Long id, Topics topic);
    void deleteTopic(Long id);
}
