import { ChangeDetectorRef, Component } from '@angular/core';
import { Category } from '../../model/category.model';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CategoryService } from '../../service/category.service';

@Component({
  selector: 'app-category.component',
  standalone: false,
  templateUrl: './category.component.html',
  styleUrl: './category.component.css'
})
export class CategoryComponent {


  categories: Category[] = [];
  categoryForm!: FormGroup;
  editMode = false;
  editId?: number;


  constructor(
    private categoryService: CategoryService,
    private fb: FormBuilder,
    private cdr: ChangeDetectorRef
  ) { }


  ngOnInit(): void {
    this.loadCategories();
    this.categoryForm = this.fb.group({
      name: ['', Validators.required]
    });
  }


  loadCategories(): void {
    this.categoryService.getAllCategories().subscribe(data => {
      this.categories = data;
      this.cdr.markForCheck();
    });
  }

  onSubmit(): void {
    if (this.categoryForm.invalid) return;

    const categoryData: Category = this.categoryForm.value;

    if (this.editMode && this.editId !== undefined) {
      this.categoryService.updateCategory(this.editId, categoryData).subscribe(() => {
        this.loadCategories();
        this.resetForm();
        this.cdr.markForCheck();
      });
    } else {
      this.categoryService.createCategory(categoryData).subscribe(() => {
        this.loadCategories();
        this.resetForm();
        this.cdr.markForCheck();
      });
    }
  }

  onEdit(category: Category): void {
    this.editMode = true;
    this.editId = category.id;
    this.categoryForm.patchValue({
      name: category.name
    });
    this.cdr.markForCheck();
  }

  onDelete(id?: number): void {
    if (id && confirm('Are you sure you want to delete this Categories?')) {
      this.categoryService.deleteCategory(id).subscribe(() => {
        this.loadCategories();
        this.cdr.markForCheck();
      });
    }
  }

  resetForm(): void {
    this.editMode = false;
    this.editId = undefined;
    this.categoryForm.reset();
  }
}
