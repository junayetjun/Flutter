import { ChangeDetectorRef, Component } from '@angular/core';
import { ApplyDTO } from '../../model/applyDTO';
import { ApplyService } from '../../service/apply.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-parentjobapplication',
  standalone: false,
  templateUrl: './parentjobapplication.html',
  styleUrl: './parentjobapplication.css'
})
export class Parentjobapplication {

  applications: ApplyDTO[] = [];
  loading = false;
  errorMessage = '';

  jobId!: number;

  constructor(
    private applyService: ApplyService,
    private route: ActivatedRoute,
    private cd: ChangeDetectorRef,
    private ar: Router

  ) { }

  ngOnInit(): void {
    const paramJobId = this.route.snapshot.paramMap.get('id');
    if (paramJobId) {
      this.jobId = Number(paramJobId);
      this.fetchApplications();
    } else {
      this.errorMessage = 'Job ID not provided';
    }
  }

  fetchApplications(): void {
    this.loading = true;
    this.applyService.getApplicationsForJob(this.jobId).subscribe({
      next: (data) => {
        this.applications = data;
        this.cd.markForCheck();
        console.log(this.applications);
        this.loading = false;
      },
      error: (err) => {
        console.error(err);
        this.errorMessage = 'Failed to load applications';
        this.loading = false;
      }
    });
  }

  viewDetails(id: number){
    console.log(id);
    this.ar.navigate(['/cdetails', id])
  }


}
