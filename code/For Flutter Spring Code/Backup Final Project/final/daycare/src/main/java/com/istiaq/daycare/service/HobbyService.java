package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.HobbyDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Hobby;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.IHobbyRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class HobbyService {
    @Autowired
    private IHobbyRepo hobbyRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;

    public List<HobbyDTO> getByCaregiverId(Long caregiverId) {
        List<Hobby> hobbies = hobbyRepo.findByCaregiverId(caregiverId);
        return hobbies.stream()
                .map(HobbyDTO::new)
                .collect(Collectors.toList());
    }

    public Hobby saveHobby(Hobby hobby, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        hobby.setCaregiver(caregiver);

        return hobbyRepo.save(hobby);
    }

    public void delete(Long id) {
        hobbyRepo.deleteById(id);
    }
}
