package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.Topics;
import com.example.app_tieng_nhat.repository.LessonRepository;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.repository.TopicRepository;
import com.example.app_tieng_nhat.service.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class LessonServiceImpl implements LessonService {
    @Autowired
    private LessonRepository lessonRepository;
    private LevelRepository levelRepository;
    private TopicRepository topicRepository;


    @Override
    public List<Lessons> getAllLesson() {
        return lessonRepository.findAll();
    }

    @Override
    public Lessons getLessonByID(Long id) {
        return lessonRepository.findById(id).orElse(null);
    }

    @Override
    public Lessons createLesson(Lessons lesson) {
        try{
            if(lesson.getLevel()!=null && lesson.getLevel().getId()!= null){
                if(lesson.getTopic()!= null&& lesson.getTopic().getId() != null){
                    Levels levels=(Levels)this.levelRepository.findById(lesson.getLevel().getId()).orElseThrow(()-> {
                        return new RuntimeException("Level not found with ID");
                    });
                    Topics topics =(Topics) this.topicRepository.findById(lesson.getTopic().getId()).orElseThrow(()->{
                        return new RuntimeException("Topic not found with ID");
                    });

                    lesson.setLevel(levels);
                    lesson.setTopic(topics);
                    return this.lessonRepository.save(lesson);
                }else {
                    throw new IllegalArgumentException("Topic cannot be null or have null ID");
                }
            }else {
                throw new IllegalArgumentException("Level cannot be null or have null ID");
            }
        }catch (Exception e){
            throw new IllegalArgumentException(e.getMessage());
        }
    }

    @Override
    public Lessons updateLesson(Long id, Lessons lessonDetal) {
        return null;
    }

    @Override
    public void deleteLesson(Long id) {

    }
}
