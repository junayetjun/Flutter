import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CaregiverService } from '../../service/caregiver.service';
import { Router } from '@angular/router';
import { Category } from '../../model/category.model';
import { CategoryService } from '../../service/category.service';

@Component({
  selector: 'app-addcaregiver.component',
  standalone: false,
  templateUrl: './addcaregiver.component.html',
  styleUrl: './addcaregiver.component.css'
})
export class AddcaregiverComponent implements OnInit {
  userForm: FormGroup;
  caregiverForm: FormGroup;
  photoFile!: File;
  message: string = '';
  categories: Category[] = [];

  constructor(
    private fb: FormBuilder,
    private caregiverService: CaregiverService,
    private categoryService: CategoryService,
    private cdr: ChangeDetectorRef,
    private router: Router
  ) {
    this.userForm = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', Validators.required],
      password: ['', Validators.required]
    });

    this.caregiverForm = this.fb.group({
      gender: ['', Validators.required],
      address: ['', Validators.required],
      dateOfBirth: ['', Validators.required],
      categoryId: [null, Validators.required]
    });
  }

  ngOnInit(): void {
    this.loadCategories();
  }

  onPhotoSelected(event: any): void {
    if (event.target.files.length > 0) {
      this.photoFile = event.target.files[0];
      console.log('Selected file:', this.photoFile);
    }
  }

  loadCategories() {
    this.categoryService.getAllCategories().subscribe(data => {
      this.categories = data;
      this.cdr.markForCheck();
    });
  }

  onSubmit(): void {
    if (!this.photoFile) {
      this.message = 'Please upload a photo.';
      return;
    }

    if (this.userForm.invalid || this.caregiverForm.invalid) {
      this.message = 'Please fill out all required fields.';
      return;
    }

    const user = {
      name: this.userForm.value.name,
      email: this.userForm.value.email,
      phone: this.userForm.value.phone,
      password: this.userForm.value.password,
      role: 'CAREGIVER'
    };

    const caregiver = {
      name: this.userForm.value.name,
      email: this.userForm.value.email,
      phone: this.userForm.value.phone,
      gender: this.caregiverForm.value.gender,
      address: this.caregiverForm.value.address,
      dateOfBirth: this.caregiverForm.value.dateOfBirth,
      category: {
        id: this.caregiverForm.value.categoryId
      }
    };

    this.caregiverService.registerCaregiver(user, caregiver, this.photoFile).subscribe({
      next: res => {
        this.message = res.Message || 'Registration successful!';
        this.userForm.reset();
        this.caregiverForm.reset();
        this.photoFile = undefined!;
        this.router.navigate(['/mainhome']);
      },
      error: err => {
        this.message = 'Registration failed: ' + (err.error?.Message || err.message);
      }
    });
  }
}
