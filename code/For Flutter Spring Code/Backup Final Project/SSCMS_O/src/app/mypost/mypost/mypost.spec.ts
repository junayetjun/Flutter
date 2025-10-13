import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Mypost } from './mypost';

describe('Mypost', () => {
  let component: Mypost;
  let fixture: ComponentFixture<Mypost>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Mypost]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Mypost);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
