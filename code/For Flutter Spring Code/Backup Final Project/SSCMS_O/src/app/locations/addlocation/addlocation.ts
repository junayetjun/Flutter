import { ChangeDetectorRef, Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { LocationService } from '../../service/location.service';
import { Location } from '../../model/location';

@Component({
  selector: 'app-addlocation',
  standalone: false,
  templateUrl: './addlocation.html',
  styleUrl: './addlocation.css'
})
export class Addlocation {

  locations: Location[] = [];
  locationForm: FormGroup;
  editMode: boolean = false;
  selectedLocationId: number | null = null;

  constructor(
    private fb: FormBuilder,
    private locationService: LocationService,
    private cd: ChangeDetectorRef
  ) {
    this.locationForm = this.fb.group({
      name: ['', Validators.required]
    });
  }

  ngOnInit(): void {
    this.loadLocations();
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

  onSubmit(): void {
    if (this.locationForm.invalid) return;

    const location: Location = this.locationForm.value;

    if (this.editMode && this.selectedLocationId) {
      // Update
      this.locationService.updateLocation(this.selectedLocationId, location).subscribe({
        next: () => {
          this.loadLocations();
          this.resetForm();
        },
        error: (err) => console.error('Error updating location', err)
      });
    } else {
      // Create
      this.locationService.createLocation(location).subscribe({
        next: () => {
          this.loadLocations();
          this.resetForm();
        },
        error: (err) => console.error('Error creating location', err)
      });
    }
  }

  editLocation(location: Location): void {
    this.editMode = true;
    this.selectedLocationId = location.id!;
    this.locationForm.patchValue({ name: location.name });
  }

  deleteLocation(id: number): void {
    if (confirm('Are you sure you want to delete this location?')) {
      this.locationService.deleteLocation(id).subscribe({
        next: () => this.loadLocations(),
        error: (err) => console.error('Error deleting location', err)
      });
    }
  }

  resetForm(): void {
    this.locationForm.reset();
    this.editMode = false;
    this.selectedLocationId = null;
  }

}
