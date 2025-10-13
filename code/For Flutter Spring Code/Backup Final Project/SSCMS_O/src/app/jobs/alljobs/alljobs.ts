import { ChangeDetectorRef, Component } from '@angular/core';
import { JobDTO } from '../../model/jobDTO';
import { JobService } from '../../service/job.service';

@Component({
  selector: 'app-alljobs',
  standalone: false,
  templateUrl: './alljobs.html',
  styleUrl: './alljobs.css'
})
export class Alljobs {

  jobs: JobDTO[] = [];

  constructor(private jobService: JobService,
    private cd: ChangeDetectorRef
  ) { }

  // ngOnInit(): void {
  //   this.jobService.getAllJobs().subscribe({
  //     next: (data) => {
  //       this.jobs = data;
  //       console.log(this.jobs);
  //       this.cd.markForCheck();
  //     },
  //     error: (err) => console.error(err)
  //   });
  // }


  ngOnInit(): void {
    this.jobService.getAllJobs().subscribe({
      next: (data) => {
        this.jobs = data;
        console.log("Job list loaded:", this.jobs);

        // Optional: Show first job's location
        if (this.jobs.length > 0) {
          console.log("First job's location:", this.jobs[0].location);
        }

        this.cd.markForCheck();
      },
      error: (err) => console.error(err)
    });
  }
}
