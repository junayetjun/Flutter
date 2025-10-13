package com.istiaq.daycare.dto;

import com.istiaq.daycare.entity.Reference;

public class ReferenceDTO {

    private Long id;
    private String name;
    private String contact;
    private String relation;

    public ReferenceDTO(Reference refference) {
        this.id = refference.getId();
        this.name = refference.getName();
        this.contact = refference.getContact();
        this.relation = refference.getRelation();
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

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getRelation() {
        return relation;
    }

    public void setRelation(String relation) {
        this.relation = relation;
    }
}
