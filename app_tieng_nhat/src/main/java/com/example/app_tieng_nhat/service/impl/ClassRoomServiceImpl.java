package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.DTO.ClassRoomDTO;
import com.example.app_tieng_nhat.model.*;
import com.example.app_tieng_nhat.repository.*;
import com.example.app_tieng_nhat.request.CreateClassroomRequest;
import com.example.app_tieng_nhat.service.ClassRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ClassRoomServiceImpl implements ClassRoomService {
    @Autowired
    private ClassRepository classRepository;
    @Autowired
    private TimeRepository timeRepository;
    @Autowired
    private TeacherRepository teacherRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private LevelRepository levelRepository;

    private ClassRoomDTO convertToDTO(ClassRoom classRoom){
        ClassRoomDTO dto= new ClassRoomDTO();
        dto.setId(classRoom.getId());
        dto.setName(classRoom.getName());
        dto.setLevel(classRoom.getLevel().getName());
        dto.setDescription(classRoom.getDescription());
        dto.setSl_max(classRoom.getSl_max());
        dto.setLink_giaotrinh(classRoom.getLink_giaotrinh());
        dto.setStart(classRoom.getStart());
        dto.setEnd(classRoom.getEnd());
        dto.setPrice(classRoom.getPrice());
        dto.setTime(classRoom.getTime().getTime());
        dto.setTeacherName(classRoom.getTeacher().getUsername());
        return dto;
    }

    @Override
    public List<ClassRoomDTO> getAllClassRoom() {
        return classRepository.findAll()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<ClassRoomDTO> getAllClassRoomDTO(String email) {
        Users check= userRepository.findUserByEmail(email);
        if (check==null) return null;
        return classRepository.findClassroomsByUserId(check.getId())
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public String createClassRoom(CreateClassroomRequest classroomRequest) {
        Optional<Levels> checkLevel=levelRepository.findById(classroomRequest.level_id());
        Optional<Time> checkTime=timeRepository.findById(classroomRequest.time_id());
        Optional<Teacher> teacher=teacherRepository.findById(classroomRequest.teacher_id());
        if(checkLevel.isEmpty()||checkTime.isEmpty())return "level or time is empty";
        if(teacher.isEmpty())return "teacher is empty";
        try{
            ClassRoom newClassRoom= new ClassRoom();
            newClassRoom.setName(classroomRequest.name());
            newClassRoom.setLevel(checkLevel.get());
            newClassRoom.setDescription(classroomRequest.description());
            newClassRoom.setSl_max(classroomRequest.sl_max());
            newClassRoom.setLink_giaotrinh(classroomRequest.link_giaotrinh());
            newClassRoom.setStart(classroomRequest.start());
            newClassRoom.setEnd(classroomRequest.end());
            newClassRoom.setPrice(classroomRequest.price());
            newClassRoom.setTeacher(teacher.get());
            newClassRoom.setTime(checkTime.get());
            classRepository.save(newClassRoom);
            return "Tao Lop moi thanh cong";
        }catch (Exception e){
            return "co bien roi"+e.getMessage();
        }

    }

    @Override
    public void deleteClassRoom(Long id) {
        classRepository.deleteById(id);
    }
}
