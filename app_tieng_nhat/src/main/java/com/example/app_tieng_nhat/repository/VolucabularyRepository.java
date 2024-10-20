package com.example.app_tieng_nhat.repository;

import com.example.app_tieng_nhat.model.Vocabularies;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VolucabularyRepository extends JpaRepository<Vocabularies,Long> {
    Vocabularies findByWord(String word);
}
