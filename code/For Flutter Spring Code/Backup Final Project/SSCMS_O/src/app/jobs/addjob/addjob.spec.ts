import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Addjob } from './addjob';

describe('Addjob', () => {
  let component: Addjob;
  let fixture: ComponentFixture<Addjob>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Addjob]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Addjob);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
