package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Lessons;
import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.request.RoleCreateRequest;
import com.example.app_tieng_nhat.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/role")
public class RoleController {
    @Autowired
    private RoleService roleService;

    @GetMapping
    public List<Roles> getAllRole(){
        return roleService.getAllRole();
    }

    @GetMapping("/{id}")
    public Roles getRoleById(Long id){
        return  roleService.getRoleById(id);
    }

    @PostMapping
    public Roles createRole(RoleCreateRequest roleCreateRequest){
        return roleService.createRole(roleCreateRequest);
    }



    @DeleteMapping("/delete/{id}")
    public void deleteRole(Long id){
        roleService.deleteRole(id);
    }

}
