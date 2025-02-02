package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.encode.HashingService;
import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.model.Teacher;
import com.example.app_tieng_nhat.model.TypeMode;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.RoleRepository;
import com.example.app_tieng_nhat.repository.TeacherRepository;
import com.example.app_tieng_nhat.repository.TypeRepository;
import com.example.app_tieng_nhat.request.AddTeacherToClassRoomRequest;
import com.example.app_tieng_nhat.request.ChangeTypeTeacherRequest;
import com.example.app_tieng_nhat.request.CreateTeacherRequest;
import com.example.app_tieng_nhat.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TeacherServiceImpl implements TeacherService {
    @Autowired
    private TeacherRepository teacherRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private TypeRepository typeRepository;
    @Autowired
    private HashingService hashingService;
    @Autowired
    private ClassRepository classRepository;

    @Override
    public List<Teacher> getAllTeacher() {
        return teacherRepository.findAll();
    }

    @Override
    public String createTeacher(CreateTeacherRequest teacherRequest) {
        try {
            Optional<Roles> checkRole = roleRepository.findById(teacherRequest.role_id());
            if (checkRole.isEmpty()) return "Role khong ton tai";
            Optional<TypeMode> typeMode= typeRepository.findById(teacherRequest.type_id());
            if (typeMode.isEmpty()) return "Type khong ton tai";
            Teacher checkTeacher = teacherRepository.findByEmail(teacherRequest.email());
//            Optional<Users>checkId= userRepository.findById(signUpUser.id());
            if (checkTeacher == null) {
                Teacher teacher = new Teacher();
                teacher.setUsername(teacherRequest.username());
                teacher.setEmail(teacherRequest.email());
                teacher.setSex(teacherRequest.sex());
                String password = hashingService.hashWithSHA256(teacherRequest.password());
                teacher.setPassword(password);
                teacher.setRole(checkRole.get());

                teacher.setType(typeMode.get());
                teacherRepository.save(teacher);
                return "Tao thanh cong teacher";
            } else {
                return "email da ton tai";
            }
        }catch (Exception e){return "Co bien xay ra"+e.getMessage();}
    }

    @Override
    public String changeType(ChangeTypeTeacherRequest request) {
        Teacher checkTeacher=teacherRepository.findByEmail(request.email());
        if(checkTeacher!=null){
            Optional<TypeMode> type =typeRepository.findById(request.type_id());
            if(type.isEmpty())return "Type khong ton tai";
            checkTeacher.setType(type.get());
            teacherRepository.save(checkTeacher);
            return "doi chuc nghiep thanh cong";
        }
        return "tai khoan khong ton tai";
    }

    @Override
    public String addTeacherToClassRoom(AddTeacherToClassRoomRequest request) {
        Teacher teacher=teacherRepository.findById(request.teacher_id()).orElse(null);
        if (teacher==null)return "Khong ton tai giao vien nay";
        ClassRoom classRoom= classRepository.findById(request.classRoom_id()).orElse(null);
        if (classRoom==null)return "Khong ton tai lop nay";
        try {

            classRoom.setTeacher(teacher);
            teacher.getClasses().add(classRoom);

            classRepository.save(classRoom);
            teacherRepository.save(teacher);
            return "Phan lop thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }

    @Override
    public void deleteTeacher(Long id) {
        teacherRepository.deleteById(id);
    }
}
