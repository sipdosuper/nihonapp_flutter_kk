package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.request.CreateTopicRequest;
import com.example.app_tieng_nhat.request.UpdateTopicRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public interface TopicService {
    List<Topics> getAllTopic();
    Topics getTopicByID(Long id);
    Topics createTopic(CreateTopicRequest topic);
    Topics updateTopic(UpdateTopicRequest topicRequest);
    List<Topics> getByLevelId(Long id);
    void deleteTopic(Long id);
}
