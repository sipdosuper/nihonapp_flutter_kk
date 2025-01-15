package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.Teacher;
import com.example.app_tieng_nhat.model.Time;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.repository.TeacherRepository;
import com.example.app_tieng_nhat.repository.TimeRepository;
import com.example.app_tieng_nhat.request.CreateClassroomRequest;
import com.example.app_tieng_nhat.service.ClassRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClassRoomServiceImpl implements ClassRoomService {
    @Autowired
    private ClassRepository classRepository;
    @Autowired
    private TimeRepository timeRepository;
    @Autowired
    private TeacherRepository teacherRepository;
    @Autowired
    private LevelRepository levelRepository;
    @Override
    public List<ClassRoom> getAllClassRoom() {
        return classRepository.findAll();
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
