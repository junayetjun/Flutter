package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.EducationDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Education;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IEducationRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EducationService {

    @Autowired
    private IEducationRepo educationRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;


    public List<EducationDTO> getByCaregiverId(Long caregiverId) {
        List<Education> educations = educationRepo.findByCaregiverId(caregiverId);
        return educations.stream()
                .map(EducationDTO::new)
                .collect(Collectors.toList());
    }

    public Education saveEducation(Education education, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        education.setCaregiver(caregiver);

        return educationRepo.save(education);
    }


    public void delete(Long id) {
        educationRepo.deleteById(id);
    }

}
