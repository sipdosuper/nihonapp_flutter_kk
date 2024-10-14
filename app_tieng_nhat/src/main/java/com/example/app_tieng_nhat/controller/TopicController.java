package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.request.CreateTopicRequest;
import com.example.app_tieng_nhat.request.UpdateTopicRequest;
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
    public Topics getTopicByID(@PathVariable Long id){
        return  topicService.getTopicByID(id);
    }

    @PostMapping
    public Topics createTopic(@RequestBody CreateTopicRequest topics){
        return topicService.createTopic(topics);
    }

    @PutMapping
    public Topics updateTopic(@RequestBody UpdateTopicRequest topicRequest){
        return topicService.updateTopic(topicRequest);
    }

    @DeleteMapping("/{id}")
    public void deleteTopic(@PathVariable Long id){
        topicService.deleteTopic(id);
    }
}
