package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Experience;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IExperienceRepo extends JpaRepository<Experience, Long> {

    List<Experience> findByCaregiverId(Long caregiverId);
}
