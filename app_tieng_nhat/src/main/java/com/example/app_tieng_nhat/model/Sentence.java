package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "sentence")
public class Sentence {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String word;
    private String meaning;
    private String transcription;
    private String answer;

    @ManyToOne
    @JoinColumn(name = "onion_id", nullable = false)
    @JsonBackReference("onion-sentence")
    @JsonIgnoreProperties("sentence")
    private Onion onion;

    @ManyToOne
    @JoinColumn(name = "lesson_id", nullable = false)
    @JsonBackReference("lesson-sentence")
    @JsonIgnoreProperties("sentence")
    private Lessons lesson;

    @ManyToMany
    @JoinTable(
            name = "sentence_vocabularies",
            joinColumns = @JoinColumn(name = "sentence_id"),
            inverseJoinColumns = @JoinColumn(name = "vocabulary_id")
    )
    private Set<Vocabularies> litsvocabulary = new HashSet<>();

}
