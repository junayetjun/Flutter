import { ChangeDetectorRef, Component } from '@angular/core';
import { ParentService } from '../../service/parent.service';
import { FormBuilder } from '@angular/forms';
import { AuthService } from '../../service/auth-service';

@Component({
  selector: 'app-pauserhome',
  standalone: false,
  templateUrl: './pauserhome.html',
  styleUrl: './pauserhome.css'
})
export class Pauserhome {
  parent: any;


  constructor(
    private parentService: ParentService,
    private cdr: ChangeDetectorRef,
    private fb: FormBuilder,
    private authService: AuthService

  ) {
  }

  ngOnInit(): void {
    this.getProfile();

  }

  getProfile() {

    this.parentService.getProfile().subscribe({
      next: (data) => {
        this.parent = data;
        console.log(data);
        this.cdr.markForCheck();

      },
      error: (err) => {
        console.error('Failed to load profile', err);
      }
    });
  }


  onLogout(): void {
    this.authService.logout();
  }

}
