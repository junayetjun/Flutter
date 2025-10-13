package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.JobDTO;
import com.istiaq.daycare.entity.Category;
import com.istiaq.daycare.entity.Job;
import com.istiaq.daycare.entity.Location;
import com.istiaq.daycare.entity.Parent;
import com.istiaq.daycare.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class JobService {

    @Autowired
    private IJobRepo jobRepo;


    @Autowired
    private ILocationRepo locationRepo;

    @Autowired
    private ICategoryRepo categoryRepo;

    @Autowired
    private IParentRepo parentRepo;

    @Autowired
    private ICaregiverRepo caregiverRepo;


    public List<JobDTO> getJobsByParentEmail(String email) {
        Parent parent = parentRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Parent not found"));

        List<Job> jobs = jobRepo.findByParent(parent);

        return jobs.stream()
                .map(JobDTO::new)
                .collect(Collectors.toList());
    }


    public Job saveJob(Job job, String email) {
        Parent parent = parentRepo.findByUserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Parent not found"));

        job.setParent(parent);

        Location location = locationRepo.findById(job.getLocation().getId())
                .orElseThrow(() -> new UsernameNotFoundException("Location not found"));

        Category category = categoryRepo.findById(job.getCategory().getId())
                .orElseThrow(() -> new UsernameNotFoundException("Category not found"));

        return jobRepo.save(job);
    }


    public void delete(Long id) {
        jobRepo.deleteById(id);
    }


    public List<JobDTO> getJobs() {
        List<Job> jobs = jobRepo.findAll(); // fetch all Job entities
        return jobs.stream()                     // create a Stream<Job>
                .map(JobDTO::new)            // convert each Job to JobDTO via constructor
                .collect(Collectors.toList());// collect back to a List<JobDTO>
    }


    public JobDTO getJobById(Long id) {
        Optional<Job> jobOpt = jobRepo.findById(id);
        if (jobOpt.isPresent()) {
            return new JobDTO(jobOpt.get()); // convert Job entity to JobDTO
        } else {
            return null; // or throw an exception if you prefer
        }
    }


    public List<JobDTO> searchJobs(Long locationId, Long categoryId) {
        List<Job> jobs;

        if (locationId != null && categoryId != null) {
            jobs = jobRepo.findByLocationIdAndCategoryId(locationId, categoryId);
        } else if (locationId != null) {
            jobs = jobRepo.findByLocationId(locationId);
        } else if (categoryId != null) {
            jobs = jobRepo.findByCategoryId(categoryId);
        } else {
            jobs = jobRepo.findAll();
        }

        return jobs.stream().map(JobDTO::new).toList();
    }


}
