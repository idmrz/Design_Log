package com.basiclogin.loginsystem.DesignServices;
import com.basiclogin.loginsystem.DesignDTO.LetterDTO;
import com.basiclogin.loginsystem.DesignDTO.PdDTO;
import com.basiclogin.loginsystem.DesignDTO.WDDTO;
import com.basiclogin.loginsystem.DesignLogEntity.Letter;
import com.basiclogin.loginsystem.DesignLogEntity.Pdesign;
import com.basiclogin.loginsystem.DesignLogEntity.WD;

import java.util.List;


public interface DesignService {

    List<WD> getLatestWds();
    List<Pdesign> getLatestPds();
    List<Letter> getLatestLTs();

    <T> T findByIdentifier(String identifier, Class<T> type);
//wd
    public WD registerWD(WD wd);
    void updateWD(Integer wdId, WD updatedWD);
    void deleteWD(Integer wdId);
    public void uploadWDFile(WDDTO wdDTO, WD wd);
//pd
    public Pdesign registerPD(Pdesign pd);
    void updatePD(Integer pdId, Pdesign updatedPD);
    void deletePD(Integer pdId);
    public void uploadPDFile(PdDTO pdDTO, Pdesign pd);
//letter
public Letter registerLetter(Letter lt);
void updateLT(Integer letterId, Letter updatedLt);
void deleteLT(Integer letterId);
public void uploadPDFile(LetterDTO ltDTO, Letter lt);
     
}
