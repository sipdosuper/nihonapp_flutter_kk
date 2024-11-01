package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.repository.LessonRepository;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.repository.TopicRepository;
import com.example.app_tieng_nhat.request.CreateLessonRequest;
import com.example.app_tieng_nhat.request.GetLessonByTopicLevelRequest;
import com.example.app_tieng_nhat.request.UpdateLessonRequest;
import com.example.app_tieng_nhat.service.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LessonServiceImpl implements LessonService {
    @Autowired
    private LessonRepository lessonRepository;
    @Autowired
    private LevelRepository levelRepository;
    @Autowired
    private TopicRepository topicRepository;


    @Override
    public List<Lessons> getAllLesson() {
        return lessonRepository.findAll();
    }

    @Override
    public List<Lessons> getAllLessonByTopic(GetLessonByTopicLevelRequest lesson) {
        return lessonRepository.findByTopicId(lesson.topic_id());
    }


    @Override
    public Lessons getLessonByID(Long id) {
        return lessonRepository.findById(id).orElse(null);
    }

    @Override
    public Lessons createLesson(CreateLessonRequest lesson) {
        Optional<Topics> topics= topicRepository.findById(lesson.topic_id());

        if( topics.isPresent()){
            Lessons newLesson= new Lessons();
            newLesson.setId(lesson.id());
            newLesson.setTitle(lesson.title());
            newLesson.setTopic(topics.get());
            return lessonRepository.save(newLesson);
        }else {
            return null;
        }
    }


    @Override
    public Lessons updateLesson(UpdateLessonRequest lessonRequest) {
        Optional<Lessons> checkLesson= lessonRepository.findById(lessonRequest.id());
        Optional<Topics> topics = topicRepository.findById(lessonRequest.topic_id());

        if(checkLesson.isPresent()){
            Lessons updateLesson= lessonRepository.findById(lessonRequest.id()).orElse(null);
            updateLesson.setTitle(lessonRequest.title());
            updateLesson.setTopic(topics.get());
            return lessonRepository.save(updateLesson);
        }
        return null;
    }

    @Override
    public void deleteLesson(Long id) {
        lessonRepository.deleteById(id);
    }
}
