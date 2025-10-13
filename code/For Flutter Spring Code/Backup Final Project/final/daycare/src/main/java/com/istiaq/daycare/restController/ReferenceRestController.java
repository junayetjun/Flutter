package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.ReferenceDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Reference;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.ReferenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reference/")
public class ReferenceRestController {

    @Autowired
    private ReferenceService referenceService;
    @Autowired
    private CaregiverService caregiverService;
    @Autowired
    private IUserRepo userRepo;

    @PostMapping("add")
    public ResponseEntity<Reference> addReference(@RequestBody Reference reference, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Reference savedReference = referenceService.saveReference(reference, email);
        return ResponseEntity.ok(savedReference);
    }

    @GetMapping("all")
    public ResponseEntity<List<ReferenceDTO>> getReferencesByCaregiver(Authentication authentication) {
        String email = authentication.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        Caregiver caregiver = caregiverService.getProfileByUserId(user.getId());

        List<ReferenceDTO> references = referenceService.getByCaregiverId(caregiver.getId());

        return ResponseEntity.ok(references);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteReference(@PathVariable Long id) {
        referenceService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
