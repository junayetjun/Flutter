import { NgModule, provideBrowserGlobalErrorListeners, provideZonelessChangeDetection } from '@angular/core';
import { BrowserModule, provideClientHydration, withEventReplay } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing-module';
import { App } from './app';
import { AddcaregiverComponent } from './caregiver/addcaregiver.component/addcaregiver.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { provideHttpClient, withFetch } from '@angular/common/http';
import { Navbar } from './layout/navbar/navbar';
import { Sidebar } from './layout/sidebar/sidebar';
import { Footer } from './layout/footer/footer';
import { Header } from './layout/header/header';
import { CategoryComponent } from './category/category.component/category.component';
import { ParentRegistration } from './parent/parent-registration/parent-registration';
import { Caregiverprofile } from './caregiver/caregiverprofile/caregiverprofile';
import { ParentList } from './parent/parent-list/parent-list';
import { Profilecomponent } from './parent/profilecomponent/profilecomponent';
import { Login } from './auth/login/login';
import { CaregiverListComponent } from './caregiver/caregiver-list.component/caregiver-list.component';
import { Home } from './home/home';
import { Addcategory } from './category/addcategory/addcategory';
import { Addjob } from './jobs/addjob/addjob';
import { Addlocation } from './locations/addlocation/addlocation';
import { Logout } from './auth/logout/logout';
import { Parentjobapplication } from './parent/parentjobapplication/parentjobapplication';
import { JobDetailsComponent } from './jobs/job-details.component/job-details.component';
import { Alljobs } from './jobs/alljobs/alljobs';
import { Mypost } from './mypost/mypost/mypost';
import { AppliedJobs } from './caregiver/applied-jobs/applied-jobs';
import { Parentjobapplications } from './parent/parentjobapplications/parentjobapplications';
import { Alluser } from './user/alluser/alluser';
import { Userhome } from './layout/userhome/userhome';
import { Pauserhome } from './layout/pauserhome/pauserhome';
import { Personalinfo } from './caregiver/personalinfo/personalinfo';
import { Adminprofile } from './admin/adminprofile/adminprofile';
import { Cnavbar } from './layout/cnavbar/cnavbar';
import { Viewdetails } from './parent/viewdetails/viewdetails';
import { Allcaregiver } from './parent/allcaregiver/allcaregiver';



@NgModule({
  declarations: [
    App,
    AddcaregiverComponent,
    Navbar,
    Sidebar,
    Footer,
    Header,
    CategoryComponent,
    ParentRegistration,
    Caregiverprofile,
    ParentList,
    Profilecomponent,
    Login,
    CaregiverListComponent,
    Home,
    Addcategory,
    Addjob,
    Addlocation,
    Logout,
    Parentjobapplication,
    JobDetailsComponent,
    Alljobs,
    Mypost,
    AppliedJobs,
    Parentjobapplications,
    Alluser,
    Userhome,
    Pauserhome,
    Personalinfo,
    Adminprofile,
    Cnavbar,
    Viewdetails,
    Allcaregiver,
   
   
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ],
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZonelessChangeDetection(),
    provideClientHydration(withEventReplay()),
    provideHttpClient(
      withFetch()
    )
  ],
  bootstrap: [App]
})
export class AppModule { }
