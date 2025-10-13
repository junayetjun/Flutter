package com.istiaq.daycare.dto;

import com.istiaq.daycare.entity.Extracurricular;

public class ExtracurricularDTO {

    private Long id;
    private String title;
    private String role;
    private String description;

    public ExtracurricularDTO(Extracurricular extracurricular) {
        this.id = extracurricular.getId();
        this.title = extracurricular.getTitle();
        this.role = extracurricular.getRole();
        this.description = extracurricular.getDescription();

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
