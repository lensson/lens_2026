<template>
  <div>
    <div class="page-header">
      <h2>迁移项目</h2>
      <el-button type="primary" @click="$router.push('/projects/new')">
        <el-icon><Plus /></el-icon> 新建项目
      </el-button>
    </div>
    <!-- Filter Bar -->
    <el-card class="filter-card">
      <el-row :gutter="12" align="middle">
        <el-col :span="8">
          <el-input v-model="filter.keyword" placeholder="搜索项目名称..." clearable
            @change="load" prefix-icon="Search" />
        </el-col>
        <el-col :span="5">
          <el-select v-model="filter.status" placeholder="状态" clearable @change="load" style="width:100%">
            <el-option v-for="s in statusOptions" :key="s.value" :label="s.label" :value="s.value" />
          </el-select>
        </el-col>
        <el-col :span="5">
          <el-select v-model="filter.migrationType" placeholder="迁移类型" clearable @change="load" style="width:100%">
            <el-option label="意图驱动" value="INTENT_DRIVEN" />
            <el-option label="Schema驱动" value="SCHEMA_DRIVEN" />
            <el-option label="混合" value="HYBRID" />
          </el-select>
        </el-col>
        <el-col :span="3">
          <el-button @click="reset">重置</el-button>
        </el-col>
      </el-row>
    </el-card>
    <!-- Table -->
    <el-card class="table-card">
      <el-table :data="store.projects" v-loading="store.loading" stripe style="width:100%">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="name" label="项目名称" min-width="180">
          <template #default="{ row }">
            <el-button link type="primary" @click="$router.push(`/projects/${row.id}/workbench`)">
              {{ row.name }}
            </el-button>
          </template>
        </el-table-column>
        <el-table-column prop="deviceModel" label="设备型号" width="130" />
        <el-table-column label="版本" width="160">
          <template #default="{ row }">
            <el-text size="small">{{ row.sourceVersion }} → {{ row.targetVersion }}</el-text>
          </template>
        </el-table-column>
        <el-table-column prop="migrationType" label="类型" width="110">
          <template #default="{ row }">
            <el-tag :type="typeTagType(row.migrationType)" size="small">{{ row.migrationType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="130">
          <template #default="{ row }">
            <el-tag :type="statusTagType(row.status)" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="aiProvider" label="AI" width="100">
          <template #default="{ row }">
            <el-text size="small">{{ row.aiProvider || '-' }}</el-text>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" size="small"
              @click="$router.push(`/projects/${row.id}/workbench`)">工作台</el-button>
            <el-button link type="info" size="small"
              @click="$router.push(`/projects/${row.id}`)">详情</el-button>
            <el-popconfirm title="确认删除？" @confirm="remove(row.id)">
              <template #reference>
                <el-button link type="danger" size="small">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination" background layout="total, prev, pager, next"
        :total="store.total" :page-size="pageSize" v-model:current-page="page" @current-change="load" />
    </el-card>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useProjectStore } from '../stores/project'
const store = useProjectStore()
const page = ref(1)
const pageSize = 20
const filter = ref({ keyword: '', status: '', migrationType: '' })
const statusOptions = [
  { value: 'CREATED', label: 'CREATED' },
  { value: 'SCHEMA_UPLOADED', label: 'SCHEMA_UPLOADED' },
  { value: 'INTENT_UPLOADED', label: 'INTENT_UPLOADED' },
  { value: 'GENERATING', label: 'GENERATING' },
  { value: 'GENERATED', label: 'GENERATED' },
  { value: 'TESTING', label: 'TESTING' },
  { value: 'COMPLETED', label: 'COMPLETED' },
  { value: 'FAILED', label: 'FAILED' },
]
function statusTagType(s) {
  const map = { COMPLETED: 'success', FAILED: 'danger', GENERATING: 'warning', TESTING: 'warning', CREATED: 'info' }
  return map[s] || 'info'
}
function typeTagType(t) {
  const map = { INTENT_DRIVEN: '', SCHEMA_DRIVEN: 'success', HYBRID: 'warning' }
  return map[t] || ''
}
async function load() {
  const params = { page: page.value - 1, size: pageSize }
  if (filter.value.keyword) params.keyword = filter.value.keyword
  if (filter.value.status) params.status = filter.value.status
  if (filter.value.migrationType) params.migrationType = filter.value.migrationType
  await store.fetchList(params)
}
function reset() {
  filter.value = { keyword: '', status: '', migrationType: '' }
  page.value = 1
  load()
}
async function remove(id) {
  await store.removeProject(id)
  ElMessage.success('删除成功')
}
onMounted(load)
</script>
<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.page-header h2 { font-size: 20px; }
.filter-card { margin-bottom: 16px; }
.table-card {}
.pagination { margin-top: 16px; justify-content: flex-end; display: flex; }
</style>
