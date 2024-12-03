package com.basiclogin.loginsystem.DesignLogRepository;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.basiclogin.loginsystem.DesignLogEntity.Pdesign;


public interface PDRepository extends JpaRepository<Pdesign, Integer>{

    Optional<Pdesign> findByKks(String kks);
    Optional<Pdesign> findByDescription(String description);

}
