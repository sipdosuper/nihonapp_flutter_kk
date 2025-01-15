package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.TypeMode;
import com.example.app_tieng_nhat.request.CreateTypeRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface TypeService {
    List<TypeMode> getAllType();
    String createType(CreateTypeRequest typeRequest);
    void deleteType(Long id);
}
