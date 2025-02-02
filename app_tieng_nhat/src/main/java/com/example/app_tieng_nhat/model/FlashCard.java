package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
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
@Table(name = "flashCard")
public class FlashCard {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String font;
    private String font_img;

    private String back;
    private String back_img;

    @ManyToOne
    @JsonBackReference("cardList-card")
    @JoinColumn(name = "flashCardList_id", nullable = false)
    private FlashCardList flashCardList;

}
