#!/bin/sh

# 백업: /etc/apt/sources.list 파일을 백업
sudo cp -p /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d)

# 패키지 저장소를 카카오 미러로 변경
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

# 업데이트 및 업그레이드: 패키지 목록을 업데이트하고 업그레이드, 불필요한 패키지 제거
sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove

# Zsh 설치 (이미 설치되어 있는지 확인)
if ! command -v zsh >/dev/null 2>&1; then
    sudo apt -y install zsh
else
    echo "Zsh는 이미 설치되어 있습니다."
fi

# Oh My Zsh 설치 (이미 설치되어 있는지 확인)
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh My Zsh는 이미 설치되어 있습니다."
fi

# Git 사용자 이름 입력 받기
echo "Git 사용자 이름을 입력하세요: "
read git_username
if [ -n "$git_username" ]; then
    git config --global user.name "$git_username"
else
    echo "Git 사용자 이름을 입력하지 않았습니다. 설정을 건너뜁니다."
fi

# Git 사용자 이메일 입력 받기
echo "Git 사용자 이메일을 입력하세요: "
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

# Zsh 플러그인 설치
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

# Zsh를 기본 셸로 설정 및 적용
chsh -s "$(which zsh)"

# 현재 셸을 새로운 셸로 변경
exec "$(which zsh)"

echo "스크립트 실행이 완료되었습니다."