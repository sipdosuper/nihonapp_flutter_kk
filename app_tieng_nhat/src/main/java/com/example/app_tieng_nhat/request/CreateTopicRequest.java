package com.example.app_tieng_nhat.request;

public record CreateTopicRequest(Long id,
                                 String name,
                                 Long level_id) {
}
