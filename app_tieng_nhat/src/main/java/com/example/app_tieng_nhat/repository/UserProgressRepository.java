package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserProgressRepository extends JpaRepository<UserProgress,Long> {
}
