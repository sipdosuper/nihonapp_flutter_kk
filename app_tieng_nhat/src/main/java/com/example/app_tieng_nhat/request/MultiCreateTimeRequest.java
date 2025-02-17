package com.example.app_tieng_nhat.request;

import com.example.app_tieng_nhat.model.Time;

import java.util.List;

public record MultiCreateTimeRequest(List<Time> timeList) {
}
