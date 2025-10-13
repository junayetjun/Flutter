import { ChangeDetectorRef, Component } from '@angular/core';
import { Category } from '../../model/category.model';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CategoryService } from '../../service/category.service';

@Component({
  selector: 'app-addcategory',
  standalone: false,
  templateUrl: './addcategory.html',
  styleUrl: './addcategory.css'
})
export class Addcategory {

   categories: Category[] = [];
  categoryForm: FormGroup;
  editMode: boolean = false;
  selectedCategoryId: number | null = null;


  constructor(
    private fb: FormBuilder,
    private categoryService: CategoryService,
    private cd: ChangeDetectorRef
  ) {
    this.categoryForm = this.fb.group({
      name: ['', Validators.required]
    });
  }


   ngOnInit(): void {
    this.loadCategories();
  }

  loadCategories(): void {
    this.categoryService.getAllCategories().subscribe({
      next: (data) => {
        this.categories = data;
        this.cd.markForCheck();
      },
      error: (err) => console.error('Error loading categories', err)
    });
  }

  onSubmit(): void {
    if (this.categoryForm.invalid) return;

    const category: Category = this.categoryForm.value;

    if (this.editMode && this.selectedCategoryId) {
      this.categoryService.updateCategory(this.selectedCategoryId, category).subscribe({
        next: () => {
          this.loadCategories();
          this.resetForm();
        },
        error: (err) => console.error('Error updating category', err)
      });
    } else {
      this.categoryService.createCategory(category).subscribe({
        next: () => {
          this.loadCategories();
          this.resetForm();
        },
        error: (err) => console.error('Error creating category', err)
      });
    }
  }

  editCategory(category: Category): void {
    this.editMode = true;
    this.selectedCategoryId = category.id!;
    this.categoryForm.patchValue({ name: category.name });
  }

  deleteCategory(id: number): void {
    if (confirm('Are you sure you want to delete this category?')) {
      this.categoryService.deleteCategory(id).subscribe({
        next: () => this.loadCategories(),
        error: (err) => console.error('Error deleting category', err)
      });
    }
  }

  resetForm(): void {
    this.categoryForm.reset();
    this.editMode = false;
    this.selectedCategoryId = null;
  }
}
