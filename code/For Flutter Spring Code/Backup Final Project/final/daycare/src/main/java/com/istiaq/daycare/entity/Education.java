package com.istiaq.daycare.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
public class Education {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String level;
    private String institute;
    private String board;
    private String result;
    private String year;


    @ManyToOne
    @JoinColumn(name = "caregiver_id")
    @JsonBackReference
    private Caregiver caregiver;

    public Education() {
    }

    public Education(Long id, String level, String institute, String board, String result, String year, Caregiver caregiver) {
        this.id = id;
        this.level = level;
        this.institute = institute;
        this.board = board;
        this.result = result;
        this.year = year;
        this.caregiver = caregiver;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getInstitute() {
        return institute;
    }

    public void setInstitute(String institute) {
        this.institute = institute;
    }

    public String getBoard() {
        return board;
    }

    public void setBoard(String board) {
        this.board = board;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public Caregiver getCaregiver() {
        return caregiver;
    }

    public void setCaregiver(Caregiver caregiver) {
        this.caregiver = caregiver;
    }
}
