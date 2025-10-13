package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface IParentRepo extends JpaRepository<Parent, Long> {


    Optional<Parent> findByUserId(int userId);

    @Query("SELECT p FROM Parent p WHERE p.user.email = :email")
    Optional<Parent> findByUserEmail(@Param("email") String email);


    Optional<Parent> findByEmail(String email);
}
