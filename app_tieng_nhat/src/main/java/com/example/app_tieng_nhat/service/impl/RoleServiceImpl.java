package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.repository.RoleRepository;
import com.example.app_tieng_nhat.request.RoleCreateRequest;
import com.example.app_tieng_nhat.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    private RoleRepository roleRepository;

    @Override
    public List<Roles> getAllRole() {
        return roleRepository.findAll();
    }

    @Override
    public Roles getRoleById(Long id) {
        return roleRepository.findById(id).orElse(null);
    }

    @Override
    public Roles createRole(RoleCreateRequest roleCreateRequest) {
        Optional<Roles> roleCheck= roleRepository.findById(roleCreateRequest.id());
        if(roleCheck.isEmpty()){
            Roles newRole= new Roles();
            newRole.setId(roleCreateRequest.id());
            newRole.setName(roleCreateRequest.name());
            return roleRepository.save(newRole);
        }else {
            return null;
        }

    }

    @Override
    public void deleteRole(Long id) {
        roleRepository.deleteById(id);
    }
}
