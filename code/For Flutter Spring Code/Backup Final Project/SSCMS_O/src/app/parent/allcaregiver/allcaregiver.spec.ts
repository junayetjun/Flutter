import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Allcaregiver } from './allcaregiver';

describe('Allcaregiver', () => {
  let component: Allcaregiver;
  let fixture: ComponentFixture<Allcaregiver>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Allcaregiver]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Allcaregiver);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
