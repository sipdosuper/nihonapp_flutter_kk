package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.request.RoleCreateRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface RoleService {
    List<Roles> getAllRole();
    Roles getRoleById(Long id);
    Roles createRole(RoleCreateRequest roleCreateRequest);
    void deleteRole(Long id);
}
