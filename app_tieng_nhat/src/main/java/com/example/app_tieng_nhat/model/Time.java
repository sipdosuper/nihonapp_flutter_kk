package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
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
@Table(name = "time")
public class Time {
    @Id
    private Long id;

    private String time;

    @OneToMany(mappedBy = "time", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonBackReference("class-time")
    @JsonIgnore
    private Set<ClassRoom> classSet=new HashSet<>();
    @OneToMany(mappedBy = "workingTime", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonBackReference("time-regisForm")
    @JsonIgnore
    private Set<TeacherRegistrationForm> teacherRegistrationForms=new HashSet<>();
}
