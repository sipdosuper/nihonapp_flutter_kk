package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.DTO.ClassRoomDTO;
import com.example.app_tieng_nhat.DTO.UserDTO;
import com.example.app_tieng_nhat.encode.HashingService;
import com.example.app_tieng_nhat.model.ClassRoom;
import com.example.app_tieng_nhat.model.Levels;
import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.repository.ClassRepository;
import com.example.app_tieng_nhat.repository.LevelRepository;
import com.example.app_tieng_nhat.repository.RoleRepository;
import com.example.app_tieng_nhat.repository.UserRepository;
import com.example.app_tieng_nhat.request.*;
import com.example.app_tieng_nhat.service.UserService;
import com.example.app_tieng_nhat.token.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UserServiceImple implements UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private LevelRepository levelRepository;
    @Autowired
    private ClassRepository classRepository;
    @Autowired
    public JwtTokenUtil jwtTokenUtil;
    @Autowired
    public HashingService hashingService;

    private UserDTO toDTO(Users user){
        UserDTO userDTO =new UserDTO();
        userDTO.setEmail(user.getEmail());
        userDTO.setUsername(user.getUsername());
        userDTO.setLevel(user.getLevel().getName());
        userDTO.setSex(user.getSex());
        userDTO.setPassword(user.getPassword());
        return userDTO;
    }

    @Override
    public List<UserDTO> getAllUser() {
        List<Users> users= userRepository.findAll();
        List<UserDTO> userDTOS=new ArrayList<>();
        for (Users user :users){
            UserDTO userDTO=toDTO(user);
            userDTOS.add(userDTO);
        }
        return userDTOS;
    }


    @Override
    public Users getUserByID(Long id) {return userRepository.findById(id).orElse(null);}

    @Override
    public Map<Integer, Long> getUserSignUpStats(int year) {
        List<Object[]> results = userRepository.getUserSignupCountByMonth(year);

        Map<Integer, Long> signupStats = new HashMap<>();
        for (Object[] result : results) {
            Integer month = (Integer) result[0]; // Lấy tháng
            Long count = ((Number) result[1]).longValue(); // Lấy số lượng user đăng ký
            signupStats.put(month, count);
        }
        return signupStats;
    }

    @Override
    public String createUser(SignUpRequest signUpUser) {
        Optional<Roles> checkRole =roleRepository.findById(signUpUser.role_id());
        if (checkRole.isEmpty())return "Role khong ton tai";
        Users checkUser= userRepository.findUserByEmail(signUpUser.email());
        if(checkUser!=null)return "tai khoan da ton tai";
        Optional<Levels> checkLevel= levelRepository.findById(signUpUser.level_id());
        if (checkLevel.isEmpty())return "Khong ton tai level";
        try{
            Users user= new Users();
            user.setUsername(signUpUser.username());
            user.setEmail(signUpUser.email());
            user.setSignupDate(signUpUser.signupDate());
            user.setLevel(checkLevel.get());
            user.setSex(signUpUser.sex());
            String password= hashingService.hashWithSHA256(signUpUser.password());
            user.setPassword(password);
            user.setRole(checkRole.get());
            userRepository.save(user);
            return "Dang ky thanh cong";
        }catch (Exception e){
            return "co bien roi:  "+e.getMessage();
        }

    }

    @Override
    public String updateUserLevel(UpdateUserLevelRequest request) {
        Users check= userRepository.findUserByEmail(request.email());
        Optional<Levels> checkLevel= levelRepository.findById(request.level_id());
        if(check==null)return "Tai khoan khong ton tai";
        try {
            check.setLevel(checkLevel.get());
            userRepository.save(check);
            return "Cap nhat level thanh cong";
        }catch (Exception e){
            return "Co bien roi: "+e.getMessage();
        }

    }


    @Override
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public Users forGotPassword(ForgotPasswordRequest forgotPasswordRequest) {
        try{
            Users checkUser= userRepository.findUserByEmail(forgotPasswordRequest.email());
            if(checkUser!=null){
                String newPassword= hashingService.hashWithSHA256(forgotPasswordRequest.newPassword());
                Users userDetail= userRepository.findUserByEmail(forgotPasswordRequest.email());
                userDetail.setPassword(newPassword);
                return userRepository.save(userDetail);
            }else {
                return null;
            }
        }catch (Exception e){}
        return null;
    }


    @Override
    public UserDTO getUserDTOById(Long id) {
        Users user= userRepository.findById(id).orElse(null);

        return toDTO(user);
    }

    @Override
    public String signIn(SignInRequest signIn) {
        Map<String, Object> userDetails = new HashMap<>();
        Users users = userRepository.findUserByEmail(signIn.email());
        if(checkPassword(users, signIn.password())) {
            userDetails.put("email", users.getEmail());
            userDetails.put("username", users.getUsername());
            userDetails.put("role", users.getRole().getId());
            userDetails.put("lv",users.getLevel().getId());
//            String token=JwtTokenUtil.generateToken(userDetails);
            return JwtTokenUtil.generateToken(userDetails);
        }
        return null;
    }
    private ClassRoomDTO classRoomToDTO(ClassRoom classRoom){
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
    public List<ClassRoomDTO> recommentedCouse(String email) {
        Users user= userRepository.findUserByEmail(email);
        if (user== null){
            throw new RuntimeException("khong co user "+email);
        }
        if (user.getLevel()==null) {
            throw new RuntimeException("khong co level ");
        }
        List<ClassRoom> classRoomListInUserLevel= classRepository.findClassroomsByLevelId(user.getLevel().getId());
        List<ClassRoom> higherLevelClassRoom = classRepository.findClassroomsByLevelId(user.getLevel().getId()+1);
        List<ClassRoom> lowerLevelClassRoom = classRepository.findClassroomsByLevelId(user.getLevel().getId()-1);
        classRoomListInUserLevel.addAll(higherLevelClassRoom);
        classRoomListInUserLevel.addAll(lowerLevelClassRoom);
        List<ClassRoomDTO> classRoomDTOS= new ArrayList<>();
        for(ClassRoom classRoom : classRoomListInUserLevel){
            classRoomDTOS.add(classRoomToDTO(classRoom));
        }
        return classRoomDTOS;

    }


    public Boolean checkPassword(Users users,String password){
        try{
            String encodePassword=hashingService.hashWithSHA256(password);
            if(users.getPassword().equals(encodePassword))return true;
        }catch (Exception e){};

        return false;
    }

}
