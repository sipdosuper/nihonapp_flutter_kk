package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.Property;
import com.example.app_tieng_nhat.model.Roles;
import com.example.app_tieng_nhat.repository.PropertyRepository;
import com.example.app_tieng_nhat.repository.RoleRepository;
import com.example.app_tieng_nhat.request.CreatePropertyRequest;
import com.example.app_tieng_nhat.service.PropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class PropertyServiceImpl implements PropertyService {
    @Autowired
    private PropertyRepository propertyRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Override
    public List<Property> getAllProperty() {
        return propertyRepository.findAll();
    }

    @Override
    public Set<Property> getPropertyByRole(Long roleId) {
        Optional<Roles> checkRole= roleRepository.findById(roleId);
        if(checkRole.isPresent()){
            Roles roles= roleRepository.findById(roleId).orElse(null);
            return roles.getProperties();
        }
        return null;
    }

    @Override
    public Property createProperty(CreatePropertyRequest propertyRequest) {
        Optional<Property> check= propertyRepository.findById(propertyRequest.id());
        if(check.isEmpty()){
            Property property= new Property();
            property.setId(propertyRequest.id());
            property.setName(propertyRequest.name());
            Set<Roles> roles= new HashSet<>();
            for(Long roleId: propertyRequest.role_id()){
                Roles role= roleRepository.findById(roleId).orElseThrow(()->new RuntimeException("RoleId not found"));
                roles.add(role);
            }
            property.setRoles(roles);
            return propertyRepository.save(property);
        }

        return null;
    }

    @Override
    public void deleteProperty(Long id) {
        propertyRepository.deleteById(id);
    }
}
