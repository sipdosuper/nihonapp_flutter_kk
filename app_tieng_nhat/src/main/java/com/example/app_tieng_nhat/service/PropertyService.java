package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.Property;
import com.example.app_tieng_nhat.request.CreatePropertyRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public interface PropertyService {
    List<Property> getAllProperty();
    Set<Property> getPropertyByRole(Long roleId);
    Property createProperty(CreatePropertyRequest propertyRequest);
    void deleteProperty(Long id);
}
