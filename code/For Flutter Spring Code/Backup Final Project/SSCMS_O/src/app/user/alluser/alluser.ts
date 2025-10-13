import { Component, OnInit } from '@angular/core';
import { User } from '../../model/userModel';
import { UserService } from '../../service/user.service';

@Component({
  selector: 'app-alluser',
  standalone: false,
  templateUrl: './alluser.html',
  styleUrl: './alluser.css'
})
export class Alluser implements OnInit {

  users: User[] = [];

  constructor(private userService: UserService) { }

  ngOnInit(): void {
    this.loadUsers();
  }

  loadUsers(): void {
    this.userService.getAllParent().subscribe({
      next: (res) => {
        this.users = res;
      },
      error: (err) => {
        console.error('Error fetching users:', err);
      }
    });
  }

}
