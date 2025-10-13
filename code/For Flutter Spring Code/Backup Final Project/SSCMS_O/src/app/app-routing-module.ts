import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AddcaregiverComponent } from './caregiver/addcaregiver.component/addcaregiver.component';
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
import { Alluser } from './user/alluser/alluser';
import { Userhome } from './layout/userhome/userhome';
import { Pauserhome } from './layout/pauserhome/pauserhome';
import { Personalinfo } from './caregiver/personalinfo/personalinfo';
import { Cnavbar } from './layout/cnavbar/cnavbar';
import { Viewdetails } from './parent/viewdetails/viewdetails';
import { Allcaregiver } from './parent/allcaregiver/allcaregiver';


const routes: Routes = [
  { path: 'caregiverpro', component: Caregiverprofile },
  { path: 'addcare', component: AddcaregiverComponent },
  { path: 'parentlist', component: ParentList },
  { path: 'addcategory', component: CategoryComponent },
  { path: 'addparent', component: ParentRegistration },
  { path: 'parentrofile', component: Profilecomponent },
  { path: 'login', component: Login },
  { path: 'caregiverlist', component: CaregiverListComponent },
  // {path:'', component: Caregiverprofile},
  // { path: '', component: Home },
  { path: 'home', component: Home },
  { path: 'addcat', component: Addcategory },
  { path: 'addjob', component: Addjob },
  { path: 'addloc', component: Addlocation },
  { path: 'logout', component: Logout },
  { path: 'application/:id', component: Parentjobapplication },
  { path: 'jobs/:id', component: JobDetailsComponent },
  { path: 'jobdetails', component: JobDetailsComponent },
  { path: 'alljobs', component: Alljobs },
  { path: 'myjob', component: Mypost },
  { path: 'apply', component: AppliedJobs },
  { path: 'allUser', component: Alluser },
  { path: 'userhome', component: Userhome },
  { path: '', component: Userhome },
  { path: 'mainhome', component: Userhome },
  { path: 'phome', component: Pauserhome },
  { path: 'pinfo', component: Personalinfo },
  { path: 'cnavbar', component: Cnavbar },
  { path: 'cdetails/:id', component: Viewdetails },
  { path: 'allcaregiver', component: Allcaregiver },


];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
