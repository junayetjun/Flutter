import { ChangeDetectorRef, Component } from '@angular/core';
import { JobDTO } from '../../model/jobDTO';
import { ActivatedRoute } from '@angular/router';
import { JobService } from '../../service/job.service';
import { ApplyService } from '../../service/apply.service';

@Component({
  selector: 'app-job-details.component',
  standalone: false,
  templateUrl: './job-details.component.html',
  styleUrl: './job-details.component.css'
})
export class JobDetailsComponent {

  job: JobDTO | null = null;

  constructor(
    private route: ActivatedRoute,
    private jobService: JobService,
    private cd: ChangeDetectorRef,
    private applyService: ApplyService
  ) { }

  ngOnInit(): void {
    const jobId = Number(this.route.snapshot.paramMap.get('id'));
    this.jobService.getJobById(jobId).subscribe({
      next: data => {
        this.job = data;
        console.log(data);
        this.cd.markForCheck();
      },
      error: err => console.error(err)
    });
  }

  onLogoError(event: any) {
    event.target.src = 'assets/default-parent.png'; // fallback image path
  }

  applyJob(jobId: number, parentId: number) {
    const applyPayload = {
      job: { id: jobId },
      parent: { id: parentId }
    };

    this.applyService.applyForJob(applyPayload).subscribe({
      next: (res) => {
        console.log('Application successful:', res);
        alert('You have successfully applied for this application!');
      },
      error: (err) => {
        console.error('Application failed:', err);
        alert('Failed to apply. Please login first.');
      }
    });
  }
}
