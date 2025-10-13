import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Addlocation } from './addlocation';

describe('Addlocation', () => {
  let component: Addlocation;
  let fixture: ComponentFixture<Addlocation>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Addlocation]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Addlocation);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
