import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Cnavbar } from './cnavbar';

describe('Cnavbar', () => {
  let component: Cnavbar;
  let fixture: ComponentFixture<Cnavbar>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Cnavbar]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Cnavbar);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
