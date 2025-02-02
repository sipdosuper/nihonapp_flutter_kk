package com.example.app_tieng_nhat.request;

public record CreateFlashCardRequest(String font,
                                     String font_img,
                                     String back,
                                     String back_img,
                                     Long cardList_id) {
}
