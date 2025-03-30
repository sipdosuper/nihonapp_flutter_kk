package com.example.app_tieng_nhat.DTO;

import lombok.Data;

@Data
public class UserDTO {
    private String email;
    private String username;
    private String password;
    private String level;
    private Boolean sex;
}
