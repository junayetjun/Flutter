package com.istiaq.daycare.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @OneToMany(mappedBy = "category")
    private List<Job> jobs = new ArrayList<>();

    @OneToMany(mappedBy = "category")
    @JsonIgnore
    private List<Caregiver> caregivers = new ArrayList<>();


    public Category() {
    }


    public Category(Long id, String name, List<Job> jobs, List<Caregiver> caregivers) {
        this.id = id;
        this.name = name;
        this.jobs = jobs;
        this.caregivers = caregivers;
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

    public List<Job> getJobs() {
        return jobs;
    }

    public void setJobs(List<Job> jobs) {
        this.jobs = jobs;
    }

    public List<Caregiver> getCaregivers() {
        return caregivers;
    }

    public void setCaregivers(List<Caregiver> caregivers) {
        this.caregivers = caregivers;
    }
}
