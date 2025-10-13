package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Hobby;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IHobbyRepo extends JpaRepository<Hobby,Long> {
    List<Hobby> findByCaregiverId(Long caregiverId);
}
