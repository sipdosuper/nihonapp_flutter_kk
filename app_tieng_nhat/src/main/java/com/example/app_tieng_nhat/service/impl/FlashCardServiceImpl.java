package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.FlashCard;
import com.example.app_tieng_nhat.model.FlashCardList;
import com.example.app_tieng_nhat.repository.FlashCardListRepository;
import com.example.app_tieng_nhat.repository.FlashCardRepository;
import com.example.app_tieng_nhat.request.CreateFlashCardRequest;
import com.example.app_tieng_nhat.service.FlashCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FlashCardServiceImpl implements FlashCardService {
    @Autowired
    private FlashCardRepository flashCardRepository;
    @Autowired
    private FlashCardListRepository flashCardListRepository;

    @Override
    public List<FlashCard> getAllFlashCard() {
        return flashCardRepository.findAll();
    }

    @Override
    public List<FlashCard> getFlashCardByListId(Long list_id) {
        try {
            FlashCardList list= flashCardListRepository.findById(list_id).orElse(null);
            return list.getFlashCards();
        }catch (Exception e){
            return null;
        }
    }

    @Override
    public String createFlashCard(CreateFlashCardRequest request) {
        FlashCardList cardList=flashCardListRepository.findById(request.cardList_id()).orElse(null);
        if (cardList==null)return "Khong ton tai thu muc nay";
        try {
            FlashCard newCard=new FlashCard();
            newCard.setFont(request.font());
            newCard.setFont_img(request.font_img());
            newCard.setBack(request.back());
            newCard.setBack_img(request.back_img());
            newCard.setFlashCardList(cardList);
            flashCardRepository.save(newCard);
            return "Tao Card moi thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }

    @Override
    public void delete(Long id) {
        flashCardRepository.deleteById(id);
    }
}
