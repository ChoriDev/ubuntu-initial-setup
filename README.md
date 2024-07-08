# Ubuntu에 zsh 설치 및 초기 셋업 스크립트

이 스크립트는 Ubuntu 환경에서 zsh와 Oh My Zsh를 설치하고 설정하는 간편한 방법을 제공합니다.

## 사용법

1. 레포지토리 클론

``` shell
git clone https://github.com/ChoriDev/ubuntu-initial-setup.git
```

2. 스크립트 실행

클론한 디렉토리로 이동하여 스크립트를 실행합니다
``` shell
cd ubuntu-initial-setup
./ubuntu-initial-setup.sh
```

## 수행하는 작업 리스트

1. 우분투 버전에 따라 적절하게 패키지 저장소를 카카오 미러로 변경합니다.
    - Ubuntu 22.04: /etc/apt/sources.list 파일을 백업하고 수정합니다.
    - Ubuntu 24.04: /etc/apt/sources.list.d/ubuntu.sources 파일을 백업하고 수정합니다.
2. 패키지를 업데이트하고 필요한 패키지를 설치합니다.
3. zsh를 설치합니다. (이미 설치되어 있는지 확인 후 없으면 설치)
4. Oh My Zsh를 설치합니다. (이미 설치되어 있는지 확인 후 없으면 설치)
4. Git 사용자 설정을 진행합니다.
    - 사용자 이름 설정
    - 사용자 이메일 설정
    - 기본 에디터를 vim을 변경
    - 초기 브랜치를 main으로 설정
5. Powerlevel10k 테마와 zsh-syntax-highlighting, zsh-autosuggestions 플러그인을 설치합니다.
6. bash 셸을 zsh 셸로 변경합니다.

## 주의사항

- 스크립트는 WSL2에 등록하는 Ubuntu 배포판에 맞춰서 작성되었습니다.
- 패키지 저장소는 Ubuntu의 버전이 22.04 또는 24.04인 경우에만 변경됩니다.
- 스크립트가 변경하는 내용을 이해하고 확인한 후 사용하시기를 권장합니다.
- powerlevel10k 테마 적용 시 일부 문자가 깨져 보일 수 있습니다.
    - 필요 시 [powerlevel10k 깃허브](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k)를 참고하여 글꼴을 설치하면 됩니다.