package com.basiclogin.loginsystem.Entity;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import javax.crypto.spec.SecretKeySpec;
import jakarta.xml.bind.DatatypeConverter;
import java.security.Key;
import java.util.Date;

public class JwtTokenUtil {

    private static final int SECRET_KEY_SIZE_BYTES = 32;
    private static final String secretKey = generateRandomSecretKey();
    private static final long expirationMs = 86400000;

    // Rastgele gizli anahtar oluşturma
    private static String generateRandomSecretKey() {
        byte[] secretKeyBytes = new byte[SECRET_KEY_SIZE_BYTES];
        return DatatypeConverter.printBase64Binary(secretKeyBytes);
    }

    // Token oluşturma metodu
    public static String generateToken(String username, Integer userId) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expirationMs);

        Key signingKey = new SecretKeySpec(secretKey.getBytes(), SignatureAlgorithm.HS512.getJcaName());

        return Jwts.builder()
                .setSubject(username)
                .claim("userId", userId) // userId'yi token'a ekliyoruz
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(signingKey)
                .compact();
    }

    // Token'dan userId'yi çıkaran metot
    public static Integer getUserIdFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
            .setSigningKey(secretKey.getBytes())  // secretKey doğrulama yapılıyor
            .build()
            .parseClaimsJws(token)
            .getBody();

        return (Integer) claims.get("userId");  // Token'dan userId'yi çıkarıyoruz
    }
}
