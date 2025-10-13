package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.SkillDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Skill;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.ISkillRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SkillService {

    @Autowired
    private ISkillRepo skillRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;

    public List<SkillDTO> getByCaregiverId(Long caregiverId) {
        List<Skill> skills = skillRepo.findByCaregiverId(caregiverId);
        return skills.stream()
                .map(SkillDTO::new)
                .collect(Collectors.toList());
    }

    public Skill saveSkill(Skill skill, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        skill.setCaregiver(caregiver);

        return skillRepo.save(skill);
    }

    public void delete(Long id) {
        skillRepo.deleteById(id);
    }
}
