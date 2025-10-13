export interface CaregiverDTO{
       id: number;
       name: string;
       email: string;
       phone: string;
       gender: string;
       address: string;
       dateOfBirth: Date; // Use string because JSON serializes Date as string
       photo : string;
       skill : string;
       experience : string;



}