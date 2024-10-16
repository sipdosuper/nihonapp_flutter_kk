package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Onion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OnionRepository extends JpaRepository<Onion,Long> {
    List<Onion> findByTopicId( Long topicId);
}
