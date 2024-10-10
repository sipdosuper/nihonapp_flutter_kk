package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.request.CreateTopicRequest;
import com.example.app_tieng_nhat.service.TopicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/topic")
public class TopicController {
    @Autowired
    private TopicService topicService;

    @GetMapping
    public List<Topics> getAllTopic(){
        return topicService.getAllTopic();
    }

    @GetMapping("/{id}")
    public Topics getTopicByID(Long id){
        return  topicService.getTopicByID(id);
    }

    @PostMapping
    public Topics createTopic(CreateTopicRequest topics){
        return topicService.createTopic(topics);
    }

    @PutMapping("/update/{id}")
    public Topics updateTopic(Long id, Topics topics){
        return topicService.updateTopic(id,topics);
    }

    @DeleteMapping("/delete/{id}")
    public void deleteTopic(Long id){
        topicService.deleteTopic(id);
    }
}
