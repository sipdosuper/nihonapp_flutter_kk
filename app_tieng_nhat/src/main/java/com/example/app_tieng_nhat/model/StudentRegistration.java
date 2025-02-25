package com.example.app_tieng_nhat.model;

import com.example.app_tieng_nhat.DTO.StudentRegistrationDTO;
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
    private String email;

    private Boolean bankCheck;
    private LocalDate regisDay;
    private String bill;
    private Boolean status;

    @ManyToOne
    @JsonBackReference("student-studentRegistration")
    @JoinColumn(name = "student_id", nullable = false)
    private Users student;

    @ManyToOne
    @JsonManagedReference("classroom-studentRegistration")
    @JoinColumn(name = "classroom_id", nullable = false)
    private ClassRoom classRoom;

    public StudentRegistrationDTO toDTO() {
        StudentRegistrationDTO dto = new StudentRegistrationDTO();
        dto.setId(this.id);
        dto.setNameAndSdt(this.nameAndSdt);
        dto.setEmail(this.email);
        dto.setBankCheck(this.bankCheck);
        dto.setRegisDay(this.regisDay);
        dto.setBill(this.bill);
        dto.setStatus(this.status);
        dto.setStudentId(this.student != null ? this.student.getId() : null);
        dto.setClassRoomId(this.classRoom != null ? this.classRoom.getId() : null);
        return dto;
    }

}
