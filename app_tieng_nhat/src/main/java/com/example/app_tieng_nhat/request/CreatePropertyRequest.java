package com.example.app_tieng_nhat.request;

import java.util.Set;

public record CreatePropertyRequest (Long id,
                                     String name,
                                     Set<Long> role_id){
}
