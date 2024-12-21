package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
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
@Table(name = "topic")
public class Topics {
    @Id
    private Long id;

    private String name;

    @ManyToOne
    @JsonBackReference("level-topic")
    @JsonIgnoreProperties("topic")
    @JoinColumn(name = "level_id", nullable = false)
    private Levels level;

    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    @JsonManagedReference("topic-lesson")
    private Set<Lessons> lessons;

    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    @JsonManagedReference("topic-onion")
    private Set<Onion> onions;
}
