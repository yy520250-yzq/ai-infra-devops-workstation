

基于 WSL2 + Docker Compose 部署的完整本地 AI 工作栈，包含 Ollama（大模型推理）、Open WebUI（类 ChatGPT 界面）、PostgreSQL（数据持久化），并集成 tmux 四屏运维工作流。
## 功能特性
- **一键部署**：`docker compose up -d` 启动所有服务
- **生产级数据库**：PostgreSQL 存储用户、对话记录，重启不丢失
- **本地 AI 模型**：Ollama 支持 qwen、llama3、deepseek 等模型
- **运维工具链**：htop, iotop, tmux, kubectl, jq 等预装
- **四屏工作流**：tmux 布局（AI + SSH + 日志 + 监控）
## 技术栈
| 组件 | 技术 |
|------|------|
| 宿主环境 | Windows 11 + WSL2 (Ubuntu 22.04) |
| 容器编排 | Docker Compose |
| AI 推理 | Ollama |
| Web UI | Open WebUI |
| 数据库 | PostgreSQL 16 |
| 运维工具 | zsh, tmux, htop, iotop, kubectl |

## 快速开始

### 前提条件
- Windows 11 (或 10 19044+) 已安装 WSL2 和 Docker Desktop
- 已克隆本仓库

### 启动服务
```bash
docker compose up -d
```

### 访问 Web UI
浏览器打开 `http://localhost:3000`，注册第一个账号（自动成为管理员）。

### 下载模型示例
```bash
docker exec -it ollama ollama pull qwen2.5-coder:7b
```

### 查看服务状态
```bash
docker compose ps
```

## 数据持久化

- 模型文件、用户数据、聊天记录全部存储在 Docker 命名卷中
- 即使删除容器再重建，数据依然存在
- PostgreSQL 支持备份与迁移

## 运维工作流（tmux 四屏）

日常排障时使用以下布局：

| 窗格 | 用途 | 命令示例 |
|------|------|----------|
| pane1 | AI 助手 | `ollama run qwen2.5-coder:7b` |
| pane2 | SSH 生产服务器 | `ssh user@host` |
| pane3 | 实时日志 | `kubectl logs -f` / `tail -f` |
| pane4 | 系统监控 | `htop` / `iostat -x 1` |

启动四屏：
```bash
tmux
# Ctrl+b %  # 左右分屏
# Ctrl+b "  # 上下分屏
```

## 项目结构

```
.
├── docker-compose.yml      # 服务编排
├── bootstrap.sh            # 系统初始化脚本（zsh、oh-my-zsh、工具链）
├── .gitignore
└── README.md
```

## 常见问题
### 端口冲突
修改 `docker-compose.yml` 中 ports 映射，例如 `"3001:8080"`。
### 代理设置（国内环境）
若需加速模型下载，在 WSL2 中设置：
```bash
export hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export http_proxy="http://${hostip}:7890"
export https_proxy="http://${hostip}:7890"
```

## 后续计划
- [ ] 添加 Prometheus + Grafana 监控
- [ ] 迁移至 Kubernetes (minikube)
- [ ] 引入 vLLM 高性能推理
。
