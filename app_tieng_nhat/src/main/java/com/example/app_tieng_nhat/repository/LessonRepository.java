package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Lessons;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lessons, Long> {
    List<Lessons> findByLevelIdAndTopicId(Long levelId, Long topicId);
}
