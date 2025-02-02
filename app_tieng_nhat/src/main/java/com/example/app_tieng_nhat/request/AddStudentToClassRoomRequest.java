package com.example.app_tieng_nhat.request;

public record AddStudentToClassRoomRequest(String email,
                                           Long classRoom_id,
                                           Long regisForm_id) {
}
