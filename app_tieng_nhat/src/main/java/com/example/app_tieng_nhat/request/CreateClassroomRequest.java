package com.example.app_tieng_nhat.request;

import java.time.LocalDate;
import java.util.Date;

public record CreateClassroomRequest(String name,
                                     Long level_id,
                                     String description,
                                     Long sl_max,
                                     String link_giaotrinh,
                                     LocalDate start,
                                     LocalDate end,
                                     Long price,
                                     Long time_id,
                                     Long teacher_id) {
}
