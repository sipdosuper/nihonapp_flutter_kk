package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "lesson")
public class Lessons {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int lessonId;

    @ManyToOne
    @JsonBackReference("level-lesson")
    @JsonIgnoreProperties("lesson")
    @JoinColumn(name = "level_id", nullable = false)
    private Levels level;

    @ManyToOne
    @JsonBackReference("topic-lesson")
    @JoinColumn(name = "topic_id", nullable = false)
    @JsonIgnoreProperties("lesson")
    private Topics topic;

    private String title;
    private String content;

    @OneToMany(mappedBy = "lesson", cascade = CascadeType.ALL)
    @JsonManagedReference("lesson-vocalbulary")
    private Set<Vocabularies> vocabularies;


}
