package com.basiclogin.loginsystem.DesignLogEntity;
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
@Table(name = "PDesign")
public class Pdesign {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer pdId;
    private String kks;
    private String description;
    private Integer revisionNo;
    private Integer versionNo;
    private Integer userId;
    private String filePath;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdDate;
    @PrePersist
    protected void onCreate() {
        this.createdDate = LocalDateTime.now();  // Dosya oluşturulma tarihini otomatik olarak ayarla
    }
}

