package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.ReferenceDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Reference;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IReferenceRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReferenceService {

    @Autowired
    private IReferenceRepo referenceRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;

    public List<ReferenceDTO> getByCaregiverId(Long caregiverId) {
        List<Reference> references = referenceRepo.findByCaregiverId(caregiverId);
        return references.stream()
                .map(ReferenceDTO::new)
                .collect(Collectors.toList());
    }

    public Reference saveReference(Reference reference, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        reference.setCaregiver(caregiver);

        return referenceRepo.save(reference);
    }

    public void delete(Long id) {
        referenceRepo.deleteById(id);
    }
}
