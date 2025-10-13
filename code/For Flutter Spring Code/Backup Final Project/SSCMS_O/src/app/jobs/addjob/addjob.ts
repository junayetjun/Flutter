import { ChangeDetectorRef, Component } from '@angular/core';
import { Category } from '../../model/category.model';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { JobService } from '../../service/job.service';
import { CategoryService } from '../../service/category.service';
import { LocationService } from '../../service/location.service';
import { Location } from '../../model/location';

@Component({
  selector: 'app-addjob',
  standalone: false,
  templateUrl: './addjob.html',
  styleUrl: './addjob.css'
})
export class Addjob {

  locations: Location[] = [];
  catagories: Category[] = [];

  jobForm: FormGroup;
  isSubmitted = false;
  successMessage = '';
  errorMessage = '';


  constructor(

    private fb: FormBuilder,
    private jobService: JobService,
    private locationService: LocationService,
    private cd: ChangeDetectorRef,
    private categoryService: CategoryService

  ) {

    this.jobForm = this.fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      salary: [null, [Validators.required, Validators.min(0)]],
      jobType: ['', Validators.required],
      postedDate: ['', Validators.required],
      location: [''],
      category: [],
    });
  }


  ngOnInit(): void {
    this.loadLocations();
    this.loadCategories();
  }



  loadLocations(): void {
    this.locationService.getAllLocations().subscribe({
      next: (data) => {

        this.locations = data;
        this.cd.markForCheck();


      },
      error: (err) => console.error('Error loading locations', err)
    });
  }



  loadCategories(): void {
    this.categoryService.getAllCategories().subscribe({
      next: (data) => {
        this.catagories = data;
        this.cd.markForCheck();


      },
      error: (err) => console.error('Error loading locations', err)
    });
  }





  onSubmit(): void {
    this.isSubmitted = true;

    if (this.jobForm.invalid) return;

    const formValue = this.jobForm.value;

    const jobData = {
      ...formValue,
      location: { id: formValue.location },
      category: { id: formValue.category }
    };

    this.jobService.createJob(jobData).subscribe({
      next: (res) => {
        this.successMessage = 'Job posted successfully!';
        console.log(res);
        this.errorMessage = '';
        this.jobForm.reset();
        this.isSubmitted = false;
      },
      error: (err) => {
        this.successMessage = '';
        this.errorMessage = 'Failed to post job.';
        console.log(err)
      }
    });
  }
}
