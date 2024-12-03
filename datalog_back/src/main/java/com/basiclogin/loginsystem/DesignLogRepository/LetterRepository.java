package com.basiclogin.loginsystem.DesignLogRepository;
import java.time.LocalDate;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.basiclogin.loginsystem.DesignLogEntity.Letter;



public interface LetterRepository extends JpaRepository<Letter, Integer>{
    Optional<Letter> findByDescription(String description);
    Optional<Letter> findByCategory(String category);
    Optional<Letter> findByLetterDate(LocalDate letterDate);
    Optional<Letter> findByLetterNo(String letterNo);

}
