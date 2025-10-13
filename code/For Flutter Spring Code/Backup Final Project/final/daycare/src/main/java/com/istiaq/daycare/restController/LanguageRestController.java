package com.istiaq.daycare.restController;

import com.istiaq.daycare.dto.LanguageDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Language;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.CaregiverService;
import com.istiaq.daycare.service.LanguageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/language/")
public class LanguageRestController {

    @Autowired
    private LanguageService languageService;
    @Autowired
    private CaregiverService caregiverService;
    @Autowired
    private IUserRepo userRepo;


    @PostMapping("add")
    public ResponseEntity<Language> addLanguage(@RequestBody Language language, Authentication authentication) {
        String email = authentication.getName();  // Logged-in user's email
        Language savedLanguage = languageService.saveLanguage(language, email);
        return ResponseEntity.ok(savedLanguage);
    }

    @GetMapping("all")
    public ResponseEntity<List<LanguageDTO>> getLanguagesByCaregiver(Authentication authentication) {
        String email = authentication.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        Caregiver caregiver = caregiverService.getProfileByUserId(user.getId());

        List<LanguageDTO> languages = languageService.getByCaregiverId(caregiver.getId());

        return ResponseEntity.ok(languages);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteLanguage(@PathVariable Long id) {
        languageService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
