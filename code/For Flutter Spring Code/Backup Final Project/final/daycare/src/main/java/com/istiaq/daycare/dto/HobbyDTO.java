package com.istiaq.daycare.dto;

import com.istiaq.daycare.entity.Hobby;

public class HobbyDTO {

    private Long id;
    private String name;

    public HobbyDTO(Hobby hobby) {
        this.id = hobby.getId();
        this.name = hobby.getName();

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
}
