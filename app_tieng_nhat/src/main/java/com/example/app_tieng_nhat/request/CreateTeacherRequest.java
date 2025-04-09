package com.example.app_tieng_nhat.request;

public record CreateTeacherRequest(
                                    String email,
                                    String username,
                                    Boolean sex,
                                    String password,
                                    String rePassword,
                                    Long role_id,
                                    Long level_id,
                                    Long type_id) {
}
