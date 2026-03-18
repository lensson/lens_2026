<template>
  <div class="create-container">
    <div class="page-header">
      <el-button link @click="$router.back()"><el-icon><ArrowLeft /></el-icon> 返回</el-button>
      <h2>新建迁移项目</h2>
    </div>
    <el-card>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px" style="max-width:600px">
        <el-form-item label="项目名称" prop="name">
          <el-input v-model="form.name" placeholder="例：ls-mf lwlt-c 26.3→28.1" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="设备型号" prop="deviceModel">
          <el-input v-model="form.deviceModel" placeholder="例：ls-mf" />
        </el-form-item>
        <el-form-item label="板卡类型">
          <el-input v-model="form.boardType" placeholder="例：lwlt-c" />
        </el-form-item>
        <el-form-item label="源版本" prop="sourceVersion">
          <el-input v-model="form.sourceVersion" placeholder="例：26.3" />
        </el-form-item>
        <el-form-item label="目标版本" prop="targetVersion">
          <el-input v-model="form.targetVersion" placeholder="例：28.1" />
        </el-form-item>
        <el-form-item label="迁移类型" prop="migrationType">
          <el-select v-model="form.migrationType" style="width:100%">
            <el-option label="意图驱动 (Intent-Driven)" value="INTENT_DRIVEN" />
            <el-option label="Schema 驱动 (Schema-Driven)" value="SCHEMA_DRIVEN" />
            <el-option label="混合 (Hybrid)" value="HYBRID" />
          </el-select>
        </el-form-item>
        <el-form-item label="AI 提供商">
          <el-select v-model="form.aiProvider" style="width:100%">
            <el-option label="无 (规则引擎)" value="NONE" />
            <el-option label="GitHub Models" value="GITHUB" />
            <el-option label="Ollama (本地)" value="OLLAMA" />
            <el-option label="OpenAI" value="OPENAI" />
            <el-option label="Qwen" value="QWEN" />
          </el-select>
        </el-form-item>
        <el-form-item label="AI 模型" v-if="form.aiProvider !== 'NONE'">
          <el-input v-model="form.aiModel" placeholder="例：gpt-4o-mini / qwen2.5-coder:14b" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="saving" @click="submit">创建项目</el-button>
          <el-button @click="$router.back()">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useProjectStore } from '../stores/project'
const router = useRouter()
const store = useProjectStore()
const formRef = ref()
const saving = ref(false)
const form = ref({
  name: '', description: '', deviceModel: '', boardType: '',
  sourceVersion: '', targetVersion: '',
  migrationType: 'INTENT_DRIVEN', aiProvider: 'NONE', aiModel: '',
})
const rules = {
  name: [{ required: true, message: '请输入项目名称', trigger: 'blur' }],
  deviceModel: [{ required: true, message: '请输入设备型号', trigger: 'blur' }],
  sourceVersion: [{ required: true, message: '请输入源版本', trigger: 'blur' }],
  targetVersion: [{ required: true, message: '请输入目标版本', trigger: 'blur' }],
  migrationType: [{ required: true, message: '请选择迁移类型', trigger: 'change' }],
}
async function submit() {
  await formRef.value.validate()
  saving.value = true
  try {
    const project = await store.createProject(form.value)
    ElMessage.success('项目创建成功')
    router.push(`/projects/${project.id}/workbench`)
  } finally {
    saving.value = false
  }
}
</script>
<style scoped>
.create-container {}
.page-header { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
.page-header h2 { margin: 0; }
</style>
