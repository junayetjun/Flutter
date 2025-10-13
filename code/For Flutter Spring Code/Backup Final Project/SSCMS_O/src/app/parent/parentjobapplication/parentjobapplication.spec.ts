import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Parentjobapplication } from './parentjobapplication';

describe('Parentjobapplication', () => {
  let component: Parentjobapplication;
  let fixture: ComponentFixture<Parentjobapplication>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Parentjobapplication]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Parentjobapplication);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
