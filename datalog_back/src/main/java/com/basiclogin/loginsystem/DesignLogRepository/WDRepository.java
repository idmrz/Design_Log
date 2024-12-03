package com.basiclogin.loginsystem.DesignLogRepository;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.basiclogin.loginsystem.DesignLogEntity.WD;


public interface WDRepository extends JpaRepository<WD, Integer>{

    Optional<WD> findByKks(String kks);
    Optional<WD> findByDescription(String description);

}
