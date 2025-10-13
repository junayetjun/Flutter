package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Education;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IEducationRepo extends JpaRepository<Education, Long> {

    List<Education> findByCaregiverId(Long caregiverId);
}
