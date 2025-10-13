package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.HobbyDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Hobby;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.HobbyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hobby/")
public class HobbyRestController {

    @Autowired
    private HobbyService hobbyService;
    @Autowired
    private CaregiverService caregiverService;
    @Autowired
    private IUserRepo userRepo;

    @PostMapping("add")
    public ResponseEntity<Hobby> addHobby(@RequestBody Hobby hobby, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Hobby savedHobby = hobbyService.saveHobby(hobby, email);
        return ResponseEntity.ok(savedHobby);
    }

    @GetMapping("all")
    public ResponseEntity<List<HobbyDTO>> getHobbiesByCaregiver(Authentication authentication) {
        String email = authentication.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        Caregiver caregiver = caregiverService.getProfileByUserId(user.getId());

        List<HobbyDTO> hobbies = hobbyService.getByCaregiverId(caregiver.getId());

        return ResponseEntity.ok(hobbies);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteHobby(@PathVariable Long id) {
        hobbyService.delete(id);
        return ResponseEntity.noContent().build(); // HTTP 204 No Content
    }
}
