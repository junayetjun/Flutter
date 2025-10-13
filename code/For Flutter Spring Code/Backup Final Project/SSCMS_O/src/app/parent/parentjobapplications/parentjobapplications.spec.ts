import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Parentjobapplications } from './parentjobapplications';

describe('Parentjobapplications', () => {
  let component: Parentjobapplications;
  let fixture: ComponentFixture<Parentjobapplications>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Parentjobapplications]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Parentjobapplications);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
