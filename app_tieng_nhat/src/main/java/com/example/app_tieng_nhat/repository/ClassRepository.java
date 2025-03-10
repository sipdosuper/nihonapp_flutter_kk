package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.HomeWork;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClassRepository extends JpaRepository<ClassRoom, Long> {

}
