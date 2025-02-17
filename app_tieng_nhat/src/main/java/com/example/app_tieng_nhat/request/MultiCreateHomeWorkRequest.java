package com.example.app_tieng_nhat.request;

import com.example.app_tieng_nhat.model.HomeWork;

import java.util.List;

public record MultiCreateHomeWorkRequest(List<HomeWork> homeWorkList) {
}
