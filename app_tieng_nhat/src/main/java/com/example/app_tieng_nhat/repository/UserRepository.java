package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<Users,Long> {
     Users findUserByEmail(String email);

}
