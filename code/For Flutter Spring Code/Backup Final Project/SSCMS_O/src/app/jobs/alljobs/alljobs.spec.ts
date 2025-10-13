import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Alljobs } from './alljobs';

describe('Alljobs', () => {
  let component: Alljobs;
  let fixture: ComponentFixture<Alljobs>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [Alljobs]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Alljobs);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
