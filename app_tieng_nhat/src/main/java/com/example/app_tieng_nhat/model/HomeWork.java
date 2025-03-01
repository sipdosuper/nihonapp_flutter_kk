package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
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
@Table(name = "home_work")
public class HomeWork {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    private String question;

    @ManyToOne
    @JsonBackReference("home_work-class")
    @JoinColumn(name = "class_id")
    private ClassRoom classroom;

    @OneToMany(mappedBy = "homeWork", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<User_HomeWork> user_HomeWorks=new HashSet<>();
}
