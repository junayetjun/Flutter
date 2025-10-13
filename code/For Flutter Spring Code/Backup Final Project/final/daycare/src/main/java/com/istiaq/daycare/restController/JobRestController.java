package com.istiaq.daycare.restController;


import com.istiaq.daycare.dto.JobDTO;
import com.istiaq.daycare.entity.Job;
import com.istiaq.daycare.repository.IJobRepo;
import com.istiaq.daycare.service.JobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/jobs/")
public class JobRestController {

    @Autowired
    private JobService jobService;

    @Autowired
    private IJobRepo jobRepo;

    @PostMapping
    public ResponseEntity<Job> createJob(@RequestBody Job job, Authentication authentication) {
        String email = authentication.getName(); // Get logged-in user's email
        Job savedJob = jobService.saveJob(job, email);
        return ResponseEntity.ok(savedJob);
    }

    // Get all jobs posted by an Parent

    @GetMapping("my-jobs")
    public List<JobDTO> getJobsForLoggedInParent(Authentication authentication) {

        // Get username (email) from Authentication
        String email = authentication.getName();

        return jobService.getJobsByParentEmail(email);
    }


    // Delete a job by ID
    @DeleteMapping("/{jobId}")
    public ResponseEntity<Void> deleteJob(@PathVariable Long jobId) {
        jobService.delete(jobId);
        return ResponseEntity.noContent().build();
    }


    // GET all jobs
    @GetMapping
    public ResponseEntity<List<JobDTO>> getAllJobs() {
        List<JobDTO> jobs = jobService.getJobs();
        if (jobs.isEmpty()) {
            return ResponseEntity.noContent().build(); // 204 No Content if empty
        }
        return ResponseEntity.ok(jobs); // 200 OK with jobs list
    }


    @GetMapping("{id}")
    public ResponseEntity<JobDTO> getJobById(@PathVariable Long id) {
        JobDTO job = jobService.getJobById(id);
        if (job == null) {
            return ResponseEntity.notFound().build(); // 404 if not found
        }
        return ResponseEntity.ok(job); // 200 with job data
    }

    @GetMapping("search")
    public List<JobDTO> searchJobs(
            @RequestParam(required = false) Long locationId,
            @RequestParam(required = false) Long categoryId) {
        return jobService.searchJobs(locationId, categoryId);
    }


}
