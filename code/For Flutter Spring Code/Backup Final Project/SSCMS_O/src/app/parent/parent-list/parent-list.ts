import { Component, OnInit } from '@angular/core';
import { ParentService } from '../../service/parent.service';

@Component({
  selector: 'app-parent-list',
  standalone: false,
  templateUrl: './parent-list.html',
  styleUrl: './parent-list.css'
})
export class ParentList implements OnInit {

  parents: any[] = [];
  message: string = '';
  loading: boolean = true;

  constructor(private parentService: ParentService) { }

  ngOnInit(): void {
    // this.loadParents();
  }

//  loadParents(): void {
//     this.parentService.getAllParents().subscribe({
//       next: (data) => {
//         this.parents = data;
//         this.loading = false;
//       },
//       error: (err) => {
//         this.message = 'Failed to load parents. Please try again later.';
//         this.loading = false;
//         console.error(err);
//       }
//     });
//   }

}
