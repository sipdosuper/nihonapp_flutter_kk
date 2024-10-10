package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.DTO.UserDTO;
import com.example.app_tieng_nhat.encode.HashingService;
import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.repository.RoleRepository;
import com.example.app_tieng_nhat.repository.UserProgressRepository;
import com.example.app_tieng_nhat.repository.UserRepository;
import com.example.app_tieng_nhat.request.ForgotPasswordRequest;
import com.example.app_tieng_nhat.request.SignInRequest;
import com.example.app_tieng_nhat.request.SignUpRequest;
import com.example.app_tieng_nhat.service.UserService;
import com.example.app_tieng_nhat.token.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class UserServiceImple implements UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    public JwtTokenUtil jwtTokenUtil;
    @Autowired
    public HashingService hashingService;

    @Override
    public List<Users> getAllUser() {
        return userRepository.findAll();
    }


    @Override
    public Users getUserByID(Long id) {return userRepository.findById(id).orElse(null);}

    @Override
    public Users createUser(SignUpRequest signUpUser) {
        try{
            Optional<Roles> checkRole =roleRepository.findById(signUpUser.role_id());
            if (checkRole.isEmpty())return null;
            Optional<Users> checkUser= userRepository.findById(signUpUser.id());
            if(checkUser.isEmpty()){
                Users user= new Users();
                user.setId(signUpUser.id()) ;
                user.setUsername(signUpUser.username());
                user.setEmail(signUpUser.email());
                user.setSex(signUpUser.sex());
                String password= hashingService.hashWithSHA256(signUpUser.password());
                user.setPassword(password);
                user.setRole(checkRole.get());
                return  (Users) userRepository.save(user);
            }
            else {
                return null;
            }
        }catch (Exception e){}

        return null;
    }

    @Override
    public Users updateUser(Long id, Users user) {
        return null;
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
        UserDTO userDTO=new UserDTO();
        userDTO.setEmail(user.getEmail());
        userDTO.setUsername(user.getUsername());
        userDTO.setSex(user.getSex());
        userDTO.setPassword(user.getPassword());
        return userDTO;
    }

    @Override
    public String signIn(SignInRequest signIn) {
        Map<String, Object> userDetails = new HashMap<>();
        Users users = userRepository.findUserByEmail(signIn.email());
        if(checkPassword(users, signIn.password())) {
            userDetails.put("email", users.getEmail());
            userDetails.put("username", users.getUsername());
            userDetails.put("role", users.getRole().getId());
//            String token=JwtTokenUtil.generateToken(userDetails);
            return JwtTokenUtil.generateToken(userDetails);
        }
        return null;
    }
    public Boolean checkPassword(Users users,String password){
        try{
            String encodePassword=hashingService.hashWithSHA256(password);
            if(users.getPassword().equals(encodePassword))return true;
        }catch (Exception e){};

        return false;
    }

}
