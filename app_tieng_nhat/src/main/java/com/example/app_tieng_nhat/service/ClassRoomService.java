package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.request.CreateClassroomRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface ClassRoomService {
    List<ClassRoom> getAllClassRoom();
    String createClassRoom(CreateClassroomRequest classroomRequest);
    void deleteClassRoom(Long id);
}
