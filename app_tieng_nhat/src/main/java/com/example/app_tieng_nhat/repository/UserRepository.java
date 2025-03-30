package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<Users,Long> {
     Users findUserByEmail(String email);

     @Query(value = """
        SELECT MONTH(u.signup_date) AS month, COUNT(*) AS count
        FROM user u
        WHERE YEAR(u.signup_date) = :year
        GROUP BY MONTH(u.signup_date)
        ORDER BY MONTH(u.signup_date)
        """, nativeQuery = true)
     List<Object[]> getUserSignupCountByMonth(@Param("year") int year);
}
