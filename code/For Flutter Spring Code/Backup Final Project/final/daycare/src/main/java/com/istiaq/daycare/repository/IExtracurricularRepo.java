package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Extracurricular;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IExtracurricularRepo extends JpaRepository<Extracurricular, Long> {

    List<Extracurricular> findByCaregiverId(Long caregiverId);
}
