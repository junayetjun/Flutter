import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { environment } from '../../environments/envirronment';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AuthService } from './auth-service';
import { Observable } from 'rxjs';
import { Caregiver } from '../model/caregiver.model';
import { isPlatformBrowser } from '@angular/common';
import { AllCaregiverDTO } from '../model/allcaregiverDTO';

@Injectable({
  providedIn: 'root'
})
export class CaregiverService {

  private baseUrl = environment.apiBaseUrl + '/caregiver/';

  constructor(private http: HttpClient,
    private authService: AuthService,
    @Inject(PLATFORM_ID) private platformId: Object

  ) { }



  registerCaregiver(user: any, caregiver: any, photo: File): Observable<any> {
    const formData = new FormData();
    formData.append('user', JSON.stringify(user));
    formData.append('caregiver', JSON.stringify(caregiver));
    formData.append('photo', photo);

    return this.http.post(this.baseUrl, formData);
  }

  getProfile(): Observable<Caregiver> {

    let headers = new HttpHeaders();
    if (isPlatformBrowser(this.platformId)) {
      const token = localStorage.getItem('authToken');

      if (token) {
        headers = headers.set('Authorization', 'Bearer ' + token);
      }
    }

    return this.http.get<Caregiver>(`${this.baseUrl}profile`, { headers });
  }


  // GET all jobs
  getAllCaregiver(): Observable<AllCaregiverDTO[]> {
    return this.http.get<AllCaregiverDTO[]>(this.baseUrl);
  }

  searchCaregiver(categoryId?: number | null,): Observable<AllCaregiverDTO[]> {
    let params: any = {};


    if (categoryId) params.categoryId = categoryId;

    return this.http.get<AllCaregiverDTO[]>(`${this.baseUrl}search`, { params });
  }

}
