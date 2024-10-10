package com.example.app_tieng_nhat.token;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.Map;

@Component
public class JwtTokenUtil {


    // Secret key để ký token
    private static final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    // Thời gian sống của token (ví dụ: 10 phút)
    private static final long EXPIRATION_TIME = 60 * 6 * 60 * 1000;

    // Tạo token dựa trên thông tin của người dùng
    public static String generateToken(Map<String, Object> userDetails) {
        return Jwts.builder()
                .setSubject(userDetails.toString())  // Lưu trữ tên người dùng trong token
                .setIssuedAt(new Date())  // Thời gian phát hành
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))  // Thời gian hết hạn
                .signWith(key)  // Ký token với secret key
                .compact();  // Tạo token
    }

    // Xác minh và trích xuất thông tin từ token
    public static String validateToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }


}
