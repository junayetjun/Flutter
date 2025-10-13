import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ParentService } from '../../service/parent.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-parent-registration',
  standalone: false,
  templateUrl: './parent-registration.html',
  styleUrl: './parent-registration.css'
})
export class ParentRegistration {
  userForm: FormGroup;
  parentForm: FormGroup;
  photoFile!: File;
  message: string = '';

  constructor(private fb: FormBuilder,
    private parentService: ParentService,
    private router: Router
  ) {
    this.userForm = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', Validators.required],
      password: ['', Validators.required]
    });

    this.parentForm = this.fb.group({
      parentName: ['', Validators.required],
      address: ['', Validators.required],
      childName: ['', Validators.required],
      gender: ['', Validators.required]
    });
  }

  onPhotoSelected(event: any): void {
    if (event.target.files.length > 0) {
      this.photoFile = event.target.files[0];
      console.log('Selected file:', this.photoFile);
    }
  }

  onSubmit(): void {
    if (!this.photoFile) {
      this.message = 'Please upload a photo.';
      return;
    }

    if (this.userForm.invalid || this.parentForm.invalid) {
      this.message = 'Please fill out all required fields.';
      return;
    }

    const user = {
      name: this.userForm.value.name,
      email: this.userForm.value.email,
      phone: this.userForm.value.phone,
      password: this.userForm.value.password,
      role: 'PARENT'
    };

    const parent = {
      contactPerson: this.userForm.value.name,
      email: this.userForm.value.email,
      phone: this.userForm.value.phone,
      parentName: this.parentForm.value.parentName,
      address: this.parentForm.value.address,
      childName: this.parentForm.value.childName,
      gender: this.parentForm.value.gender
    };

    this.parentService.registerParent(user, parent, this.photoFile).subscribe({
      next: res => {
        this.message = res.Message || 'Registration successful!';
        this.userForm.reset();
        this.parentForm.reset();
        this.photoFile = undefined!;
        this.router.navigate(['mainhome'])
      },
      error: err => {
        this.message = 'Registration failed: ' + (err.error?.Message || err.message);
      }
    });
  }
}
