package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.ExperienceDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Experience;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.ExperienceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/experience/")
public class ExperienceRestController {

    @Autowired
    private ExperienceService experienceService;

    @Autowired
    private CaregiverService caregiverService;

    @Autowired
    private IUserRepo userRepo;

    @PostMapping("add")
    public ResponseEntity<Experience> addExperience(@RequestBody Experience experience, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Experience savedExperience = experienceService.saveExperience(experience, email);
        return ResponseEntity.ok(savedExperience);
    }

    @GetMapping("all")
    public ResponseEntity<List<ExperienceDTO>> getEducationsByCaregiver(Authentication authentication) {
        // Get logged-in user email
        String email = authentication.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        Caregiver caregiver = caregiverService.getProfileByUserId(user.getId());


        List<ExperienceDTO> educations = experienceService.getByCaregiverId(caregiver.getId());


        return ResponseEntity.ok(educations);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteExperience(@PathVariable Long id) {
        experienceService.delete(id);
        return ResponseEntity.noContent().build(); // HTTP 204 No Content
    }
}
