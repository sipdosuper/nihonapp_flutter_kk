package com.example.app_tieng_nhat.request;

public record UpdateHomeWorkRequest(Long id,
                                    String name,
                                    String question,
                                    Long classRoom_id) {
}
