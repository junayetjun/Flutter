package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.ExperienceDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Experience;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IExperienceRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ExperienceService {

    @Autowired
    private IExperienceRepo experienceRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;

    public List<ExperienceDTO> getByCaregiverId(Long caregiverId) {
        List<Experience> experiences = experienceRepo.findByCaregiverId(caregiverId);
        return experiences.stream()
                .map(ExperienceDTO::new)
                .collect(Collectors.toList());
    }

    public Experience saveExperience(Experience experience, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        experience.setCaregiver(caregiver);

        return experienceRepo.save(experience);
    }

    public void delete(Long id) {
        experienceRepo.deleteById(id);
    }
}
