package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.LanguageDTO;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Language;
import com.istiaq.daycare.repository.ICaregiverRepo;
import com.istiaq.daycare.repository.ILanguageRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class LanguageService {

    @Autowired
    private ILanguageRepo languageRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;


    public List<LanguageDTO> getByCaregiverId(Long caregiverId) {
        List<Language> languages = languageRepo.findByCaregiverId(caregiverId);
        return languages.stream()
                .map(LanguageDTO::new)
                .collect(Collectors.toList());
    }

    public Language saveLanguage(Language language, String email) {
        Caregiver caregiver = caregiverRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Caregiver not found"));

        language.setCaregiver(caregiver);

        return languageRepo.save(language);
    }

    public void delete(Long id) {
        languageRepo.deleteById(id);
    }
}
