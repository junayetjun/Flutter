package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.ApplyDTO;
import com.istiaq.daycare.entity.Apply;
import com.istiaq.daycare.entity.Caregiver;
import com.istiaq.daycare.entity.Job;
import com.istiaq.daycare.entity.Parent;
import com.istiaq.daycare.repository.IApplyRepo;
import com.istiaq.daycare.repository.IJobRepo;
import com.istiaq.daycare.repository.IParentRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ApplyService {

    @Autowired
    IApplyRepo applyRepo;

    @Autowired
    private IJobRepo jobRepo;

    @Autowired
    private IParentRepo parentRepo;


    public Apply createApplication(Apply apply, Caregiver caregiver) {


        Job job = jobRepo.findById(apply.getJob().getId())
                .orElseThrow(() -> new RuntimeException("Job Not Found"));

        Parent parent = parentRepo.findById(apply.getParent().getId())
                .orElseThrow(() -> new RuntimeException("Parent Not Found"));

        apply.setJob(job);
        apply.setParent(parent);

        apply.setCaregiver(caregiver);

        return applyRepo.save(apply);
    }


    // Get all applications
    public List<Apply> getAllApplications() {
        return applyRepo.findAll();
    }

    // Get application by ID
    public Optional<Apply> getApplicationById(Long id) {
        return applyRepo.findById(id);
    }

    // Update an application
    public Apply updateApplication(Long id, Apply updatedApply) {
        return applyRepo.findById(id)
                .map(existingApply -> {
                    existingApply.setJob(updatedApply.getJob());
                    existingApply.setCaregiver(updatedApply.getCaregiver());
                    existingApply.setParent(updatedApply.getParent());
                    return applyRepo.save(existingApply);
                })
                .orElseThrow(() -> new RuntimeException("Application not found with ID: " + id));
    }

    // Delete an application
    public void deleteApplication(Long id) {
        applyRepo.deleteById(id);
    }


    public ApplyDTO mapToDTO(Apply apply) {
        return new ApplyDTO(
                apply.getId(),
                apply.getJob().getId(),
                apply.getJob().getTitle(),
                apply.getParent().getId(),
                apply.getParent().getParentName(),
                apply.getCaregiver().getId(),
                apply.getCaregiver().getName()
        );
    }


    public List<ApplyDTO> getAppliesByCaregiver(Long caregiverId) {
        return applyRepo.findByCaregiver_Id(caregiverId)
                .stream()
                .map(apply -> new ApplyDTO(
                        apply.getId(),
                        apply.getJob().getId(),
                        apply.getJob().getTitle(),
                        apply.getParent().getId(),
                        apply.getParent().getParentName(),
                        apply.getCaregiver().getId(),
                        apply.getCaregiver().getName()
                ))
                .collect(Collectors.toList());
    }


    public List<ApplyDTO> getApplicationsByJob(Long parentId, Long jobId) {
        List<Apply> applies = applyRepo.findAllByParentAndJob(parentId, jobId);
        return applies.stream().map(this::mapToDTO).collect(Collectors.toList());
    }
}
