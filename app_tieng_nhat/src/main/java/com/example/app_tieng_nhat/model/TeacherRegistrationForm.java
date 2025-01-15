package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "teacherRegistrationForm")
public class TeacherRegistrationForm {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String teacherName;
    private Date birthDay;
    private String proof;
    private String introduce;
    private Date registDay;
    @ManyToOne
    @JsonBackReference("level-registForm")
    @JoinColumn(name = "level_id", nullable = false)
    private Levels level;
    @ManyToOne
    @JsonBackReference("time-registForm")
    @JoinColumn(name = "time_id", nullable = false)
    private Time workingTime;
}
