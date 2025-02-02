package com.example.app_tieng_nhat.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.Date;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "studentRegistration")
public class StudentRegistration {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String nameAndSdt;

    private Boolean bankCheck;
    private LocalDate regisDay;
    private String bill;
    private Boolean status;

    @ManyToOne
    @JsonBackReference("student-studentRegistration")
    @JoinColumn(name = "student_id", nullable = false)
    private Users student;

    @ManyToOne
    @JsonBackReference("classroom-studentRegistration")
    @JoinColumn(name = "classroom_id", nullable = false)
    private ClassRoom classRoom;

}
