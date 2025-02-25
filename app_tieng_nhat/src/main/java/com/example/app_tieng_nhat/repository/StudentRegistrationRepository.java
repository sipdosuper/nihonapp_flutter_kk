package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.StudentRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentRegistrationRepository extends JpaRepository<StudentRegistration, Long> {
    List<StudentRegistration> findByBankCheck(Boolean bankCheck);
}
