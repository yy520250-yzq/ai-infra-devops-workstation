#!/usr/bin/env bash

set -e

echo "=================================================="
echo " Linux DevOps AI Workstation"
echo " WSL2 + Ollama + Qwen2.5-Coder 7B"
echo "=================================================="

sleep 1

# --------------------------------------------------
# 1. 更新系统
# --------------------------------------------------
echo "[1/9] 更新系统..."

sudo apt update
sudo apt upgrade -y

# --------------------------------------------------
# 2. 安装基础工具
# --------------------------------------------------
echo "[2/9] 安装基础运维工具..."

sudo apt install -y \
git \
curl \
wget \
vim \
zsh \
tmux \
htop \
btop \
iotop \
iftop \
net-tools \
dnsutils \
tcpdump \
traceroute \
mtr \
nmap \
jq \
fzf \
ripgrep \
fd-find \
bat \
tree \
zip \
unzip \
python3-pip \
ca-certificates \
gnupg \
lsb-release

# --------------------------------------------------
# 3. 安装 Oh My Zsh（静默）
# --------------------------------------------------
echo "[3/9] 安装 Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then

  export RUNZSH=no
  export CHSH=no

  sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  "" --unattended
fi

# --------------------------------------------------
# 4. 配置 Zsh
# --------------------------------------------------
echo "[4/9] 配置 Zsh..."

cat > "$HOME/.zshrc" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
git
sudo
history
extract
fzf
)

source $ZSH/oh-my-zsh.sh

# -----------------------------
# Alias
# -----------------------------
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# -----------------------------
# Editor
# -----------------------------
export EDITOR=vim

# -----------------------------
# PATH
# -----------------------------
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------
# History
# -----------------------------
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
EOF

# --------------------------------------------------
# 5. 设置默认 Shell
# --------------------------------------------------
echo "[5/9] 设置 zsh 为默认 shell..."

if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)" || true
fi

# --------------------------------------------------
# 6. 安装 Ollama
# --------------------------------------------------
echo "[6/9] 安装 Ollama..."

curl -fsSL https://ollama.com/install.sh | sh

# --------------------------------------------------
# 7. 检查 Ollama 服务
# --------------------------------------------------
echo "[7/9] 检查 Ollama 服务..."

sleep 5

if ! ollama list >/dev/null 2>&1; then
  echo ""
  echo "❌ Ollama 服务未启动"
  echo ""
  echo "请手动执行："
  echo "ollama serve"
  echo ""
  exit 1
fi

# --------------------------------------------------
# 8. 创建工作目录
# --------------------------------------------------
echo "[8/9] 创建工作目录..."

mkdir -p ~/workspace
mkdir -p ~/infra
mkdir -p ~/k8s
mkdir -p ~/scripts

# --------------------------------------------------
# 9. 完成提示
# --------------------------------------------------
echo "[9/9] 安装完成"

echo ""
echo "=================================================="
echo " ✅ Linux AI 运维环境安装完成"
echo "=================================================="

echo ""
echo "下一步："
echo ""

echo "1. 重启 WSL："
echo "   exit"
echo ""
echo "2. Windows PowerShell 执行："
echo "   wsl --shutdown"
echo ""
echo "3. 重新进入 Ubuntu"
echo ""
echo "4. 下载 AI 模型："
echo "   ollama pull qwen2.5-coder:7b"
echo ""
echo "5. 启动 AI："
echo "   ollama run qwen2.5-coder:7b"
echo ""

echo "推荐 AI 运维问题："
echo ""
echo "  帮我分析 Linux 负载高"
echo "  帮我分析 Docker 容器异常"
echo "  帮我生成 Kubernetes YAML"
echo "  帮我排查 nginx 502"
echo "  帮我分析网络连通性"
echo ""

echo "推荐 tmux 工作流："
echo ""
echo "tmux"
echo "├── pane1: ollama"
echo "├── pane2: ssh"
echo "├── pane3: kubectl logs"
echo "└── pane4: htop"
echo ""
