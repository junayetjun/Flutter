import { Injectable } from '@angular/core';
import { environment } from '../../environments/envirronment';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User } from '../model/userModel';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private baseUrl = environment.apiBaseUrl + '/user/';

  constructor(private http: HttpClient) { }


  getAllParent(): Observable<User[]> {

    return this.http.get<User[]>(this.baseUrl);
  }

}
