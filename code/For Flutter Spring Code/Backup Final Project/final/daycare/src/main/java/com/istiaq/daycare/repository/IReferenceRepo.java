package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Reference;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IReferenceRepo extends JpaRepository<Reference,Long> {

    List<Reference> findByCaregiverId(Long caregiverId);
}
