import { defineStore } from 'pinia'
import { ref } from 'vue'
import { projectApi } from '../api'
export const useProjectStore = defineStore('project', () => {
  const projects = ref([])
  const total = ref(0)
  const current = ref(null)
  const loading = ref(false)
  async function fetchList(params = {}) {
    loading.value = true
    try {
      const res = await projectApi.list({ page: 0, size: 20, ...params })
      projects.value = res.data?.records || []
      total.value = res.data?.total || 0
    } finally {
      loading.value = false
    }
  }
  async function fetchOne(id) {
    loading.value = true
    try {
      const res = await projectApi.get(id)
      current.value = res.data
      return res.data
    } finally {
      loading.value = false
    }
  }
  async function createProject(data) {
    const res = await projectApi.create(data)
    return res.data
  }
  async function removeProject(id) {
    await projectApi.remove(id)
    projects.value = projects.value.filter((p) => p.id !== id)
    total.value--
  }
  return { projects, total, current, loading, fetchList, fetchOne, createProject, removeProject }
})
