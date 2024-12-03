package com.basiclogin.loginsystem.DesignDTO;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

public class PdDTO {
    private Integer pdId;
    private String kks;
    private String description;
    private Integer revisionNo;
    private Integer versionNo;
    private String filePath;
    private String fileName; // Yeni ekleme: Dosya adı
}
