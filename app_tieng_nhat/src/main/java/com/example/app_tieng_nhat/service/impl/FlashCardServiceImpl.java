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
import java.util.Optional;

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
    public String multiCreateFlashCard(List<CreateFlashCardRequest> list) {
        Optional<FlashCardList> listCard;
        try {
            for (CreateFlashCardRequest card : list){
                listCard=flashCardListRepository.findById(card.cardList_id());
                if (listCard.isPresent()){
                    FlashCard newCard= new FlashCard();
                    newCard.setFont(card.font());
                    newCard.setFont_img(card.font_img());
                    newCard.setBack(card.back());
                    newCard.setBack_img(card.back_img());
                    newCard.setFlashCardList(listCard.get());
                    flashCardRepository.save(newCard);
                }
            }
            return "Tao nhieu thanh cong";
        }catch (Exception e){
            return "tao nhieu that bai: "+e.getMessage();
        }

    }

    @Override
    public void delete(Long id) {
        flashCardRepository.deleteById(id);
    }
}
