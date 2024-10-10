package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Sentence;
import com.example.app_tieng_nhat.request.GetSentenceByLessonOnion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SentenceRepository extends JpaRepository<Sentence,Long> {
}
