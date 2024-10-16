package com.example.app_tieng_nhat.request;

public record CreateOnionRequest (Long id,
                                  String title,
                                  String content,
                                  Long topic_id){
}
