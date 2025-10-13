import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Caregiverprofile } from './caregiverprofile';

describe('Caregiverprofile', () => {
  let component: Caregiverprofile;
  let fixture: ComponentFixture<Caregiverprofile>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Caregiverprofile]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Caregiverprofile);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
