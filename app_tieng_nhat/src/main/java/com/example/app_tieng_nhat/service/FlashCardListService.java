package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.FlashCardList;
import com.example.app_tieng_nhat.request.CreateFlashCardListRequest;
import com.example.app_tieng_nhat.request.RenameFlashCardListRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FlashCardListService {
    List<FlashCardList> getAllFlashCardList();
    String createFlashCardList(CreateFlashCardListRequest request);
    String renameFlashCardList(RenameFlashCardListRequest request);
    void delete(Long id);
}
