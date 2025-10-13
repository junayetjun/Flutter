import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { environment } from '../../environments/envirronment';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { isPlatformBrowser } from '@angular/common';
import { Job } from '../model/job';
import { Observable } from 'rxjs';
import { JobDTO } from '../model/jobDTO';

@Injectable({
  providedIn: 'root'
})
export class JobService {


  private baseUrl = environment.apiBaseUrl + '/jobs/';

  constructor(
    private http: HttpClient,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  //  Get auth headers with token if available
  private getAuthHeaders(): HttpHeaders {
    let headers = new HttpHeaders();

    if (isPlatformBrowser(this.platformId)) {
      const token = localStorage.getItem('authToken');
      if (token) {
        headers = headers.set('Authorization', 'Bearer ' + token);
      }
    }

    return headers;
  }

  //  Create job
  createJob(data: Partial<Job>): Observable<Job> {
    const headers = this.getAuthHeaders();
    return this.http.post<Job>(`${this.baseUrl}`, data, { headers });
  }

  // Get all jobs by employer ID
  getJobsByParentId(parentId: number): Observable<Job[]> {
    const headers = this.getAuthHeaders();
    return this.http.get<Job[]>(`${this.baseUrl}parent/${parentId}`, { headers });
  }

  //  Delete a job
  deleteJob(id: number): Observable<void> {
    const headers = this.getAuthHeaders();
    return this.http.delete<void>(`${this.baseUrl}/${id}`, { headers });
  }

  // Optional: Update a job
  updateJob(id: number, job: Partial<Job>): Observable<Job> {
    const headers = this.getAuthHeaders();
    return this.http.put<Job>(`${this.baseUrl}/${id}`, job, { headers });
  }

  //  Optional: Get job by ID
  getJobById(id: number): Observable<JobDTO> {
    const headers = this.getAuthHeaders();
    return this.http.get<JobDTO>(`${this.baseUrl}${id}`, { headers });
  }


  // GET all jobs
  getAllJobs(): Observable<JobDTO[]> {
    return this.http.get<JobDTO[]>(this.baseUrl);
  }

  searchJobs(categoryId?: number | null, locationId?: number | null): Observable<JobDTO[]> {
    let params: any = {};

    if (locationId) params.locationId = locationId;
    if (categoryId) params.categoryId = categoryId;

    return this.http.get<JobDTO[]>(`${this.baseUrl}search`, { params });
  }


  getMyJobs(): Observable<JobDTO[]> {
    let headers = new HttpHeaders();

    if (isPlatformBrowser(this.platformId)) {
      const token = localStorage.getItem('authToken'); // JWT token
      if (token) {
        headers = new HttpHeaders({
          'Authorization': `Bearer ${token}`
        });
      }
    }

    return this.http.get<JobDTO[]>(`${this.baseUrl}my-jobs`, { headers });
  }



}
