package com.basiclogin.loginsystem.DesignServices;
import com.basiclogin.loginsystem.DesignLogRepository.LetterRepository;
import com.basiclogin.loginsystem.DesignLogRepository.PDRepository;
import com.basiclogin.loginsystem.DesignLogRepository.WDRepository;
import com.basiclogin.loginsystem.DesignDTO.LetterDTO;
import com.basiclogin.loginsystem.DesignDTO.PdDTO;
import com.basiclogin.loginsystem.DesignDTO.WDDTO;
import com.basiclogin.loginsystem.DesignLogEntity.Letter;
import com.basiclogin.loginsystem.DesignLogEntity.Pdesign;
import com.basiclogin.loginsystem.DesignLogEntity.WD;
import java.nio.file.*;

import java.io.IOException;
import java.time.LocalDate;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;


@Service
public class DesignServiceImpl implements DesignService {

    @Autowired
    private WDRepository wdRepository;

    @Autowired
    private PDRepository pdesignRepository;

    @Autowired
    private LetterRepository letterRepository;

    // 1. Get Latest Methods
    @Override
    public List<WD> getLatestWds() {
        return wdRepository.findAll(Sort.by(Sort.Direction.DESC, "createdDate"));
    }

    @Override
    public List<Pdesign> getLatestPds() {
        return pdesignRepository.findAll(Sort.by(Sort.Direction.DESC, "createdDate"));
    }

    @Override
    public List<Letter> getLatestLTs() {
        return letterRepository.findAll(Sort.by(Sort.Direction.DESC, "createdDate"));
    }

    // 2. Find by Methods
    @SuppressWarnings("unchecked")
    @Override
    public <T> T findByIdentifier(String identifier, Class<T> type) {
        if (type == WD.class) {
            return (T) wdRepository.findByKks(identifier);
        } else if (type == Pdesign.class) {
            return (T) pdesignRepository.findByKks(identifier);
        } else if (type == Letter.class) {
            return (T) letterRepository.findByLetterNo(identifier);
        }
        throw new IllegalArgumentException("Unsupported type: " + type.getName());
    }

    //3 WD CRUD methods
    // Register
    @Override
     public WD registerWD(WD wd) {
     return wdRepository.save(wd);
    }

@Override
public void updateWD(Integer wdId, WD updatedWD) {
    // Find the existing WD by its ID
    WD wd = wdRepository.findById(wdId).orElse(null);

    if (wd != null) {
        // Dosyanın saklandığı klasör yolunu belirtin
        String folderPath = "/var/design/wdocumentation/";  // Bu yolu kendi sisteminize göre ayarlayın

        // Store the old file path for renaming the file on the file system
        String oldFilePath = folderPath + wd.getFilePath();

        // Update fields if they are not null
        if (updatedWD.getKks() != null) wd.setKks(updatedWD.getKks());
        if (updatedWD.getDescription() != null) wd.setDescription(updatedWD.getDescription());
        if (updatedWD.getRevisionNo() != null) wd.setRevisionNo(updatedWD.getRevisionNo());
        if (updatedWD.getVersionNo() != null) wd.setVersionNo(updatedWD.getVersionNo());

        // Generate the new folder name based on updated fields
        String folderName = String.format("%s_%s_%s", wd.getWdId(), wd.getKks(), LocalDate.now());
        String newFilePath = folderPath + folderName;

        // Update the file path in the database
        wd.setFilePath(folderName); // Sadece dosya adını veritabanına kaydediyoruz

        // Rename the file on the file system using Files.move
        Path oldFile = Paths.get(oldFilePath);
        Path newFile = Paths.get(newFilePath);
        try {
            Files.move(oldFile, newFile, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Dosya başarıyla yeniden adlandırıldı.");
        } catch (IOException e) {
            System.out.println("Dosya yeniden adlandırılamadı: " + e.getMessage());
        }

        // Save the updated WD entity in the database
        wdRepository.save(wd);
    } else {
        throw new IllegalArgumentException("WD with id " + wdId + " not found.");
    }
}

    //file upload
    @Override
    public void uploadWDFile(WDDTO wdDTO, WD wd) {
        wd.setFilePath(wdDTO.getFilePath());
        wdRepository.save(wd);
   }

    //delete
    @Override
    public void deleteWD(Integer wdId) {
        if (wdRepository.existsById(wdId)) {
            wdRepository.deleteById(wdId);
        } else {
            throw new IllegalArgumentException("WD with id " + wdId + " not found.");
        }
    }
 // 4. Pdesign CRUD Operations
    // Register
    @Override
    public Pdesign registerPD(Pdesign pd) {
    return pdesignRepository.save(pd);
    }
@Override
public void updatePD(Integer pdId, Pdesign updatedPD) {
    // Find the existing PD by its ID
    Pdesign pd = pdesignRepository.findById(pdId).orElse(null);

    if (pd != null) {
        // Dosyanın saklandığı klasör yolunu belirtin
        String folderPath = "/var/design/pdesign/";  // Bu yolu kendi sisteminize göre ayarlayın

        // Store the old file path for renaming the file on the file system
        String oldFilePath = folderPath + pd.getFilePath();

        if (updatedPD.getKks() != null) pd.setKks(updatedPD.getKks());
        if (updatedPD.getDescription() != null) pd.setDescription(updatedPD.getDescription());
        if (updatedPD.getRevisionNo() != null) pd.setRevisionNo(updatedPD.getRevisionNo());
        if (updatedPD.getVersionNo() != null) pd.setVersionNo(updatedPD.getVersionNo());

        // Generate the new folder name based on updated fields
        String folderName = String.format("%s_%s_%s", pd.getPdId(), pd.getKks(), LocalDate.now());
        String newFilePath = folderPath + folderName;

        // Update the file path in the database
        pd.setFilePath(folderName); // Sadece dosya adını veritabanına kaydediyoruz

        // Rename the file on the file system using Files.move
        Path oldFile = Paths.get(oldFilePath);
        Path newFile = Paths.get(newFilePath);
        try {
            Files.move(oldFile, newFile, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Dosya başarıyla yeniden adlandırıldı.");
        } catch (IOException e) {
            System.out.println("Dosya yeniden adlandırılamadı: " + e.getMessage());
        }

        // Save the updated PD entity in the database
        pdesignRepository.save(pd);
    } else {
            throw new IllegalArgumentException("PD with id " + pdId + " not found.");
        }
}

@Override
public void uploadPDFile(PdDTO pdDTO, Pdesign pd) {
    pd.setFilePath(pdDTO.getFilePath());
    pdesignRepository.save(pd);
}

    @Override
    public void deletePD(Integer pdId) {
    if (pdesignRepository.existsById(pdId)) {
        pdesignRepository.deleteById(pdId);
    } else {
        throw new IllegalArgumentException("Pdesign with id " + pdId + " not found.");
    }
}


    // 5. Letter CRUD Operations
    @Override
    public Letter registerLetter(Letter lt) {
        return letterRepository.save(lt);
    }

@Override
public void updateLT(Integer letterId, Letter updatedLt) {
     // Find the existing PD by its ID
    Letter lt = letterRepository.findById(letterId).orElse(null);

    if (lt != null) {
        // Dosyanın saklandığı klasör yolunu belirtin
        String folderPath = "/var/design/letters/";  // Bu yolu kendi sisteminize göre ayarlayın

        // Store the old file path for renaming the file on the file system
        String oldFilePath = folderPath + lt.getFilePath();

            if (updatedLt.getLetterNo() != null) lt.setLetterNo(updatedLt.getLetterNo());
            if (updatedLt.getLetterDate() != null) lt.setLetterDate(updatedLt.getLetterDate());
            if (updatedLt.getDescription() != null) lt.setDescription(updatedLt.getDescription());
            if (updatedLt.getCategory() != null) lt.setCategory(updatedLt.getCategory());
            
        // Generate the new folder name based on updated fields
        String folderName = String.format("%s_%s_%s", lt.getLetterId(), lt.getLetterNo(), lt.getLetterDate());
        String newFilePath = folderPath + folderName;

        // Update the file path in the database
        lt.setFilePath(folderName); // Sadece dosya adını veritabanına kaydediyoruz

        // Rename the file on the file system using Files.move
        Path oldFile = Paths.get(oldFilePath);
        Path newFile = Paths.get(newFilePath);
        try {
            Files.move(oldFile, newFile, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Dosya başarıyla yeniden adlandırıldı.");
        } catch (IOException e) {
            System.out.println("Dosya yeniden adlandırılamadı: " + e.getMessage());
        }

        // Save the updated LT entity in the database
        letterRepository.save(lt);
    } else {
            throw new IllegalArgumentException("LT with id " + letterId + " not found.");
        }
}

    @Override
    public void uploadPDFile(LetterDTO ltDTO, Letter lt) {
        lt.setFilePath(ltDTO.getFilePath());
        letterRepository.save(lt);
    }

    @Override
    public void deleteLT(Integer letterId) {
        if (letterRepository.existsById(letterId)) {
            letterRepository.deleteById(letterId);
        } else {
            throw new IllegalArgumentException("Letter with id " + letterId + " not found.");
        }
    }
}


