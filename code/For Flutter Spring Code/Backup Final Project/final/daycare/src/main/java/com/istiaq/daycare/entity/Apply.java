package com.istiaq.daycare.entity;

import jakarta.persistence.*;

@Entity
public class Apply {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "jobs_id", nullable = false)
    private Job job;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "caregiver_Id", nullable = false)
    private Caregiver caregiver;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "parent_Id", nullable = false)
    private Parent parent;

    public Apply() {
    }


    public Apply(Long id, Job job, Caregiver caregiver, Parent parent) {
        this.id = id;
        this.job = job;
        this.caregiver = caregiver;
        this.parent = parent;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }

    public Caregiver getCaregiver() {
        return caregiver;
    }

    public void setCaregiver(Caregiver caregiver) {
        this.caregiver = caregiver;
    }

    public Parent getParent() {
        return parent;
    }

    public void setParent(Parent parent) {
        this.parent = parent;
    }
}
