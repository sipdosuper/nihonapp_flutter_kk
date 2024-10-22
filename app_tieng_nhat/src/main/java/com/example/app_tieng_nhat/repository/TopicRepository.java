package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Topics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface TopicRepository extends JpaRepository<Topics,Long> {
    List<Topics> getByLevelId(Long level_id);
}
