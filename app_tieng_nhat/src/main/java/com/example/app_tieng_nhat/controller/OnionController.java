package com.example.app_tieng_nhat.controller;

import com.example.app_tieng_nhat.model.Onion;
import com.example.app_tieng_nhat.request.CreateOnionRequest;
import com.example.app_tieng_nhat.service.OnionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/onion")
public class OnionController {
    @Autowired
    private OnionService onionService;

    @GetMapping
    public List<Onion> getAllOnion(){return onionService.getAllOnion();}

    @GetMapping("/{id}")
    public Optional<Onion> getOnionById(@PathVariable Long id){return onionService.getOnionByID(id);}

    @PostMapping
    public Onion createOnion(@RequestBody CreateOnionRequest onionRequest){return onionService.createOnion(onionRequest);}

    @PutMapping
    public Onion updateOnion(@RequestBody CreateOnionRequest onionRequest){return onionService.updateOnion(onionRequest);}

    @DeleteMapping("/{id}")
    public void deleteOnion(@PathVariable Long id){onionService.deleteOnion(id);}

}
