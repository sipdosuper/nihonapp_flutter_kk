package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {
    @Query("SELECT up FROM UserProgress up WHERE up.user.email = :email")
    UserProgress findByEmail(@Param("email") String email);
    UserProgress findByLessonId(Long lessonId);
    @Query("SELECT up FROM UserProgress up WHERE up.user.email = :email AND up.lesson.id =:lesson")
    Optional<UserProgress> findByEmailAndLesson(@Param("email") String email, @Param("lesson") Long lessonId);
}
