import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Personalinfo } from './personalinfo';

describe('Personalinfo', () => {
  let component: Personalinfo;
  let fixture: ComponentFixture<Personalinfo>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Personalinfo]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Personalinfo);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
