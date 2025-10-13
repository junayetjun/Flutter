package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Language;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ILanguageRepo extends JpaRepository<Language, Long> {
    List<Language> findByCaregiverId(Long caregiverId);
}
