import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { environment } from '../../environments/envirronment';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { isPlatformBrowser } from '@angular/common';
import { ApplyDTO } from '../model/applyDTO';

@Injectable({
  providedIn: 'root'
})
export class ApplyService {

  private apiUrl = environment.apiBaseUrl + '/applications';

  constructor(
    private http: HttpClient,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }




  applyForJob(apply: any): Observable<any> {

    let headers = new HttpHeaders();
    if (isPlatformBrowser(this.platformId)) {

      const token = localStorage.getItem('authToken'); // JWT
      headers = new HttpHeaders({
        'Authorization': `Bearer ${token}`
      });
    }

    return this.http.post<any>(`${this.apiUrl}`, apply, { headers });
  }



  getMyApplications(): Observable<ApplyDTO[]> {

    let headers = new HttpHeaders();
    if (isPlatformBrowser(this.platformId)) {

      const token = localStorage.getItem('authToken'); // JWT
      headers = new HttpHeaders({
        'Authorization': `Bearer ${token}`
      });
    }



    return this.http.get<ApplyDTO[]>(`${this.apiUrl}/my`, { headers });
  }






  getApplicationsForJob(jobId: number): Observable<ApplyDTO[]> {
    let headers = new HttpHeaders();
    if (isPlatformBrowser(this.platformId)) {

      const token = localStorage.getItem('authToken'); // JWT
      headers = new HttpHeaders({
        'Authorization': `Bearer ${token}`
      });
    }


    return this.http.get<ApplyDTO[]>(`${this.apiUrl}/applicant/${jobId}`, { headers });
  }



}
