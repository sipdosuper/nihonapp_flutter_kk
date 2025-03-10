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

    public User_HomeWorkDTO toDTO(){
        User_HomeWorkDTO dto= new User_HomeWorkDTO();
        dto.setId(this.id);
        dto.setStudent_answer(this.student_answer);
        dto.setAudio(this.audio);
        dto.setTeacher_note(this.teacher_note);
        dto.setPoint(this.point);
        dto.setUserId(this.student != null? this.student.getId() : null);
        dto.setHomeworkId(this.homeWork!=null? this.homeWork.getId(): null);
        return dto;
    }

}
