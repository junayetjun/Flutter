import { ChangeDetectorRef, Component } from '@angular/core';
import { Education } from '../../model/education';
import { Skill } from '../../model/skill';
import { Reference } from '../../model/reference';
import { Language } from '../../model/language';
import { Hobby } from '../../model/hobby';
import { CaregiverService } from '../../service/caregiver.service';
import { EducationService } from '../../service/education.service';
import { ExperienceService } from '../../service/experience.service';
import { SkillService } from '../../service/skill.service';
import { ReferenceService } from '../../service/reference.service';
import { LanguageService } from '../../service/language.service';
import { HobbyService } from '../../service/hobby.service';
import { AuthService } from '../../service/auth-service';
import { Experience } from '../../model/experience';

@Component({
  selector: 'app-caregiverprofile',
  standalone: false,
  templateUrl: './caregiverprofile.html',
  styleUrl: './caregiverprofile.css'
})
export class Caregiverprofile {

  caregiver: any;

  educations: Education[] = [];

  newEducation = {
    level: '',
    institute: '',
    result: '',
    year: ''
  };

  experiences: Experience[] = [];

  newExperience: Experience = {
    institution: '',
    position: '',
    fromDate: ''
  };

  skills: Skill[] = [];

  newSkill: Skill = {
    name: '',
    level: ''
  };

  references: Reference[] = [];

  newReference: Reference = {
    name: '',
    contact: '',
    relation: ''
  };

  languages: Language[] = [];

  newLanguage: Language = {
    name: '',
    proficiency: ''
  };

  hobbies: Hobby[] = [];

  newHobby: Hobby = {
    name: ''
  };


  constructor(
    private caregiverService: CaregiverService,
    private cdr: ChangeDetectorRef,
    private educationService: EducationService,
    private expService: ExperienceService,
    private skillService: SkillService,
    private refferenceService: ReferenceService,
    private languageService: LanguageService,
    private hobbyService: HobbyService,
    private authService: AuthService,
  ) { }


  ngOnInit(): void {
    this.getProfile();
    this.loadEducations();
    this.loadExperiences();
    this.loadSkills();
    this.loadReferences();
    this.loadLanguages();
    this.loadHobbies();

  }

  loadHobbies(): void {
    this.hobbyService.getAllHobbies().subscribe({
      next: (data) => {
        this.hobbies = data;
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to load hobbies', err)
    });
  }

  addHobby(): void {
    this.hobbyService.addHobby(this.newHobby).subscribe({
      next: () => {
        this.newHobby = { name: '' };
        this.loadHobbies();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to add hobby', err)
    });
  }

  deleteHobby(id: number | undefined): void {
    if (!id) return;
    if (!confirm('Are you sure you want to delete this hobby?')) return;

    this.hobbyService.deleteHobby(id).subscribe({
      next: () => {
        this.loadHobbies();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to delete hobby:', err)
    });
  }


  loadLanguages(): void {
    this.languageService.getAllLanguages().subscribe({
      next: (data) => {
        this.languages = data;
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to load languages', err)
    });
  }

  addLanguage(): void {
    this.languageService.addLanguage(this.newLanguage).subscribe({
      next: () => {
        this.newLanguage = { name: '', proficiency: '' };
        this.loadLanguages();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to add language', err)
    });
  }

  deleteLanguage(id: number | undefined): void {
    if (!id) return;
    if (!confirm('Are you sure you want to delete this language?')) return;

    this.languageService.deleteLanguage(id).subscribe({
      next: () => {
        this.loadLanguages();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to delete language:', err)
    });
  }

  loadReferences(): void {
    this.refferenceService.getAllReferences().subscribe({
      next: (data) => {
        this.references = data;
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to load references', err)
    });
  }

  addReference(): void {
    this.refferenceService.addReference(this.newReference).subscribe({
      next: () => {
        this.newReference = { name: '', contact: '', relation: '' };
        this.loadReferences();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to add reference', err)
    });
  }

  deleteReference(id: number | undefined): void {
    if (!id) return;
    if (!confirm('Are you sure you want to delete this reference?')) return;

    this.refferenceService.deleteReference(id).subscribe({
      next: () => {
        this.loadReferences();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to delete reference:', err)
    });
  }


  loadSkills(): void {
    this.skillService.getAllSkills().subscribe({
      next: (data) => {
        this.skills = data;
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to load skills', err)
    });
  }

  // Add a new skill
  addSkill(): void {
    this.skillService.addSkill(this.newSkill).subscribe({
      next: () => {
        this.newSkill = { name: '', level: '' }; // Reset form
        this.loadSkills();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to add skill', err)
    });
  }

  // Delete a skill by ID
  deleteSkill(id: number | undefined): void {
    if (!id) return;
    if (!confirm('Are you sure you want to delete this skill?')) return;

    this.skillService.deleteSkill(id).subscribe({
      next: () => {
        this.loadSkills();
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to delete skill:', err)
    });
  }

  loadEducations(): void {
    this.educationService.getEducations().subscribe({
      next: (data) => {
        this.educations = data;

        this.cdr.markForCheck();

      },
      error: (err) => {
        console.error('Failed to load educations', err);
      }
    });
  }

  getProfile() {

    this.caregiverService.getProfile().subscribe({
      next: (data) => {
        this.caregiver = data;
        console.log(data);
        this.cdr.markForCheck();

      },
      error: (err) => {
        console.error('Failed to load profile', err);
      }
    });
  }



  addEducation(): void {
    this.educationService.addEducation(this.newEducation).subscribe({
      next: async (addedEdu: any) => {
        if (!this.caregiver.educations) {
          this.caregiver.educations = [];
        }
        this.caregiver.educations.push(addedEdu);
        this.newEducation = { level: '', institute: '', result: '', year: '' };


      },
      error: (err) => {
        console.error('Failed to add education', err);
      }
    });
  }


  deleteEducation(id: number): void {
    if (!confirm('Are you sure you want to delete this education?')) {
      return;
    }

    this.educationService.deleteEducation(id).subscribe({
      next: () => {
        // ✅ Remove from UI
        this.loadEducations();
        this.cdr.markForCheck();

      },
      error: (err) => {
        console.error('Failed to delete education:', err);
        alert('Failed to delete education.');
      }
    });
  }

  loadExperiences(): void {
    this.expService.getAllExperiences().subscribe(data => {
      this.experiences = data;
      this.cdr.markForCheck();
    });
  }

  addExperience(): void {
    this.expService.addExperience(this.newExperience).subscribe(() => {
      this.newExperience = { institution: '', position: '', fromDate: '' };
      this.loadExperiences();
      this.cdr.markForCheck();
    });
  }

  deleteExperience(id: number | undefined): void {
    if (!id) return;
    this.expService.deleteExperience(id).subscribe(() => {
      this.loadExperiences();
      this.cdr.markForCheck();
    });
  }

  onLogout(): void {
    this.authService.logout();
  }
}
