package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "flashCardList")
public class FlashCardList {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    @ManyToOne
    @JsonBackReference("student-cardList")
    @JoinColumn(name = "student_id", nullable = false)
    private Users student;

    @OneToMany(mappedBy = "flashCardList", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference("cardList-card")
    private List<FlashCard> flashCards;
}
