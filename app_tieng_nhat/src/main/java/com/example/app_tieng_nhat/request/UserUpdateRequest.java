package com.example.app_tieng_nhat.request;

public record UserUpdateRequest (Long id,
                                 String username,
                                 Boolean sex){
}
