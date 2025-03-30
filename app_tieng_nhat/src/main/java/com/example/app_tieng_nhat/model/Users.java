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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Table(name = "user")
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    private String username;

    private String email;

    private String password;
    @Column(name = "signupDate")
    private LocalDate signupDate;
    @JsonIgnore
    private Boolean sex;

    @ManyToOne
    @JsonBackReference("role-user")
    @JoinColumn(name = "role_id", nullable = false)
    private Roles role;

    @ManyToOne
    @JsonManagedReference("level-user")
    @JoinColumn(name = "level_id", nullable = false)
    private Levels level;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<UserProgress> userProgresses = new HashSet<>();

    @ManyToMany(mappedBy = "students")
    @JsonIgnore
    private Set<ClassRoom> classes=new HashSet<>();

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference("student-studentRegistration")
    @JsonIgnore
    private Set<StudentRegistration> studentRegistrations=new HashSet<>();


    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<User_HomeWork> user_homeWorks=new HashSet<>();

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference("student-cardList")
    private List<FlashCardList> flashCardLists;

}
