package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.ClassRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClassRepository extends JpaRepository<ClassRoom, Long> {
    @Query("SELECT c FROM ClassRoom c JOIN c.students s WHERE s.id = :userId")
    List<ClassRoom> findByUserId(@Param("userId") Long userId);

    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN TRUE ELSE FALSE END " +
            "FROM ClassRoom c JOIN c.students u " +
            "WHERE c.id = :classId AND u.id = :userId")
    boolean existsUserInClass(@Param("classId") Long classId, @Param("userId") Long userId);

}
