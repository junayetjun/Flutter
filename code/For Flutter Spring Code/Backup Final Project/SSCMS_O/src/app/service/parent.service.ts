import { Inject, Injectable, PLATFORM_ID } from '@angular/core';
import { environment } from '../../environments/envirronment';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AuthService } from './auth-service';
import { catchError, Observable } from 'rxjs';
import { isPlatformBrowser } from '@angular/common';
import { Parent } from '../model/parent';

@Injectable({
  providedIn: 'root'
})
export class ParentService {

 private baseUrl = environment.apiBaseUrl + '/parent/';

  constructor(
    private http: HttpClient,
    private authService: AuthService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  // Optional helper if you want to avoid circular structure errors
  private safeStringify(obj: any): string {
    const seen = new WeakSet();
    return JSON.stringify(obj, (key, value) => {
      if (typeof value === 'object' && value !== null) {
        if (seen.has(value)) return undefined;
        seen.add(value);
      }
      return value;
    });
  }

  registerParent(user: any, parent: any, photo: File): Observable<any> {
    const formData = new FormData();

    // Only stringify pure data objects (NO FormGroup, window, etc.)
    formData.append('user', this.safeStringify(user));
    formData.append('parent', this.safeStringify(parent));
    formData.append('photo', photo);

    return this.http.post(this.baseUrl, formData);
  }

  getProfile(): Observable<Parent> {
    let headers = new HttpHeaders();
    if (isPlatformBrowser(this.platformId)) {
      const token = localStorage.getItem('authToken');
      if (token) {
        headers = headers.set('Authorization', 'Bearer ' + token);
      }
    }
    return this.http.get<Parent>(`${this.baseUrl}profile`, { headers });
  }


}
