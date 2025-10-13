package com.istiaq.daycare.restController;


import com.istiaq.daycare.dto.EducationDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Education;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.EducationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/education/")
public class EducationRestController {


    @Autowired
    private EducationService educationService;

    @Autowired
    private CaregiverService caregiverService;

    @Autowired
    private IUserRepo userRepo;


    @PostMapping("add")
    public ResponseEntity<Education> addEducation(@RequestBody Education education, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Education savedEducation = educationService.saveEducation(education, email);
        return ResponseEntity.ok(savedEducation);
    }

    @GetMapping("all")
    public ResponseEntity<List<EducationDTO>> getEducationsByCaregiver(Authentication authentication) {
        // Get logged-in user email
        String email = authentication.getName();

        Optional<User> user = userRepo.findByEmail(email);
        Caregiver caregiver = caregiverService.getProfileByUserId(user.get().getId());


        List<EducationDTO> educations = educationService.getByCaregiverId(caregiver.getId());


        return ResponseEntity.ok(educations);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteEducation(@PathVariable Long id) {
        educationService.delete(id);
        return ResponseEntity.noContent().build(); // HTTP 204 No Content
    }
}
