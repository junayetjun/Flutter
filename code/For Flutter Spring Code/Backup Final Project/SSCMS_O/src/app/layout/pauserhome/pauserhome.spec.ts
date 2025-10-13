import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Pauserhome } from './pauserhome';

describe('Pauserhome', () => {
  let component: Pauserhome;
  let fixture: ComponentFixture<Pauserhome>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Pauserhome]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Pauserhome);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
