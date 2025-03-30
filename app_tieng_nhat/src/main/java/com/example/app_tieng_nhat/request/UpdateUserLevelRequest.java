package com.example.app_tieng_nhat.request;

public record UpdateUserLevelRequest(String email,
                                     Long level_id) {
}
