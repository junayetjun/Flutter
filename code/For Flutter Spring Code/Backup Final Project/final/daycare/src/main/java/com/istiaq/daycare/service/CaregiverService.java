package com.istiaq.daycare.service;

import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.repository.ICaregiverRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CaregiverService {

    @Autowired
    private ICaregiverRepo caregiverRepo;


    public List<Caregiver> getAll() {

        return caregiverRepo.findAll();
    }

    public Optional<Caregiver> getById(Long id) {

        return caregiverRepo.findById(id);
    }

    public Caregiver save(Caregiver caregiver) {

        return caregiverRepo.save(caregiver);
    }

    public void delete(Long id) {

        caregiverRepo.deleteById(id);

    }

    public Caregiver getProfileByUserId(int userId) {
        return caregiverRepo.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Caregiver not found"));
    }
}
