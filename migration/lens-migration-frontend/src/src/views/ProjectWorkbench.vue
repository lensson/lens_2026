<template>
  <div v-loading="loading">
    <div class="page-header">
      <el-button link @click="$router.push('/projects')"><el-icon><ArrowLeft /></el-icon> 项目列表</el-button>
      <h2>{{ project?.name }}</h2>
      <el-tag v-if="project" :type="statusTagType(project.status)">{{ project.status }}</el-tag>
    </div>
    <el-tabs v-model="activeTab" type="card">
      <!-- Step 1: Schema -->
      <el-tab-pane label="① Yang Schema" name="schema">
        <el-card>
          <template #header>
            <span>Yang Schema 管理</span>
            <el-button type="primary" size="small" style="float:right" @click="showAddSchema=true">
              添加 Schema
            </el-button>
          </template>
          <el-table :data="schemas" style="width:100%">
            <el-table-column prop="schemaVersion" label="版本" width="120" />
            <el-table-column prop="schemaType" label="类型" width="100" />
            <el-table-column prop="isDeviation" label="Deviation" width="100">
              <template #default="{ row }">
                <el-tag :type="row.isDeviation ? 'warning' : 'info'" size="small">
                  {{ row.isDeviation ? 'Yes' : 'No' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="fileName" label="文件名" />
            <el-table-column label="操作" width="80">
              <template #default="{ row }">
                <el-button link type="danger" size="small" @click="removeSchema(row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      <!-- Step 2: Examples -->
      <el-tab-pane label="② XML 样本" name="example">
        <el-card>
          <template #header>
            <span>XML 样本对管理</span>
            <el-button type="primary" size="small" style="float:right" @click="showAddExample=true">
              添加样本对
            </el-button>
          </template>
          <el-table :data="examples" style="width:100%">
            <el-table-column prop="name" label="名称" />
            <el-table-column prop="operationType" label="操作类型" width="120" />
            <el-table-column label="输入 XML 预览" min-width="200">
              <template #default="{ row }">
                <el-text size="small" line-clamp="2">{{ row.inputXmlContent?.substring(0, 80) }}...</el-text>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="80">
              <template #default="{ row }">
                <el-button link type="danger" size="small" @click="removeExample(row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      <!-- Step 3: Intent -->
      <el-tab-pane label="③ 意图文档" name="intent">
        <el-card>
          <template #header>
            <span>迁移意图文档 (Markdown)</span>
            <el-button type="primary" size="small" style="float:right" @click="saveIntent">保存意图</el-button>
          </template>
          <el-input v-model="intentContent" type="textarea" :rows="20"
            placeholder="在此输入 Markdown 格式的迁移意图，描述规则如 RENAME、ADD_NODE、DELETE_NODE..." />
        </el-card>
      </el-tab-pane>
      <!-- Step 4: Generate -->
      <el-tab-pane label="④ XSLT 生成" name="generate">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-card>
              <template #header><span>生成控制</span></template>
              <el-form label-width="100px">
                <el-form-item label="AI 提供商">
                  <el-select v-model="genForm.aiProvider" style="width:100%">
                    <el-option label="规则引擎 (无AI)" value="NONE" />
                    <el-option label="GitHub Models" value="GITHUB" />
                    <el-option label="Ollama (本地)" value="OLLAMA" />
                    <el-option label="OpenAI" value="OPENAI" />
                  </el-select>
                </el-form-item>
                <el-form-item label="AI 模型" v-if="genForm.aiProvider !== 'NONE'">
                  <el-input v-model="genForm.aiModel" placeholder="例：gpt-4o-mini" />
                </el-form-item>
                <el-form-item label="最大轮数" v-if="genForm.aiProvider !== 'NONE'">
                  <el-input-number v-model="genForm.maxRounds" :min="1" :max="5" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" :loading="generating" @click="doGenerate">
                    <el-icon><MagicStick /></el-icon> 生成 XSLT
                  </el-button>
                  <el-button @click="doRunTests" :loading="testing" style="margin-left:8px">
                    <el-icon><VideoPlay /></el-icon> 运行测试
                  </el-button>
                </el-form-item>
              </el-form>
            </el-card>
          </el-col>
          <el-col :span="12">
            <el-card>
              <template #header><span>最新测试结果</span></template>
              <div v-if="testRun">
                <el-descriptions :column="2" border size="small">
                  <el-descriptions-item label="状态">
                    <el-tag :type="testRun.status === 'PASSED' ? 'success' : 'danger'">{{ testRun.status }}</el-tag>
                  </el-descriptions-item>
                  <el-descriptions-item label="通过">{{ testRun.passCount || 0 }}</el-descriptions-item>
                  <el-descriptions-item label="失败">{{ testRun.failCount || 0 }}</el-descriptions-item>
                  <el-descriptions-item label="出错">{{ testRun.errorCount || 0 }}</el-descriptions-item>
                </el-descriptions>
              </div>
              <el-empty v-else description="暂无测试记录" :image-size="60" />
            </el-card>
          </el-col>
        </el-row>
        <!-- XSLT Preview -->
        <el-card style="margin-top:16px" v-if="activeXslt">
          <template #header>
            <span>当前 XSLT (v{{ activeXslt.version }})</span>
            <el-button size="small" style="float:right" @click="downloadXslt">下载</el-button>
          </template>
          <pre class="xslt-preview">{{ activeXslt.content }}</pre>
        </el-card>
      </el-tab-pane>
    </el-tabs>
    <!-- Add Schema Dialog -->
    <el-dialog v-model="showAddSchema" title="添加 Yang Schema" width="500px">
      <el-form :model="schemaForm" label-width="100px">
        <el-form-item label="版本">
          <el-input v-model="schemaForm.schemaVersion" placeholder="例：26.3" />
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="schemaForm.schemaType" style="width:100%">
            <el-option label="SOURCE" value="SOURCE" />
            <el-option label="TARGET" value="TARGET" />
          </el-select>
        </el-form-item>
        <el-form-item label="Deviation">
          <el-switch v-model="schemaForm.isDeviation" />
        </el-form-item>
        <el-form-item label="文件名">
          <el-input v-model="schemaForm.fileName" placeholder="例：device-extension-ls-mf-26.3.zip" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddSchema=false">取消</el-button>
        <el-button type="primary" @click="addSchema">确认</el-button>
      </template>
    </el-dialog>
    <!-- Add Example Dialog -->
    <el-dialog v-model="showAddExample" title="添加 XML 样本对" width="700px">
      <el-form :model="exampleForm" label-width="100px">
        <el-form-item label="名称">
          <el-input v-model="exampleForm.name" placeholder="例：classifier-sample-01" />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="exampleForm.operationType" style="width:100%">
            <el-option label="CREATE" value="CREATE" />
            <el-option label="EDIT" value="EDIT" />
            <el-option label="DELETE" value="DELETE" />
            <el-option label="GET" value="GET" />
          </el-select>
        </el-form-item>
        <el-form-item label="输入 XML (旧版本)">
          <el-input v-model="exampleForm.inputXmlContent" type="textarea" :rows="6"
            placeholder="粘贴旧版本 XML..." />
        </el-form-item>
        <el-form-item label="期望 XML (新版本)">
          <el-input v-model="exampleForm.expectedXmlContent" type="textarea" :rows="6"
            placeholder="粘贴新版本 XML..." />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddExample=false">取消</el-button>
        <el-button type="primary" @click="addExample">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useProjectStore } from '../stores/project'
import { schemaApi, exampleApi, intentApi, generateApi } from '../api'
const route = useRoute()
const store = useProjectStore()
const id = Number(route.params.id)
const project = ref(null)
const loading = ref(false)
const activeTab = ref('schema')
const schemas = ref([])
const examples = ref([])
const intentContent = ref('')
const activeXslt = ref(null)
const testRun = ref(null)
const generating = ref(false)
const testing = ref(false)
const showAddSchema = ref(false)
const showAddExample = ref(false)
const schemaForm = ref({ schemaVersion: '', schemaType: 'SOURCE', isDeviation: false, fileName: '' })
const exampleForm = ref({ name: '', operationType: 'CREATE', inputXmlContent: '', expectedXmlContent: '' })
const genForm = ref({ aiProvider: 'NONE', aiModel: '', maxRounds: 3 })
function statusTagType(s) {
  const map = { COMPLETED: 'success', FAILED: 'danger', GENERATING: 'warning', TESTING: 'warning', CREATED: 'info' }
  return map[s] || 'info'
}
async function loadAll() {
  loading.value = true
  try {
    project.value = await store.fetchOne(id)
    if (project.value?.aiProvider) genForm.value.aiProvider = project.value.aiProvider
    if (project.value?.aiModel) genForm.value.aiModel = project.value.aiModel
    const [schemaRes, exampleRes] = await Promise.all([
      schemaApi.list(id),
      exampleApi.list(id),
    ])
    schemas.value = schemaRes.data || []
    examples.value = exampleRes.data || []
    try {
      const intentRes = await intentApi.getActive(id)
      intentContent.value = intentRes.data?.content || ''
    } catch {}
    try {
      const xsltRes = await generateApi.getActiveXslt(id)
      activeXslt.value = xsltRes.data
    } catch {}
    try {
      const testRes = await generateApi.getLatestTestRun(id)
      testRun.value = testRes.data
    } catch {}
  } finally {
    loading.value = false
  }
}
async function addSchema() {
  await schemaApi.add(id, { ...schemaForm.value, projectId: id })
  ElMessage.success('Schema 添加成功')
  showAddSchema.value = false
  const res = await schemaApi.list(id)
  schemas.value = res.data || []
}
async function removeSchema(schemaId) {
  await schemaApi.remove(id, schemaId)
  ElMessage.success('删除成功')
  schemas.value = schemas.value.filter(s => s.id !== schemaId)
}
async function addExample() {
  await exampleApi.add(id, { ...exampleForm.value, projectId: id })
  ElMessage.success('样本对添加成功')
  showAddExample.value = false
  const res = await exampleApi.list(id)
  examples.value = res.data || []
}
async function removeExample(exId) {
  await exampleApi.remove(id, exId)
  ElMessage.success('删除成功')
  examples.value = examples.value.filter(e => e.id !== exId)
}
async function saveIntent() {
  await intentApi.add(id, { projectId: id, content: intentContent.value, version: '1.0' })
  ElMessage.success('意图文档已保存')
}
async function doGenerate() {
  generating.value = true
  try {
    const payload = { projectId: id, aiProvider: genForm.value.aiProvider }
    if (genForm.value.aiModel) payload.aiModel = genForm.value.aiModel
    if (genForm.value.maxRounds) payload.maxRounds = genForm.value.maxRounds
    const res = await generateApi.generateXslt(id, payload)
    activeXslt.value = res.data
    ElMessage.success('XSLT 生成成功')
    project.value = await store.fetchOne(id)
  } finally {
    generating.value = false
  }
}
async function doRunTests() {
  testing.value = true
  try {
    const res = await generateApi.runTests(id, { projectId: id })
    testRun.value = res.data
    ElMessage.success('测试完成')
  } finally {
    testing.value = false
  }
}
function downloadXslt() {
  if (!activeXslt.value?.content) return
  const blob = new Blob([activeXslt.value.content], { type: 'application/xml' })
  const a = document.createElement('a')
  a.href = URL.createObjectURL(blob)
  a.download = `migration-transform-v${activeXslt.value.version}.xslt`
  a.click()
}
onMounted(loadAll)
</script>
<style scoped>
.page-header { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
.page-header h2 { margin: 0; flex: 1; }
.xslt-preview {
  background: #1e1e1e; color: #d4d4d4;
  padding: 16px; border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-size: 12px; max-height: 400px;
  overflow: auto; white-space: pre-wrap;
}
</style>
