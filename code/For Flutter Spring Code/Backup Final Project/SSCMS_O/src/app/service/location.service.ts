import { Injectable } from "@angular/core";
import { environment } from "../../environments/envirronment";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { Location } from '../model/location';


@Injectable({
  providedIn: 'root'
})
export class LocationService {

  private apiUrl = environment.apiBaseUrl + '/locations/';

  constructor(private http: HttpClient) { }

  getAllLocations(): Observable<Location[]> {
    return this.http.get<Location[]>(this.apiUrl);
  }
  getLocationById(id: number): Observable<Location> {
    return this.http.get<Location>(`${this.apiUrl}/${id}`);
  }

  createLocation(location: Location): Observable<Location> {
    return this.http.post<Location>(this.apiUrl, location);
  }

  updateLocation(id: number, category: Location): Observable<Location> {
    return this.http.put<Location>(`${this.apiUrl}${id}`, location);
  }

  deleteLocation(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}${id}`);
  }

}
