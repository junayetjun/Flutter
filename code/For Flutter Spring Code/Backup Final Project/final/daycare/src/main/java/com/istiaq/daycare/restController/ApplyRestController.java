package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.ApplyDTO;
import com.istiaq.daycare.entity.Apply;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Parent;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IParentRepo;
import com.istiaq.daycare.service.ApplyService;
import com.istiaq.daycare.service.CaregiverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/applications")
public class ApplyRestController {

    @Autowired
    private ApplyService applyService;

    @Autowired
    private CaregiverService caregiverService;

    @Autowired
    private ICaregiverRepo caregiverRepo;


    @Autowired
    private IParentRepo parentRepo;


    // ✅ Create a new application
    @PostMapping
    public ResponseEntity<ApplyDTO> createApplication(@RequestBody Apply apply, Authentication authentication) {

        String CaregiverEmail = authentication.getName();

        Caregiver caregiver = caregiverRepo.findByUserEmail(CaregiverEmail)
                .orElseThrow(() -> new RuntimeException("Caregiver Not Found"));


        Apply createdApply = applyService.createApplication(apply, caregiver);

        // Convert to DTO before returning
        ApplyDTO dto = applyService.mapToDTO(createdApply);


        return ResponseEntity.ok(dto);
    }


    // ✅ Get all applications
    @GetMapping
    public ResponseEntity<List<Apply>> getAllApplications() {
        List<Apply> applications = applyService.getAllApplications();
        return ResponseEntity.ok(applications);
    }

    // ✅ Get application by ID
    @GetMapping("{id}")
    public ResponseEntity<Apply> getApplicationById(@PathVariable Long id) {
        Optional<Apply> apply = applyService.getApplicationById(id);
        return apply.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // ✅ Update an application
    @PutMapping("{id}")
    public ResponseEntity<Apply> updateApplication(@PathVariable Long id, @RequestBody Apply updatedApply) {
        try {
            Apply updated = applyService.updateApplication(id, updatedApply);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // ✅ Delete an application
    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteApplication(@PathVariable Long id) {
        applyService.deleteApplication(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("/my")
    public List<ApplyDTO> getMyApplies(Authentication authentication) {
        if (authentication == null) {
            throw new RuntimeException("User not authenticated");
        }

        String username = authentication.getName(); // "rahim@gmail.com"
        System.out.println("Logged in as: " + username);

        Caregiver caregiver = caregiverRepo.findByUserEmail(username)
                .orElseThrow(() -> new RuntimeException("Caregiver not found for user " + username));

        return applyService.getAppliesByCaregiver(caregiver.getId());
    }


    @GetMapping("/applicant/{jobId}")
    public ResponseEntity<List<ApplyDTO>> getApplicationsForJob(
            @PathVariable Long jobId,
            Authentication authentication) {

        if (authentication == null) {
            throw new RuntimeException("User not authenticated");
        }

        String email = authentication.getName();
        Parent parent = parentRepo.findByUserEmail(email)
                .orElseThrow(() -> new RuntimeException("Parent not found"));

        List<ApplyDTO> applications = applyService.getApplicationsByJob(parent.getId(), jobId);
        return ResponseEntity.ok(applications);
    }

}
