import { createRouter, createWebHistory } from 'vue-router'
import ProjectList from '../views/ProjectList.vue'
import ProjectDetail from '../views/ProjectDetail.vue'
import ProjectCreate from '../views/ProjectCreate.vue'
import ProjectWorkbench from '../views/ProjectWorkbench.vue'
const routes = [
  { path: '/', redirect: '/projects' },
  { path: '/projects', name: 'ProjectList', component: ProjectList },
  { path: '/projects/new', name: 'ProjectCreate', component: ProjectCreate },
  { path: '/projects/:id', name: 'ProjectDetail', component: ProjectDetail },
  { path: '/projects/:id/workbench', name: 'ProjectWorkbench', component: ProjectWorkbench },
]
export default createRouter({ history: createWebHistory(), routes })
