package com.example.app_tieng_nhat.DTO;

import lombok.Data;

import java.time.LocalDate;

@Data
public class ClassRoomDTO {
    private Long id;
    private String name;
    private String level;
    private String description;
    private Long sl_max;
    private String link_giaotrinh;
    private LocalDate start;
    private LocalDate end;
    private Long price;
    private String time;
    private String teacherName;
}
