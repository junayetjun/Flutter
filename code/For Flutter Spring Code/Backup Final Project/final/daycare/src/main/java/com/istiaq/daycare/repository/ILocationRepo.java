package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ILocationRepo extends JpaRepository<Location, Long> {
}
