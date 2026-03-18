<template>
  <el-container class="app-container">
    <el-header class="app-header">
      <div class="header-left">
        <el-icon :size="22"><Connection /></el-icon>
        <span class="app-title">Lens Migration Tool</span>
      </div>
      <div class="header-right">
        <el-tag type="info" size="small">v2.0</el-tag>
      </div>
    </el-header>
    <el-container class="main-container">
      <el-aside width="200px" class="app-aside">
        <el-menu :default-active="activeMenu" router>
          <el-menu-item index="/projects">
            <el-icon><List /></el-icon>
            <span>迁移项目</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-main class="app-main">
        <div v-if="loading" style="display:flex;align-items:center;justify-content:center;height:100%">
          <el-spin />
        </div>
        <div v-else>
          <router-view />
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>
<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { projectApi } from '../src/api/index'

const loading = ref(true)
// Use same env config as API module. Prefer direct Keycloak authorize endpoint to avoid gateway 404s.
const AUTH_URL = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_AUTH_URL || 'http://localhost:8050') : 'http://localhost:8050'
const KEYCLOAK_URL = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_KEYCLOAK_URL || 'http://localhost:28080') : 'http://localhost:28080'
const AUTH_CLIENT = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_AUTH_CLIENT || 'keycloak') : 'keycloak'
const KEYCLOAK_CLIENT_ID = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_KEYCLOAK_CLIENT_ID || 'lens-client') : 'lens-client'
const GATEWAY_OAUTH_ENDPOINT = `${AUTH_URL.replace(/\/$/, '')}/oauth2/authorization/${AUTH_CLIENT}`
const KEYCLOAK_REALM = 'lens'
const KEYCLOAK_AUTHORIZE = `${KEYCLOAK_URL.replace(/\/$/, '')}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/auth`
const AUTH_ENDPOINT = KEYCLOAK_AUTHORIZE

onMounted(async () => {
  try {
    // lightweight check: fetch first page (size 1)
    await projectApi.list({ page: 0, size: 1 })
    loading.value = false
  } catch (e) {
    // if unauthorized, the axios interceptor will redirect; otherwise stop loading and show error
    loading.value = false
  }
})
const route = useRoute()
const activeMenu = computed(() => {
  if (route.path.startsWith('/projects')) return '/projects'
  return route.path
})
</script>
<style scoped>
.app-container { height: 100vh; }
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #1a1a2e;
  color: white;
  padding: 0 20px;
}
.header-left { display: flex; align-items: center; gap: 8px; }
.app-title { font-size: 18px; font-weight: 600; }
.main-container { height: calc(100vh - 60px); }
.app-aside { background: #f5f7fa; border-right: 1px solid #e4e7ed; }
.app-main { overflow-y: auto; padding: 20px; background: #f0f2f5; }
</style>
