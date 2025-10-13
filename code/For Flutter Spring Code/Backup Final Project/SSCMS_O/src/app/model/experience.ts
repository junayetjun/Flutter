export interface Experience {
  id?: number;
  institution: string;
  position: string;
  fromDate: string; // yyyy-MM-dd
  toDate?: string;  // yyyy-MM-dd
  description?: string;
}