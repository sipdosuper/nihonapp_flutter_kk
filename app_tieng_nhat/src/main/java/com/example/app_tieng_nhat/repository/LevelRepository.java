package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Levels;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LevelRepository extends JpaRepository<Levels,Long> {
    @Query("SELECT u.level.id, COUNT(u) FROM Users u GROUP BY u.level.id ORDER BY u.level.id")
    List<Object[]> countUsersByLevel();
}
