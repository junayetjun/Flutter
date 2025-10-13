package com.istiaq.daycare.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.sql.Date;
import java.util.List;

@Entity
public class Caregiver {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;
    private String phone;
    private String gender;
    private String address;
    private Date dateOfBirth;
    private String photo;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "category_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "jobs"})
    private Category category;

//    @OneToMany(mappedBy = "caregiver", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private List<Education> educations;
//
//
//    @OneToMany(mappedBy = "caregiver", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private List<Reference> references;
//
//    @OneToMany(mappedBy = "caregiver", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private List<Experience> experiences;
//
//    @OneToMany(mappedBy = "caregiver", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private List<Hobby> hobbies;
//
//    @OneToMany(mappedBy = "caregiver", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private List<Language> languages;
//
//    @OneToMany(mappedBy = "caregiver", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private List<Skill> skills;



    public Caregiver() {
    }

    public Caregiver(Long id, String name, String email, String phone, String gender, String address, Date dateOfBirth, String photo, User user, Category category) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.photo = photo;
        this.user = user;
        this.category = category;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }


}
