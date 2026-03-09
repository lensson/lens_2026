# IDEA 性能分析与优化记录

> 记录日期：2026-03-09  
> 机器：host-192-168-0-5 (本机开发环境)

---

## 一、系统硬件概览

| 项目 | 参数 |
|------|------|
| CPU 型号 | Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz |
| CPU 核心 | 2 个 Socket × 8 核 = 16 逻辑核（无超线程） |
| 总内存 | 54 GB |
| Swap | 15 GB |
| 操作系统 | Linux（Ubuntu） |

---

## 二、优化前状态

### IDEA 默认 JVM 启动参数（优化前）

从 IDEA 进程启动命令中可以看到，优化前实际生效的参数为 IDEA 默认值：

```
-Xms128m
-Xmx2048m
-XX:ReservedCodeCacheSize=512m
-XX:CICompilerCount=2
```

### 优化前内存使用（估算）

| 进程 | 内存占用（RSS）|
|------|--------------|
| IDEA 主进程 | ~2GB（受 Xmx2048m 限制） |
| Copilot 语言服务 | ~0.9GB |
| 其他服务（Nacos、Keycloak等）| ~2-3GB |
| **系统总使用** | ~7-9GB |

**主要问题：**
- IDEA 堆上限仅 2GB，工程较大时频繁 GC，导致卡顿
- `CICompilerCount=2` 编译线程不足，代码分析/索引慢
- `SoftRefLRUPolicyMSPerMB` 未配置，soft reference 清理过激，缓存失效频繁

---

## 三、优化后配置

### 当前 `idea64.vmoptions` 文件

路径：`/home/zhenac/.config/JetBrains/IntelliJIdea2025.2/idea64.vmoptions`

```properties
# 堆内存设置
-Xms1g
-Xmx8g
-Xss2m

# GC 策略：G1GC，适合大堆低延迟
-XX:+UseG1GC
-XX:MaxGCPauseMillis=100
-XX:InitiatingHeapOccupancyPercent=35
-XX:G1ReservePercent=15

# 内存优化
-XX:+UseStringDeduplication
-XX:SoftRefLRUPolicyMSPerMB=50
-XX:JbrShrinkingGcMaxHeapFreeRatio=40
-XX:ReservedCodeCacheSize=512m

# 稳定性
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:CICompilerCount=4

# 兼容性与调试
-XX:+IgnoreUnrecognizedVMOptions
-XX:+UnlockDiagnosticVMOptions
-XX:TieredOldPercentage=100000
-ea
```

### 主要改动说明

| 参数 | 优化前 | 优化后 | 说明 |
|------|--------|--------|------|
| `-Xms` | 128m | 1g | 初始堆预分配，避免频繁扩展 |
| `-Xmx` | 2048m | 8g | 最大堆扩大，减少 GC 频率 |
| `-XX:CICompilerCount` | 2 | 4 | 更多 JIT 编译线程，加快代码索引 |
| `-XX:+UseG1GC` | 无 | 有 | 使用 G1GC，低停顿适合大堆 |
| `-XX:MaxGCPauseMillis` | 无 | 100ms | GC 停顿目标，降低卡顿感知 |
| `-XX:SoftRefLRUPolicyMSPerMB` | 无 | 50 | 保留更多软引用缓存，加快补全 |
| `-XX:+UseStringDeduplication` | 无 | 有 | G1GC 字符串去重，节省堆内存 |
| `-Xss` | 默认 | 2m | 增大线程栈，防止深递归 SOE |

---

## 四、优化后系统内存状态（2026-03-09）

```
              total        used        free      shared  buff/cache   available
Mem:           54Gi        10Gi        37Gi        82Mi       6.5Gi        43Gi
Swap:          15Gi          0B        15Gi
```

### 主要进程内存占用排名

| 进程 | PID | %CPU | %MEM | RSS | 说明 |
|------|-----|------|------|-----|------|
| IDEA 主进程 (java) | 15415 | 251% | 11.5% | ~6.5GB | 堆已扩展到 6.5GB |
| Copilot 语言服务 | 16069 | 9.1% | 2.6% | ~1.5GB | Github Copilot agent |
| Nacos Server | 2873 | 6.9% | 1.9% | ~1.1GB | 配置中心 |
| Keycloak | 2865 | 2.2% | 0.7% | ~443MB | 认证服务 |
| kube-apiserver | 3857 | 4.9% | 0.5% | ~315MB | Minikube |
| GNOME Shell | 11259 | 22.1% | 0.6% | ~399MB | 桌面环境 |
| Docker Daemon | 1043 | 5.6% | 0.3% | ~229MB | 容器运行时 |
| etcd | 3807 | 2.1% | 0.2% | ~142MB | Minikube etcd |

**内存总结：**
- 系统总内存 54GB，当前使用约 10GB，可用约 43GB
- Swap 完全未使用（0B），说明内存压力很小
- IDEA 本身 RSS 约 6.5GB，在 8GB 上限内运行良好

---

## 五、优化效果对比

| 指标 | 优化前 | 优化后 | 改善 |
|------|--------|--------|------|
| IDEA 最大可用堆 | 2GB | 8GB | +6GB，减少 OOM 风险 |
| GC 停顿目标 | 无限制 | ≤100ms | 卡顿减少 |
| GC 算法 | 默认（串行/并行）| G1GC | 大堆更适合 |
| JIT 编译线程 | 2 | 4 | 代码索引更快 |
| 系统内存压力 | 中等 | 低（Swap=0）| 内存充裕 |

---

## 六、注意事项与建议

### 当前环境同时运行的服务较多

| 服务 | 内存 | 建议 |
|------|------|------|
| Minikube（k8s）| ~1GB+ | 不需要时可 `minikube stop` |
| Nacos | ~1.1GB | 开发时保持运行 |
| Keycloak | ~443MB | 开发时保持运行 |
| Docker | ~229MB | 常驻 |

**建议：** 若不使用 Kubernetes，运行 `minikube stop` 可释放约 1.5-2GB 内存。

### IDEA 插件建议

- 定期清理不用的插件（每个插件都会增加内存占用）
- 对于大型项目，可在 IDEA 中开启 **Power Save Mode**（低电量模式）暂时停止后台分析

### 遇到卡顿时的排查步骤

1. 打开 IDEA → **Help → Diagnostic Tools → Activity Monitor** 查看当前耗时任务
2. 运行 `jcmd <pid> GC.run` 手动触发 GC 释放内存
3. 检查 IDEA 日志：`~/.cache/JetBrains/IntelliJIdea2025.2/log/idea.log`

---

## 七、备注

- `idea64.vmoptions` 修改后需重启 IDEA 生效
- 之前曾尝试添加 `-XX:G1NewSizePercent` 导致 IDEA 无法启动（该参数需要 `-XX:+UnlockExperimentalVMOptions` 前置），已回滚
- 当前配置已在 2025.2 版本 (IU-252.23892.409) 验证可正常启动

