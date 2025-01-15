package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.TypeMode;
import com.example.app_tieng_nhat.repository.TypeRepository;
import com.example.app_tieng_nhat.request.CreateTypeRequest;
import com.example.app_tieng_nhat.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TypeServiceImpl implements TypeService {
    @Autowired
    private TypeRepository typeRepository;

    @Override
    public List<TypeMode> getAllType() {
        return typeRepository.findAll();
    }

    @Override
    public String createType(CreateTypeRequest typeRequest) {
        Optional<TypeMode> checkType=typeRepository.findById(typeRequest.id());
        if(checkType.isEmpty()){
            TypeMode newType= new TypeMode();
            newType.setId(typeRequest.id());
            newType.setName(typeRequest.name());
            typeRepository.save(newType);
            return "Tao Type moi thanh cong";
        }

        return "type_id da ton tai";
    }

    @Override
    public void deleteType(Long id) {
        typeRepository.deleteById(id);
    }
}
