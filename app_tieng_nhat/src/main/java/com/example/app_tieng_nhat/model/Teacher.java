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

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Entity
@Table(name = "teacher")
@PrimaryKeyJoinColumn(name = "id")
public class Teacher extends Users{

    private Long salary;

    @ManyToOne
    @JoinColumn(name = "type_id", nullable = false)
    @JsonBackReference("type-teacher")
    private TypeMode type;

    @OneToMany(mappedBy = "teacher", cascade = CascadeType.ALL)
    @JsonManagedReference("teacher-class")
    @JsonIgnore
    private Set<ClassRoom> classes= new HashSet<>();

}
