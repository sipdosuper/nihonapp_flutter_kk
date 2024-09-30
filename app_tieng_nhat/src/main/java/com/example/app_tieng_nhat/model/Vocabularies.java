package com.example.app_tieng_nhat.model;


import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "vocabularies")
public class Vocabularies {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int vocabId;

    @ManyToOne
    @JoinColumn(name = "lesson_id", nullable = false)
    @JsonBackReference("lesson-vocalbulary")
    @JsonIgnoreProperties("vocabularies")
    private Lessons lesson;

    private String word;
    @JsonIgnoreProperties("vocabularies")
    private String meaning;
    @JsonIgnoreProperties("vocabularies")
    private String example;

}
