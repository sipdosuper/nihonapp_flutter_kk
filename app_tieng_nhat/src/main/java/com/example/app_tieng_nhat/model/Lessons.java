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
@Table(name = "lesson")
public class Lessons {
    @Id
    private Long id;

    private String title;


    @ManyToOne
    @JsonBackReference("topic-lesson")
    @JoinColumn(name = "topic_id", nullable = false)
    @JsonIgnoreProperties("lesson")
    private Topics topic;


    @OneToMany(mappedBy = "lesson", cascade = CascadeType.ALL)
    @JsonManagedReference("lesson-sentence")
    private Set<Sentence> sentences;


}
