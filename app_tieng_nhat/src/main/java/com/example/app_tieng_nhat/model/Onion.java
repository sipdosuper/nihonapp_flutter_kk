package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
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
@Table(name = "onion")
public class Onion {
    @Id
    private Long id;
    private String title;
    private String content;


    @ManyToOne
    @JsonBackReference("topic-onion")
    @JoinColumn(name = "topic_id", nullable = false)
    @JsonIgnoreProperties("onion")
    private Topics topic;


    @OneToMany(mappedBy = "onion", cascade = CascadeType.ALL)
    @JsonManagedReference("onion-sentence")
    private Set<Sentence> sentences;
}
