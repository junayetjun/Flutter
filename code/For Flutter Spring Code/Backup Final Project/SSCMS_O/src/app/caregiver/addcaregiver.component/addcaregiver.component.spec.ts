import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddcaregiverComponent } from './addcaregiver.component';

describe('AddcaregiverComponent', () => {
  let component: AddcaregiverComponent;
  let fixture: ComponentFixture<AddcaregiverComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AddcaregiverComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AddcaregiverComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
