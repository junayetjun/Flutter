package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.CategoryDTO;
import com.istiaq.daycare.entity.Category;
import com.istiaq.daycare.repository.ICategoryRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {

    @Autowired
    private ICategoryRepo categoryRepo;


    public List<CategoryDTO> getAllCategories() {
        return categoryRepo.findAll()
                .stream()
                .map(CategoryDTO::new)
                .toList();

    }

    public Optional<CategoryDTO> getCategoryById(Long id) {
        return categoryRepo.findById(id)
                .map(CategoryDTO::new);
    }

    public Category createCategory(Category category) {
        return categoryRepo.save(category);
    }

    public Optional<Category> updateCategory(Long id, Category updatedCategory) {
        return categoryRepo.findById(id).map(category -> {
            category.setName(updatedCategory.getName());
            return categoryRepo.save(category);
        });
    }

    public void deleteCategory(Long id) {
        categoryRepo.deleteById(id);
    }

}
