package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.ExtracurricularDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Extracurricular;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.ExtracurricularService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/extracurricular/")
public class ExtracurricularRestController {

    @Autowired
    private ExtracurricularService extracurricularService;
    @Autowired
    private CaregiverService caregiverService;
    @Autowired
    private IUserRepo userRepo;

    @PostMapping("add")
    public ResponseEntity<Extracurricular> addExtracurricular(@RequestBody Extracurricular extracurricular, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Extracurricular savedExtracurricular = extracurricularService.saveExtracurricular(extracurricular, email);
        return ResponseEntity.ok(savedExtracurricular);
    }


    @GetMapping("all")
    public ResponseEntity<List<ExtracurricularDTO>> getEducationsByCaregiver(Authentication authentication) {
        // Get logged-in user email
        String email = authentication.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        Caregiver caregiver = caregiverService.getProfileByUserId(user.getId());


        List<ExtracurricularDTO> extracurriculars = extracurricularService.getByCaregiverId(caregiver.getId());


        return ResponseEntity.ok(extracurriculars);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteExperience(@PathVariable Long id) {
        extracurricularService.delete(id);
        return ResponseEntity.noContent().build(); // HTTP 204 No Content
    }
}
