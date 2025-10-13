import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Alluser } from './alluser';

describe('Alluser', () => {
  let component: Alluser;
  let fixture: ComponentFixture<Alluser>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Alluser]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Alluser);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
