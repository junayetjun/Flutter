package com.istiaq.daycare.service;

import com.istiaq.daycare.entity.Parent;
import com.istiaq.daycare.jwt.JwtService;
import com.istiaq.daycare.repository.IParentRepo;
import com.istiaq.daycare.repository.ITokenRepo;
import com.istiaq.daycare.repository.IUserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ParentService {

    @Autowired
    private IParentRepo parentRepo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private IUserRepo userRepo;
    @Autowired
    private ITokenRepo tokenRepo;

//    @Autowired
//    private EmailService emailService;

    @Autowired
    private CaregiverService caregiverService;

    @Autowired
    private JwtService jwtService;

    @Autowired
    @Lazy
    private AuthenticationManager authenticationManager;

    @Value("src/main/resources/static/images")
    private String uploadDir;


    public List<Parent> getAll() {

        return parentRepo.findAll();
    }

    public Optional<Parent> getById(Long id) {

        return parentRepo.findById(id);
    }

    public Parent save(Parent parent) {

        return parentRepo.save(parent);
    }

    public void delete(Long id) {

        parentRepo.deleteById(id);

    }

    public Parent getProfileByUserId(int userId) {
        return parentRepo.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Parent not found"));
    }
}
