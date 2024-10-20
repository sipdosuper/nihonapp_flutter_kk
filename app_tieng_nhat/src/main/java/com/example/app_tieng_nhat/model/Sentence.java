package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

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

//    @OneToMany(mappedBy = "sentence", cascade = CascadeType.ALL)
//    @JsonManagedReference("sentence-vocabularies")
    @ElementCollection
    private Set<Vocabularies> vocabularies;

}
