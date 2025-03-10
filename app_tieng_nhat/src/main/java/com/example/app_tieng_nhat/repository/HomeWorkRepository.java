package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.HomeWork;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HomeWorkRepository extends JpaRepository<HomeWork, Long> {
}
