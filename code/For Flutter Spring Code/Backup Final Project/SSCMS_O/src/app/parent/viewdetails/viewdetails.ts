import { AfterViewInit, Component, ElementRef, Input, ViewChild } from '@angular/core';
import { Caregiver } from '../../model/caregiver.model';
import { Education } from '../../model/education';
import { Experience } from '../../model/experience';
import { Skill } from '../../model/skill';
import { Language } from '../../model/language';
import { Hobby } from '../../model/hobby';
import { Reference } from '../../model/reference';

@Component({
  selector: 'app-viewdetails',
  standalone: false,
  templateUrl: './viewdetails.html',
  styleUrl: './viewdetails.css'
})
export class Viewdetails implements AfterViewInit{

  @Input() caregiver!: Caregiver;
  @Input() educations: Education[] = [];
  @Input() experiences: Experience[] = [];
  @Input() skills: Skill[] = [];
  @Input() languages: Language[] = [];
  @Input() hobbies: Hobby[] = [];
  @Input() references: Reference[] = [];

  @ViewChild('cvContent') cvContent!: ElementRef;

  ngAfterViewInit(): void {
    // Optional debug
  }

  async downloadCV(): Promise<void> {
    const element = this.cvContent.nativeElement;

    // Temporarily show the hidden CV content
    element.classList.remove('hidden');

    const html2pdf = (await import('html2pdf.js')).default;

    const opt = {
      margin: 0.5,
      filename: `${this.caregiver.name}_CV.pdf`,
      image: { type: 'jpeg', quality: 0.98 },
      html2canvas: { scale: 2, useCORS: true },
      jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' },
      pagebreak: {
        mode: ['avoid-all', 'css', 'legacy']
      }
    };

    // await html2pdf().from(element).set(opt).save();

    // Hide the CV content again after PDF is saved
    element.classList.add('hidden');
  }
}
