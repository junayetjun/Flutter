package com.istiaq.daycare.repository;

import com.istiaq.daycare.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ICategoryRepo extends JpaRepository<Category, Long> {

    @Query("SELECT c.name AS name, COUNT(j.id) AS count FROM Category c LEFT JOIN Job j ON c.id = j.category.id GROUP BY c.name")
    List<Map<String, Object>> findCategoryCounts();
}
