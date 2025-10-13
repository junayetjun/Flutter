import { ChangeDetectorRef, Component } from '@angular/core';
import { ParentService } from '../../service/parent.service';
import { AuthService } from '../../service/auth-service';
import { Router } from '@angular/router';
import { FormBuilder } from '@angular/forms';
import { JobDTO } from '../../model/jobDTO';
import { JobService } from '../../service/job.service';

@Component({
  selector: 'app-profilecomponent',
  standalone: false,
  templateUrl: './profilecomponent.html',
  styleUrl: './profilecomponent.css'
})
export class Profilecomponent {


  jobs: JobDTO[] = [];
  loading = true;
  errorMsg: string | null = null;

  parent: any;


  constructor(
    private parentService: ParentService,
    private cdr: ChangeDetectorRef,
    private fb: FormBuilder,
    private authService: AuthService,
    private jobService: JobService,


  ) {
  }

  ngOnInit(): void {
    this.getProfile();
    this.fetchMyJobs();

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

  fetchMyJobs(): void {
    this.jobService.getMyJobs().subscribe({
      next: (data) => {
        this.jobs = data;
        this.cdr.markForCheck();
        this.loading = false;
      },
      error: (err) => {
        console.error(err);
        this.errorMsg = 'Failed to load jobs.';
        this.loading = false;
      }
    });
  }

}
