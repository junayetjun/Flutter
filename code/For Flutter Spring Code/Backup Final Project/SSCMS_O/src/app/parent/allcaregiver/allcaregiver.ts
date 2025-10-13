import { ChangeDetectorRef, Component } from '@angular/core';
import { AllCaregiverDTO } from '../../model/allcaregiverDTO';
import { Category } from '../../model/category.model';
import { CaregiverService } from '../../service/caregiver.service';
import { CategoryService } from '../../service/category.service';


@Component({
  selector: 'app-allcaregiver',
  standalone: false,
  templateUrl: './allcaregiver.html',
  styleUrl: './allcaregiver.css'
})
export class Allcaregiver {


  caregiver: AllCaregiverDTO[] = [];
  categories: Category[] = [];
  // locations: Location[] = [];

  selectedCategoryId: number | null = null;
  // selectedLocationId: number | null = null;

  constructor(
    private caregiverService: CaregiverService,
    private categoryService: CategoryService,
    // private locationService: LocationService,
    private cdr: ChangeDetectorRef
  ) { }

  ngOnInit(): void {
    this.loadCategories();
   
  }



  loadCategories() {
    this.categoryService.getAllCategories().subscribe(data => {
      this.categories = data;
      this.cdr.markForCheck();
      console.log(this.categories);
    });
  }



  // loadLocations() {
  //   this.locationService.getAllLocations().subscribe((data) => {
  //     this.locations = data;
  //   });
  // }

  loadAllCaregiver() {
    this.caregiverService.getAllCaregiver().subscribe((data) => {
      console.log('All jobs:', data);
      this.caregiver = data;
      console.log(this.caregiver);
      this.cdr.markForCheck();
    });
  }

  filterJobs() {
    this.caregiverService.searchCaregiver(this.selectedCategoryId).subscribe((data) => {
      this.caregiver = data;
      this.cdr.markForCheck();
    });
  }


  onLogoError(event: any) {
    event.target.src = 'assets/images/default-logo.png'; // placeholder if image fails
  }
}
