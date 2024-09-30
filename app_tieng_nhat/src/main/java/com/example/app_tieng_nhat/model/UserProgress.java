package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

@Entity
@Table(name = "userProgress")
public class UserProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int progressId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    @JsonBackReference("user-userProgress")
    @JsonIgnoreProperties("userProgress")
    private Users user;

    @ManyToOne
    @JoinColumn(name = "lesson_id", nullable = false)
    @JsonBackReference
    @JsonIgnoreProperties("userProgress")
    private Lessons lesson;

    private String status;
}
