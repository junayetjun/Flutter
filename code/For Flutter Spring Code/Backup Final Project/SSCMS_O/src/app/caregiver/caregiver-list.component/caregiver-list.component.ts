import { Component } from '@angular/core';
import { Caregiver } from '../../model/caregiver.model';
import { CaregiverService } from '../../service/caregiver.service';

@Component({
  selector: 'app-caregiver-list.component',
  standalone: false,
  templateUrl: './caregiver-list.component.html',
  styleUrl: './caregiver-list.component.css'
})
export class CaregiverListComponent {

  caregivers: Caregiver[] = [];
  message: string = '';
  loading: boolean = true;

  constructor(private caregiverService: CaregiverService) { }

  ngOnInit(): void {
    // this.loadCaregivers();
  }

  // loadCaregivers(): void {
  //   this.caregiverService.getAllCaregivers().subscribe({
  //     next: (data) => {
  //       this.caregivers = data;
  //       this.loading = false;
  //     },
  //     error: (err) => {
  //       this.message = 'Failed to load caregivers. Please try again later.';
  //       this.loading = false;
  //       console.error(err);
  //     }
  //   });
  // }

}
