<template>
  <div v-loading="store.loading">
    <div class="page-header">
      <el-button link @click="$router.back()"><el-icon><ArrowLeft /></el-icon> 返回</el-button>
      <h2>{{ project?.name }}</h2>
      <el-button type="primary" @click="$router.push(`/projects/${id}/workbench`)">
        进入工作台
      </el-button>
    </div>
    <el-card v-if="project">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="ID">{{ project.id }}</el-descriptions-item>
        <el-descriptions-item label="项目名称">{{ project.name }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="statusTagType(project.status)">{{ project.status }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="设备型号">{{ project.deviceModel }}</el-descriptions-item>
        <el-descriptions-item label="板卡类型">{{ project.boardType || '-' }}</el-descriptions-item>
        <el-descriptions-item label="迁移类型">{{ project.migrationType }}</el-descriptions-item>
        <el-descriptions-item label="源版本">{{ project.sourceVersion }}</el-descriptions-item>
        <el-descriptions-item label="目标版本">{{ project.targetVersion }}</el-descriptions-item>
        <el-descriptions-item label="AI 提供商">{{ project.aiProvider }}</el-descriptions-item>
        <el-descriptions-item label="AI 模型">{{ project.aiModel || '-' }}</el-descriptions-item>
        <el-descriptions-item label="创建人">{{ project.createdBy }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ project.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="描述" :span="3">{{ project.description || '-' }}</el-descriptions-item>
        <el-descriptions-item label="错误信息" :span="3" v-if="project.errorMessage">
          <el-text type="danger">{{ project.errorMessage }}</el-text>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useProjectStore } from '../stores/project'
const route = useRoute()
const store = useProjectStore()
const id = route.params.id
const project = ref(null)
function statusTagType(s) {
  const map = { COMPLETED: 'success', FAILED: 'danger', GENERATING: 'warning', TESTING: 'warning', CREATED: 'info' }
  return map[s] || 'info'
}
onMounted(async () => { project.value = await store.fetchOne(id) })
</script>
<style scoped>
.page-header { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
.page-header h2 { margin: 0; flex: 1; }
</style>
