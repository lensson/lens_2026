import axios from 'axios'
import { ElMessage } from 'element-plus'

// Use Vite environment variable VITE_API_BASE if provided, otherwise
// fall back to the relative path that assumes the gateway is reverse-proxied
// under the same host: /v2/lens/migration/api/v1
const DEFAULT_BASE = '/v2/lens/migration/api/v1'
const ENV_BASE = typeof import.meta !== 'undefined' ? import.meta.env?.VITE_API_BASE : undefined
const BASE_URL = ENV_BASE || DEFAULT_BASE
const http = axios.create({ baseURL: BASE_URL, timeout: 30000 })

// Auth redirect config. We support two URLs:
// - VITE_AUTH_URL: the gateway base URL (e.g. http://localhost:8050)
// - VITE_KEYCLOAK_URL: the Keycloak base URL (e.g. http://localhost:28080)
// VITE_AUTH_CLIENT is the OAuth2 client registration id used by gateway (e.g. 'keycloak')
// VITE_KEYCLOAK_CLIENT_ID is the actual Keycloak client id (e.g. 'lens-client')
const AUTH_URL = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_AUTH_URL || 'http://localhost:8050') : 'http://localhost:8050'
const KEYCLOAK_URL = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_KEYCLOAK_URL || 'http://localhost:28080') : 'http://localhost:28080'
const AUTH_CLIENT = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_AUTH_CLIENT || 'keycloak') : 'keycloak'
const KEYCLOAK_CLIENT_ID = typeof import.meta !== 'undefined' ? (import.meta.env?.VITE_KEYCLOAK_CLIENT_ID || 'lens-client') : 'lens-client'



// Gateway oauth2 endpoint (if present)
const GATEWAY_OAUTH_ENDPOINT = `${AUTH_URL.replace(/\/$/, '')}/oauth2/authorization/${AUTH_CLIENT}`
// Keycloak OIDC authorize endpoint (use explicit Keycloak URL)
const KEYCLOAK_REALM = 'lens'
const KEYCLOAK_AUTHORIZE = `${KEYCLOAK_URL.replace(/\/$/, '')}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/auth`

// By default redirect directly to Keycloak authorize endpoint. The gateway endpoint may not be present
// in all deployments, and redirecting to a non-existent /oauth2/authorization/* on the gateway will show 404.
const AUTH_ENDPOINT = KEYCLOAK_AUTHORIZE

http.interceptors.response.use(
  (res) => res.data,
  (err) => {
    const status = err.response?.status || err.request?.status
    // If unauthorized, redirect to the OAuth2 authorization endpoint so user can login via Keycloak.
    if (status === 401) {
      try {
        const current = typeof window !== 'undefined' ? window.location.href : undefined
        // If we already returned from an auth redirect (we'll append _auth=1 to redirect_uri),
        // avoid redirecting again to prevent infinite loops. Use a sessionStorage flag to allow
        // a single retry after auth but block further automatic redirects.
        const alreadyFromAuth = typeof window !== 'undefined' && window.location.href.includes('_auth=1')
        const triedKey = 'lens_auth_redirect_tried'
        const tried = typeof window !== 'undefined' ? sessionStorage.getItem(triedKey) === '1' : false
        if (alreadyFromAuth && tried) {
          // We've already tried redirecting once after a login attempt and still got 401.
          // Stop automatic redirects to avoid a loop and show an error to the user.
          console.warn('[api] Authentication still failing after login; stopping automatic redirects')
          ElMessage.error('登录后仍未认证，请检查网关/Keycloak 配置，或手动刷新页面')
          return Promise.reject(err)
        }
        // The gateway oauth endpoint (/oauth2/authorization/...) may not exist in some
        // deployments (or may return 404). Navigating the browser to a non-existent
        // gateway URL loads a gateway 404 page and replaces the single-page app, so the
        // fallback logic in the old code cannot run. To avoid being stuck on a 404, go
        // directly to Keycloak's authorize endpoint and let Keycloak callback to the
        // gateway's callback URL (which the gateway must expose and accept).
        const gatewayCallback = `${AUTH_URL.replace(/\/$/, '')}/login/oauth2/code/${AUTH_CLIENT}`
        const viaKeycloak = `${KEYCLOAK_AUTHORIZE}?client_id=${encodeURIComponent(KEYCLOAK_CLIENT_ID)}&response_type=code&scope=openid&redirect_uri=${encodeURIComponent(gatewayCallback)}`

        console.debug('[api] 401 received, redirecting to Keycloak authorize ->', viaKeycloak)

        // Mark that we've attempted redirect; if we come back with _auth=1 and still 401 we'll stop.
        if (typeof window !== 'undefined') {
          try { sessionStorage.setItem(triedKey, '1') } catch(e) { /* ignore */ }
        }

        // Navigate directly to Keycloak authorize endpoint. Keycloak should then
        // redirect back to the gateway callback (gatewayCallback) which completes
        // the login flow.
        window.location.assign(viaKeycloak)
      } catch (e) {
        console.error('Redirect to AUTH_ENDPOINT failed', e)
      }
      return new Promise(() => {}) // hang the promise because we're redirecting
    }
    const msg = err.response?.data?.message || err.message || '请求失败'
    ElMessage.error(msg)
    return Promise.reject(err)
  }
)
export const projectApi = {
  list: (params) => http.get('/projects', { params }),
  get: (id) => http.get(`/projects/${id}`),
  create: (data) => http.post('/projects', data),
  update: (id, data) => http.put(`/projects/${id}`, data),
  remove: (id) => http.delete(`/projects/${id}`),
}
export const schemaApi = {
  list: (projectId) => http.get(`/projects/${projectId}/schemas`),
  add: (projectId, data) => http.post(`/projects/${projectId}/schemas`, data),
  remove: (projectId, id) => http.delete(`/projects/${projectId}/schemas/${id}`),
}
export const exampleApi = {
  list: (projectId, params) => http.get(`/projects/${projectId}/examples`, { params }),
  add: (projectId, data) => http.post(`/projects/${projectId}/examples`, data),
  remove: (projectId, id) => http.delete(`/projects/${projectId}/examples/${id}`),
}
export const intentApi = {
  getActive: (projectId) => http.get(`/projects/${projectId}/intents/active`),
  list: (projectId) => http.get(`/projects/${projectId}/intents`),
  add: (projectId, data) => http.post(`/projects/${projectId}/intents`, data),
}
export const generateApi = {
  generateXslt: (projectId, data) => http.post(`/projects/${projectId}/generate/xslt`, data),
  getActiveXslt: (projectId) => http.get(`/projects/${projectId}/generate/xslt/active`),
  listVersions: (projectId) => http.get(`/projects/${projectId}/generate/xslt/versions`),
  runTests: (projectId, data) => http.post(`/projects/${projectId}/generate/tests/run`, data),
  getLatestTestRun: (projectId) => http.get(`/projects/${projectId}/generate/tests/latest`),
}
