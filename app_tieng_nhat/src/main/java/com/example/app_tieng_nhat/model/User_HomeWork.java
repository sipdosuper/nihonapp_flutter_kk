package com.example.app_tieng_nhat.model;


import com.example.app_tieng_nhat.DTO.User_HomeWorkDTO;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;


@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "user_home_work")
public class User_HomeWork{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String student_answer;
    private String audio;

    private String teacher_note;
    private Float point;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonBackReference("user-user_home_work")
    private Users student;

    @ManyToOne
    @JoinColumn(name = "home_work_id")
    @JsonBackReference("home_work-user_home_work")
    private HomeWork homeWork;

}
