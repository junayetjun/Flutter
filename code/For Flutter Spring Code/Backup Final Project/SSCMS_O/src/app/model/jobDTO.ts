export interface JobDTO {
    id: number;
    title: string;
    description: string;
    salary: number;
    jobType: string;
    postedDate: string;
    category: {
        id: number;
        name: string;
    };
    location: {
        id: number;
        name: string;
    };

    // Parent info
    parentId: number;
    parentName: string;
    contactPerson: string;
    email: string;
    phone: string;
    childName: string;
    photo: string
}