package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Vocabularies;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VolucabularyRepository extends JpaRepository<Vocabularies,Long> {
    Vocabularies findByWord(String word);
    @Query("SELECT v FROM Vocabularies v WHERE v.word IN :words")
    List<Vocabularies> findByWordIn(@Param("words") List<String> words);
}
