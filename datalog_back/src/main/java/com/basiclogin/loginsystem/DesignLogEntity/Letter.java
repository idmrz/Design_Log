package com.basiclogin.loginsystem.DesignLogEntity;
import java.time.LocalDate;
import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Letters")
public class Letter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer letterId;
    private String letterNo;
    private LocalDate letterDate;
    private String description;
    private Integer userId;
    private String filePath;
    private String category;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdDate;
    // Dosya ilk kez kaydedilirken otomatik tarih eklemek için PrePersist metodu
    @PrePersist
    protected void onCreate() {
        this.createdDate = LocalDateTime.now();  // Dosya oluşturulma tarihini otomatik olarak ayarla
    }
}




