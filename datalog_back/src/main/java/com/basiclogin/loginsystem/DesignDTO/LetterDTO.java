package com.basiclogin.loginsystem.DesignDTO;
import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LetterDTO {
    private Integer letterId;
    private String letterNo;
    private LocalDate letterDate;
    private String description;
    private String filePath;
    private String fileName; // Yeni ekleme: Dosya adı
    private String catergory;
}
