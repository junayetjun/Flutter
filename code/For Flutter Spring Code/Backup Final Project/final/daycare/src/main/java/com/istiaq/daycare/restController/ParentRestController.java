package com.istiaq.daycare.restController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.istiaq.daycare.entity.Parent;
import com.istiaq.daycare.entity.User;
import com.istiaq.daycare.repository.IParentRepo;
import com.istiaq.daycare.repository.IUserRepo;
import com.istiaq.daycare.service.AuthService;
import com.istiaq.daycare.service.ParentService;
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

@CrossOrigin("*")
@RestController
@RequestMapping("/api/parent/")
public class ParentRestController {

    @Autowired
    private AuthService authService;

    @Autowired
    private IParentRepo parentRepo;

    @Autowired
    private IUserRepo userRepo;

    @Autowired
    private ParentService parentService;


    @PostMapping("")
    public ResponseEntity<Map<String, String>> registerParent(
            @RequestPart(value = "user") String userJson,
            @RequestPart(value = "parent") String parentJson,
            @RequestParam(value = "photo") MultipartFile file
    ) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.readValue(userJson, User.class);
        Parent parent = objectMapper.readValue(parentJson, Parent.class);

        try {
            authService.registerParent(user, file, parent);
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
    public ResponseEntity<List<Parent>> getAllUsers() {
        List<Parent> parentList = parentService.getAll();
        return ResponseEntity.ok(parentList);

    }


    @GetMapping("profile")
    public ResponseEntity<?> getProfile(Authentication authentication) {
        System.out.println("Authenticated User: " + authentication.getName());
        System.out.println("Authorities: " + authentication.getAuthorities());
        String email = authentication.getName();
        Optional<User> user =userRepo.findByEmail(email);
        Parent parent = parentService.getProfileByUserId(user.get().getId());
        return ResponseEntity.ok(parent);

    }
}
