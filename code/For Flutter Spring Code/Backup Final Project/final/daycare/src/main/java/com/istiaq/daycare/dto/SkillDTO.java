package com.istiaq.daycare.dto;

import com.istiaq.daycare.entity.Skill;

public class SkillDTO {

    private Long id;
    private String name;
    private String level;


    public SkillDTO(Skill skill) {
        this.id = skill.getId();
        this.name = skill.getName();
        this.level = skill.getLevel();
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

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }
}
