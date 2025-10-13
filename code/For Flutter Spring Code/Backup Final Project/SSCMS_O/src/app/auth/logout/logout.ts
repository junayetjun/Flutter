import { Component, OnInit } from '@angular/core';
import { AuthService } from '../../service/auth-service';

@Component({
  selector: 'app-logout',
  standalone: false,
  templateUrl: './logout.html',
  styleUrl: './logout.css'
})
export class Logout implements OnInit{

  constructor(
    private authService: AuthService
  ){}

  ngOnInit(): void {
    this.authService.logout();
  }

}
