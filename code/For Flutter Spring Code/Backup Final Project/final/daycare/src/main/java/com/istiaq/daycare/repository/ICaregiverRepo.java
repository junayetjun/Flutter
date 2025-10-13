package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ICaregiverRepo extends JpaRepository<Caregiver, Long> {

    Optional<Caregiver> findByUserId(int userId);

    @Query("SELECT cs FROM Caregiver cs WHERE cs.user.email = :email")
    Optional<Caregiver> findByUserEmail(@Param("email") String email);

//    @Query("SELECT c FROM Caregiver c LEFT JOIN FETCH c.educations WHERE c.id = :id")
//    Optional<Caregiver> findByIdWithEducations(@Param("id") Long id);


    // Find Caregiver by email
    Optional<Caregiver> findByEmail(String email);

    Optional<Caregiver> findById(Long id);

    Optional<Caregiver> findByUser(User user);

}
