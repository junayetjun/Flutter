package com.istiaq.daycare.restController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.AuthService;
import com.istiaq.daycare.service.CaregiverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/caregiver/")
public class CaregiverRestController {

    @Autowired
    private AuthService authService;

    @Autowired
    private ICaregiverRepo caregiverRepo;

    @Autowired
    private IUserRepo userRepo;

    @Autowired
    private CaregiverService caregiverService;


    @PostMapping("")
    public ResponseEntity<Map<String, String>> registerCaregiver(
            @RequestPart(value = "user") String userJson,
            @RequestPart(value = "caregiver") String caregiverJson,
            @RequestParam(value = "photo") MultipartFile file
    ) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.readValue(userJson, User.class);
        Caregiver caregiver = objectMapper.readValue(caregiverJson, Caregiver.class);

        try {
            authService.registerCaregiver(user, file, caregiver);
            Map<String, String> response = new HashMap<>();
            response.put("Message", "User Added Successfully ");

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {

            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("Message", "User Add Failed " + e);
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }

    }

    @GetMapping("all")
    public ResponseEntity<List<Caregiver>> getAllUsers() {
        List<Caregiver> caregiverList = caregiverService.getAll();
        return ResponseEntity.ok(caregiverList);

    }


    @GetMapping("profile")
    public ResponseEntity<?> getProfile(Authentication authentication) {
        System.out.println("Authenticated User: " + authentication.getName());
        System.out.println("Authorities: " + authentication.getAuthorities());
        String email = authentication.getName();
        Optional<User> user = userRepo.findByEmail(email);
        Caregiver caregiver = caregiverService.getProfileByUserId(user.get().getId());
        return ResponseEntity.ok(caregiver);

    }
}
