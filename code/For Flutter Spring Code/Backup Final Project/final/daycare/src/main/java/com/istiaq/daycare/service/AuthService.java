package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.AuthenticationResponse;
import com.istiaq.daycare.entity.*;
import com.istiaq.daycare.jwt.JwtService;
import com.istiaq.daycare.repository.ITokenRepo;
import com.istiaq.daycare.repository.IUserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class AuthService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private IUserRepo userRepo;

    @Autowired
    private ITokenRepo tokenRepo;

    @Autowired
    private CaregiverService caregiverService;

    @Autowired
    private ParentService parentService;

    @Autowired
    private JwtService jwtService;

    @Autowired
    @Lazy
    private AuthenticationManager authenticationManager;

    @Value("src/main/resources/static/images")
    private String uploadDir;


    public void saveOrUpdate(User user, MultipartFile imageFile) {
        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = saveImage(imageFile, user);
            user.setPhoto(filename);
        }


        user.setRole(Role.ADMIN);
        userRepo.save(user);
        //sendActivationEmail(user);
    }

    public List<User> findAll() {
        return userRepo.findAll();
    }

    public User findById(int id) {
        return userRepo.findById(id).get();
    }

    public void delete(User user) {
        userRepo.delete(user);
    }


    // for User folder (for caregiver)
    public String saveImage(MultipartFile file, User user) {

        Path uploadPath = Paths.get(uploadDir + "/user");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectories(uploadPath);  // change here
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        String fileName = user.getName() + "_" + UUID.randomUUID().toString();
        try {
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return fileName;
    }

    private void saveUserToken(String jwt, User user) {
        Token token = new Token();
        token.setToken(jwt);
        token.setLogout(false);
        token.setUser(user);

        tokenRepo.save(token);

    }

    private void removeAllTokenByUser(User user) {

        List<Token> validTokens = tokenRepo.findAllTokenByUser(user.getId());

        if (validTokens.isEmpty()) {
            return;
        }
        validTokens.forEach(t -> {
            t.setLogout(true);
        });

        tokenRepo.saveAll(validTokens);

    }


    // It is Login Method
    public AuthenticationResponse authenticate(User request) {
        // Authenticate Username & Password
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        // Fetch User from DB
        User user = userRepo.findByEmail(request.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        // Check Activation Status
        if (!user.isActive()) {
            throw new RuntimeException("Account is not activated. Please check your email for activation link.");
        }

        // Generate JWT Token
        String jwt = jwtService.generateToken(user);

        // Remove Existing Tokens (Invalidate Old Sessions)
        removeAllTokenByUser(user);

        // Save New Token to DB (Optional if stateless)
        saveUserToken(jwt, user);

        // Return Authentication Response
        return new AuthenticationResponse(jwt, "User Login Successful");
    }

    public String activeUser(int id) {

        User user = userRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("User not Found with this ID " + id));

        if (user != null) {
            user.setActive(true);

            userRepo.save(user);
            return "User Activated Successfully!";

        } else {
            return "Invalid Activation Token!";
        }

    }

    public String saveImageForCaregiver(MultipartFile file, Caregiver caregiver) {

        Path uploadPath = Paths.get(uploadDir + "/caregiver");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectory(uploadPath);

            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        String caregiverName = caregiver.getName();
        String fileName = caregiverName.trim().replaceAll("\\s+", "_");

        String savedFileName = fileName + "_" + UUID.randomUUID().toString();

        try {
            Path filePath = uploadPath.resolve(savedFileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return savedFileName;

    }


    public void registerCaregiver(User user, MultipartFile imageFile, Caregiver caregiverData) {
        if (imageFile != null && !imageFile.isEmpty()) {
            // Save image for both User and JobSeeker
            String filename = saveImage(imageFile, user);
            String caregiverPhoto = saveImageForCaregiver(imageFile, caregiverData);
            caregiverData.setPhoto(caregiverPhoto);
            user.setPhoto(filename);
        }

        // Encode password before saving User
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.CAREGIVER);
        user.setActive(true);

        // Save User FIRST and get persisted instance
        User savedUser = userRepo.save(user);

        // Now, associate saved User with JobSeeker and save JobSeeker
        caregiverData.setUser(savedUser);
        caregiverService.save(caregiverData);
        // jobSeeker close

    }

    //for Parent

    public String saveImageForParent(MultipartFile file, Parent parent) {
        Path uploadPath = Paths.get(uploadDir + "/parent");
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectories(uploadPath);
            } catch (IOException e) {
                throw new RuntimeException("Could not create directory: " + uploadPath, e);
            }
        }

        String parentName = parent.getParentName(); // or getName() if exists
        String fileName = parentName.trim().replaceAll("\\s+", "_");
        String savedFileName = fileName + "_" + UUID.randomUUID() + ".png"; // optional extension

        try {
            Path filePath = uploadPath.resolve(savedFileName);
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            throw new RuntimeException("Could not save file: " + savedFileName, e);
        }
        return savedFileName;
    }

    public void registerParent(User user, MultipartFile imageFile, Parent parentData) {
        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = saveImage(imageFile, user); // Save for User
            String parentPhoto = saveImageForParent(imageFile, parentData); // Save for Parent

            user.setPhoto(filename);
            parentData.setPhoto(parentPhoto);
        }

        // Encode password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.PARENT); // ✅ Correct role for Employer
        user.setActive(true);

        // Save User first
        User savedUser = userRepo.save(user);

        // Associate Employer with User
        parentData.setUser(savedUser);
        parentService.save(parentData);
        //parent close

        // Now generate token and save Token associated with savedUser
        String jwt = jwtService.generateToken(savedUser);
        saveUserToken(jwt, savedUser);

        // Send Activation Email
//        sendActivationEmail(savedUser);
    }

}
