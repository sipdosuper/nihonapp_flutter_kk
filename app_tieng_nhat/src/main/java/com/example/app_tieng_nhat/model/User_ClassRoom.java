package com.example.app_tieng_nhat.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Embeddable
@AllArgsConstructor // Tạo constructor với tất cả các tham số
@NoArgsConstructor
public class User_ClassRoom implements Serializable {
    @Column(name = "user_id")
    private Long user_id;

    @Column(name = "classRoom_id")
    private Long classRoom_id;
}
