import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../service/auth-service';
import { Router } from '@angular/router';


@Component({
  selector: 'app-login',
  standalone: false,
  templateUrl: './login.html',
  styleUrl: './login.css'
})
export class Login {

   loginForm!: FormGroup;
  errorMessage: string | null = null;
  successMessage: string | null = null;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required]
    });
  }

  onSubmit(): void {
    if (this.loginForm.invalid) {
      return;
    }

    const { email, password } = this.loginForm.value;

    this.authService.login(email, password).subscribe({
  next: (response) => {
    this.successMessage = 'Login successful!';
    this.errorMessage = null;

    const role = this.authService.getUserRole();

    if (role === 'CAREGIVER') {
      this.router.navigate(['/caregiverpro']);
    }
     else if (role === 'PARENT') {
      this.router.navigate(['/parentrofile']);
    }
    else if (role === 'ADMIN'){
      this.router.navigate(['/adminprofile']);
    }

  },
  error: (err) => {
    this.errorMessage = 'Login failed. Please check your credentials.';
    this.successMessage = null;
  }
});

  }

}
