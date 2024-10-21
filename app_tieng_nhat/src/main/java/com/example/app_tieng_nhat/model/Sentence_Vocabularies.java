package com.example.app_tieng_nhat.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Embeddable
@AllArgsConstructor // Tạo constructor với tất cả các tham số
@NoArgsConstructor
public class Sentence_Vocabularies implements Serializable {

    @Column(name = "vocabularies_id")
    private Long vocabulary_id;

    @Column(name = "sentence_id")
    private Long sentence_id;
}
