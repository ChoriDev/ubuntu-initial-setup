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
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh My Zsh는 이미 설치되어 있습니다."
fi

# Git 사용자 이름 입력 받기
echo "Git 사용자 이름을 입력하세요: "
read git_username
git config --global user.name "$git_username"

# Git 사용자 이메일 입력 받기
echo "Git 사용자 이메일을 입력하세요: "
read git_email
git config --global user.email "$git_email"

# Git 기본 에디터 설정
git config --global core.editor vim

# Zsh 플러그인 설치
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Powerlevel10k 테마 설치
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# zsh-syntax-highlighting 플러그인 설치
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting 플러그인은 이미 설치되어 있습니다."
fi

# zsh-autosuggestions 플러그인 설치
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions 플러그인은 이미 설치되어 있습니다."
fi

# .zshrc 파일에 플러그인 추가 및 Powerlevel10k 테마 설정
if ! grep -q "plugins=(" ~/.zshrc; then
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' >> ~/.zshrc
else
    sed -i '/^plugins=/ s/)$/ zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
fi

# Powerlevel10k 테마 설정
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# .zshrc 파일을 올바른 형식으로 설정
if ! grep -q "source \$ZSH/oh-my-zsh.sh" ~/.zshrc; then
    echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
fi

# Zsh로 변경
exec zsh