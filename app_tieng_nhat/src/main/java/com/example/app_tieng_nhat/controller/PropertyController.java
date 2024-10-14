package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Property;
import com.example.app_tieng_nhat.request.CreatePropertyRequest;
import com.example.app_tieng_nhat.service.PropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/property")
public class PropertyController {
    @Autowired
    private PropertyService propertyService;

    @GetMapping
    public List<Property> getAllProperty(){return propertyService.getAllProperty();}

    @GetMapping("/{roleId}")
    public Set<Property> getPropertyByRole(@PathVariable Long roleId){
        return propertyService.getPropertyByRole(roleId);
    }

    @PostMapping
    public Property createProperty(@RequestBody CreatePropertyRequest propertyRequest){
        return propertyService.createProperty(propertyRequest);
    }

    @DeleteMapping("/{id}")
    public void deletePropertyById(@PathVariable Long id){propertyService.deleteProperty(id);}
}
