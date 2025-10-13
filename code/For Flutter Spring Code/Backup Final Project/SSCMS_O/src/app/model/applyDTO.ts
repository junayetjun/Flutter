import { Caregiver } from "./caregiver.model";
import { Education } from "./education";
import { Experience } from "./experience";
import { Hobby } from "./hobby";
import { Language } from "./language";
import { Reference } from "./reference";
import { Skill } from "./skill";

export interface ApplyDTO {
  id: number;
  jobId: number;
  jobTitle: string;
  parentId: number;
  parentName: string;
  caregiverId: number;
  caregiverName: string;


  // Add detailed CV info
  caregiver?: Caregiver;
  educations?: Education[];
  experiences?: Experience[];
  skills?: Skill[];
  languages?: Language[];
  hobbies?: Hobby[];
  references?: Reference[];
}