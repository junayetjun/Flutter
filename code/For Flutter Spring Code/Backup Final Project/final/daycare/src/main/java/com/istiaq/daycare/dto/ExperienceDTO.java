package com.istiaq.daycare.dto;

import com.istiaq.daycare.entity.Experience;

import java.time.LocalDate;

public class ExperienceDTO {
    private Long id;
    private String company;
    private String position;
    private LocalDate fromDate;
    private LocalDate toDate;
    private String description;


    public ExperienceDTO(Experience experience) {

        this.id = experience.getId();
        this.company = experience.getCompany();
        this.position = experience.getPosition();
        this.fromDate = experience.getFromDate();
        this.toDate = experience.getToDate();
        this.description = experience.getDescription();

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public LocalDate getFromDate() {
        return fromDate;
    }

    public void setFromDate(LocalDate fromDate) {
        this.fromDate = fromDate;
    }

    public LocalDate getToDate() {
        return toDate;
    }

    public void setToDate(LocalDate toDate) {
        this.toDate = toDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
