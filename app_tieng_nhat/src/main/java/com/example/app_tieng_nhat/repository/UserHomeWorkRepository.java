package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.User_HomeWork;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserHomeWorkRepository extends JpaRepository<User_HomeWork, Long> {

}
