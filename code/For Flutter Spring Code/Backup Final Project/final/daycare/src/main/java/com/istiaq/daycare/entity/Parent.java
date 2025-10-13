package com.istiaq.daycare.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
public class Parent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;
    @Column(nullable = false, length = 150)
    private String parentName;

    @Column(length = 50)
    private String contactPerson;

    @Column(length = 100)
    private String email;

    private String password;

    @Column(length = 50)
    private String phone;

    @Column(length = 200)
    private String address;

    @Column(length = 200)
    private String childName;

    private String gender;
    private String photo;

    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Job> jobs = new ArrayList<>();


    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;


    public Parent() {
    }


    public Parent(Long id, String parentName, String contactPerson, String email, String password, String phone, String address, String childName, String gender, String photo, List<Job> jobs, User user) {
        this.id = id;
        this.parentName = parentName;
        this.contactPerson = contactPerson;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.childName = childName;
        this.gender = gender;
        this.photo = photo;
        this.jobs = jobs;
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getChildName() {
        return childName;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public List<Job> getJobs() {
        return jobs;
    }

    public void setJobs(List<Job> jobs) {
        this.jobs = jobs;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
