#!/bin/sh

# 우분투 버전 확인
ubuntu_version=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2)

# 백업 및 패키지 저장소 변경
if [ "$ubuntu_version" = "22.04" ]; then
    # 22.04 버전 처리
    sudo cp -p /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d)
    sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
elif [ "$ubuntu_version" = "24.04" ]; then
    # 24.04 버전 처리
    sudo cp -p /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak.$(date +%Y%m%d)
    sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list.d/ubuntu.sources
else
    echo "지원하지 않는 우분투 버전입니다."
    exit 1
fi

# 업데이트 및 업그레이드: 패키지 목록을 업데이트하고 업그레이드, 불필요한 패키지 제거
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# zsh 설치 (이미 설치되어 있는지 확인)
if ! command -v zsh >/dev/null 2>&1; then
    sudo apt install -y zsh
else
    echo "zsh는 이미 설치되어 있습니다."
fi

# Oh My Zsh 설치 (이미 설치되어 있는지 확인)
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh My Zsh는 이미 설치되어 있습니다."
fi

# Git 사용자 이름 입력 받기
echo "Git 사용자 이름을 입력하세요:"
read git_username
if [ -n "$git_username" ]; then
    git config --global user.name "$git_username"
else
    echo "Git 사용자 이름을 입력하지 않았습니다. 설정을 건너뜁니다."
fi

# Git 사용자 이메일 입력 받기
echo "Git 사용자 이메일을 입력하세요:"
read git_email
if [ -n "$git_email" ]; then
    git config --global user.email "$git_email"
else
    echo "Git 사용자 이메일을 입력하지 않았습니다. 설정을 건너뜁니다."
fi

# Git 기본 에디터 설정
git config --global core.editor vim

# Git 초기 브랜치 설정
git config --global init.defaultBranch main

# 한글 패키지 설치 확인 후 설치
if ! dpkg -l | grep -q language-pack-ko; then
    sudo apt install -y language-pack-ko
else
    echo "한글 패키지는 이미 설치되어 있습니다."
fi

# 한글 로케일 설치 및 설정
sudo locale-gen ko_KR.UTF-8 && sudo update-locale LANG=ko_KR.UTF-8 LC_ALL=ko_KR.UTF-8

# zsh 플러그인 설치
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Powerlevel10k 테마 설치
POWERLEVEL10K_DIR="${ZSH_CUSTOM}/themes/powerlevel10k"
if [ ! -d "$POWERLEVEL10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_DIR"
else
    echo "Powerlevel10k 테마는 이미 설치되어 있습니다."
fi

# zsh-syntax-highlighting 플러그인 설치
ZSH_SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
else
    echo "zsh-syntax-highlighting 플러그인은 이미 설치되어 있습니다."
fi

# zsh-autosuggestions 플러그인 설치
ZSH_AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGESTIONS_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_DIR"
else
    echo "zsh-autosuggestions 플러그인은 이미 설치되어 있습니다."
fi

# .zshrc 파일에 플러그인 추가 및 Powerlevel10k 테마 설정
ZSHRC_FILE="$HOME/.zshrc"
if ! grep -q "plugins=(" "$ZSHRC_FILE"; then
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' >> "$ZSHRC_FILE"
else
    sed -i '/^plugins=/ s/)$/ zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC_FILE"
fi

# Powerlevel10k 테마 설정
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC_FILE"

# .zshrc 파일을 올바른 형식으로 설정
if ! grep -q "source \$ZSH/oh-my-zsh.sh" "$ZSHRC_FILE"; then
    echo 'source $ZSH/oh-my-zsh.sh' >> "$ZSHRC_FILE"
fi

# zsh로 변경
exec zsh