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
    private Long id;

    private String word;
    private String meaning;
    private String example;
    private String transcription;

    @ManyToOne
    @JoinColumn(name = "sentence_id", nullable = false)
    @JsonBackReference("sentence-vocabularies")
    @JsonIgnoreProperties("vocabularies")
    private Sentence sentence;
}
