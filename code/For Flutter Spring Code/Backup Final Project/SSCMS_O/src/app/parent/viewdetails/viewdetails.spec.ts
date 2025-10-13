import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Viewdetails } from './viewdetails';

describe('Viewdetails', () => {
  let component: Viewdetails;
  let fixture: ComponentFixture<Viewdetails>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Viewdetails]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Viewdetails);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
