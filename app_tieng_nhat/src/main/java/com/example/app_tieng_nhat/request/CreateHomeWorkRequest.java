package com.example.app_tieng_nhat.request;

public record CreateHomeWorkRequest(String name,
                                    String question,
                                    Long classRoom_id) {
}
