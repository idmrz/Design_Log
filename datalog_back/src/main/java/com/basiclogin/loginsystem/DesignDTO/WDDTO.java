package com.basiclogin.loginsystem.DesignDTO;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

public class WDDTO {
    private Integer wdId;
    private String kks;
    private String description;
    private Integer revisionNo;
    private Integer versionNo;
    private String filePath;
    private String fileName; // Yeni ekleme: Dosya adı
}


