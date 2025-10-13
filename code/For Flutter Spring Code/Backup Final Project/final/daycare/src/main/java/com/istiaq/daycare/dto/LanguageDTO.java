package com.istiaq.daycare.dto;

import com.istiaq.daycare.entity.Language;

public class LanguageDTO {

    private Long id;
    private String name;
    private String proficiency;

    public LanguageDTO(Language language) {
        this.id = language.getId();
        this.name = language.getName();
        this.proficiency = language.getProficiency();

    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProficiency() {
        return proficiency;
    }

    public void setProficiency(String proficiency) {
        this.proficiency = proficiency;
    }
}
