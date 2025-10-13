import { ChangeDetectorRef, Component, Inject, PLATFORM_ID } from '@angular/core';
import { ApplyDTO } from '../../model/applyDTO';
import { ApplyService } from '../../service/apply.service';

@Component({
  selector: 'app-applied-jobs',
  standalone: false,
  templateUrl: './applied-jobs.html',
  styleUrl: './applied-jobs.css'
})
export class AppliedJobs {

  applications: ApplyDTO[] = [];

  constructor(
    private applyService: ApplyService,
    @Inject(PLATFORM_ID) private platformId: Object,
    private cd: ChangeDetectorRef
  ) { }

  ngOnInit(): void {
    this.loadApplications();
  }

  loadApplications(): void {
    this.applyService.getMyApplications().subscribe({
      next: (data) => {
        this.applications = data,
          this.cd.markForCheck();

      },
      error: (err) => console.error('Error fetching applications:', err)
    });
  }


}
