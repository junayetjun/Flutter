package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.ExtracurricularDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Extracurricular;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IExtracurricularRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ExtracurricularService {

    @Autowired
    private IExtracurricularRepo extracurricularRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;


    public List<ExtracurricularDTO> getByCaregiverId(Long caregiverId) {
        List<Extracurricular> extracurriculars = extracurricularRepo.findByCaregiverId(caregiverId);
        return extracurriculars.stream()
                .map(ExtracurricularDTO::new)
                .collect(Collectors.toList());
    }

    public Extracurricular saveExtracurricular(Extracurricular extracurricular, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        extracurricular.setCaregiver(caregiver);

        return extracurricularRepo.save(extracurricular);
    }

    public void delete(Long id) {
        extracurricularRepo.deleteById(id);
    }
}
