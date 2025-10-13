import { ChangeDetectorRef, Component } from '@angular/core';
import { JobDTO } from '../../model/jobDTO';
import { JobService } from '../../service/job.service';

@Component({
  selector: 'app-mypost',
  standalone: false,
  templateUrl: './mypost.html',
  styleUrl: './mypost.css'
})
export class Mypost {


   jobs: JobDTO[] = [];
  loading = true;
  errorMsg: string | null = null;

  constructor(
    private jobService: JobService,
     private cd: ChangeDetectorRef
    ) { }


  ngOnInit(): void {
    this.fetchMyJobs();
  }

  fetchMyJobs(): void {
    this.jobService.getMyJobs().subscribe({
      next: (data) => {
        this.jobs = data;
        this.cd.markForCheck();
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
