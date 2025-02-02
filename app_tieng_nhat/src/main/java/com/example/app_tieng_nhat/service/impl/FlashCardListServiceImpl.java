package com.example.app_tieng_nhat.service.impl;

import com.example.app_tieng_nhat.model.FlashCardList;
import com.example.app_tieng_nhat.model.Users;
import com.example.app_tieng_nhat.repository.FlashCardListRepository;
import com.example.app_tieng_nhat.repository.FlashCardRepository;
import com.example.app_tieng_nhat.repository.UserRepository;
import com.example.app_tieng_nhat.request.CreateFlashCardListRequest;
import com.example.app_tieng_nhat.request.RenameFlashCardListRequest;
import com.example.app_tieng_nhat.service.FlashCardListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FlashCardListServiceImpl implements FlashCardListService {
    @Autowired
    private FlashCardListRepository flashCardListRepository;
    @Autowired
    private UserRepository userRepository;

    @Override
    public List<FlashCardList> getAllFlashCardList() {
        return flashCardListRepository.findAll();
    }

    @Override
    public String createFlashCardList(CreateFlashCardListRequest request) {
        Users user= userRepository.findById(request.student_id()).orElse(null);
        if (user==null)return "khong ton tai nguoi dung nay";
        try {
            FlashCardList newCardList= new FlashCardList();
            newCardList.setName(request.name());
            newCardList.setStudent(user);
            flashCardListRepository.save(newCardList);
            return "Tao thu muc card moi thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }

    @Override
    public String renameFlashCardList(RenameFlashCardListRequest request) {
        FlashCardList cardList= flashCardListRepository.findById(request.cardList_id()).orElse(null);
        if (cardList==null)return "Khong ton tai danh sach nay";
        try {
            cardList.setName(request.name());
            flashCardListRepository.save(cardList);
            return "Doi ten thanh cong";
        }catch (Exception e){
            return "co bien roi: "+e.getMessage();
        }
    }

    @Override
    public void delete(Long id) {
        flashCardListRepository.deleteById(id);
    }
}
