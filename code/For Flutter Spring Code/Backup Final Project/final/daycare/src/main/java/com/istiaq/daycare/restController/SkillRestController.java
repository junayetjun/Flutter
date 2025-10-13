package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.SkillDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Skill;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.SkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/skill/")
public class SkillRestController {

    @Autowired
    private SkillService skillService;
    @Autowired
    private CaregiverService caregiverService;
    @Autowired
    private IUserRepo userRepo;

    @PostMapping("add")
    public ResponseEntity<Skill> addSkill(@RequestBody Skill skill, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Skill savedSkill = skillService.saveSkill(skill, email);
        return ResponseEntity.ok(savedSkill);
    }

    @GetMapping("all")
    public ResponseEntity<List<SkillDTO>> getSkillsByCaregiver(Authentication authentication) {
        String email = authentication.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        Caregiver caregiver = caregiverService.getProfileByUserId(user.getId());

        List<SkillDTO> skills = skillService.getByCaregiverId(caregiver.getId());

        return ResponseEntity.ok(skills);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteSkill(@PathVariable Long id) {
        skillService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
