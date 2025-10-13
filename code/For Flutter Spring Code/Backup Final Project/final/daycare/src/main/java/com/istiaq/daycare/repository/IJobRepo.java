package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Job;
import com.istiaq.daycare.entity.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IJobRepo extends JpaRepository<Job, Long> {

    List<Job> findByParentId(long parentId);

    // Find all jobs by Parent
    List<Job> findByParent(Parent parent);


    @Query("SELECT j FROM Job j WHERE " +
            "(:categoryId IS NULL OR j.category.id = :categoryId) AND " +
            "(:locationId IS NULL OR j.location.id = :locationId)")
    List<Job> filterJobs(
            @Param("categoryId") Long categoryId,
            @Param("locationId") Long locationId
    );


    List<Job> findByLocationId(Long locationId);

    List<Job> findByCategoryId(Long categoryId);

    List<Job> findByLocationIdAndCategoryId(Long locationId, Long categoryId);
}
