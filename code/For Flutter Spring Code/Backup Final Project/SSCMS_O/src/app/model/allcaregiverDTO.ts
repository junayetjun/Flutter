export interface AllCaregiverDTO {
    id: number;
    name: string;
    email: string;
    phone: string;
    gender: string;
    address: string;
    dateOfBirth: string; // ISO string (e.g. "1990-01-01")
    photo: string;
    skill: string;
    experience: string;
    category: {
        id: number;
        name: string;
    };
}
