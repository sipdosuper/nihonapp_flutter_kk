package com.example.app_tieng_nhat.service;

import com.example.app_tieng_nhat.model.FlashCard;
import com.example.app_tieng_nhat.request.CreateFlashCardRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FlashCardService {
    List<FlashCard> getAllFlashCard();
    List<FlashCard> getFlashCardByListId(Long list_id);
    String createFlashCard(CreateFlashCardRequest request);
    void delete(Long id);
}
