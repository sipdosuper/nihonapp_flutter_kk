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

import java.time.LocalDate;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "class")
public class ClassRoom {
    @Id
    private Long id;
    @PrePersist
    public void generateId() {
        if (this.id == null) {
            this.id = generateCustomId();
        }
    }

    private Long generateCustomId() {
        return (long) (Math.random() * (9999 - 1000 + 1)) + 1000;
    }

    private String name;

    @ManyToOne
    @JsonManagedReference("level-class")
    @JoinColumn(name = "level_id")
    private Levels level;

    private String description;

    private Long sl_max;

    private String link_giaotrinh;

    private LocalDate start;
    private LocalDate end;
    private Long price;

    @ManyToOne
    @JsonManagedReference("class-time")
    @JoinColumn(name = "time_id",nullable = false)
    private Time time;

    @ManyToOne
    @JsonManagedReference("teacher-class")
    @JoinColumn(name = "teacher_id", nullable = false)
    private Teacher teacher;

    @ManyToMany
    @JoinTable(
            name = "user_class",
            joinColumns = @JoinColumn(name = "class_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private Set<Users> students = new HashSet<>();

    @OneToMany(mappedBy = "classRoom", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference("student-studentRegistration")
    @JsonIgnore
    private Set<StudentRegistration> studentRegistrations;

    @OneToMany(mappedBy = "classroom")
    @JsonManagedReference("home_work-class")
    private List<HomeWork> homeWorks;

}
