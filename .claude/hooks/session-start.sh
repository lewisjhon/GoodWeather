#!/bin/bash
# Claude Code on the web 세션 시작 시 Flutter SDK 를 설치하고 의존성을 받아
# `flutter analyze` 등이 바로 동작하도록 준비한다.
#
# - 이 저장소는 Dart `>=2.18.5 <3.0.0` 라 Dart 2.19.6 을 포함한 Flutter 3.7.12 로 고정한다.
# - 컨테이너 상태는 훅 완료 후 캐시되므로 두 번째 세션부터는 설치 단계를 건너뛴다(멱등).
# - 로컬(비원격) 실행에서는 시스템 Flutter 를 건드리지 않도록 아무 것도 하지 않는다.
set -euo pipefail

# 원격(웹) 환경에서만 동작
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_DIR=/opt/flutter
FLUTTER_VERSION=3.7.12

# 1. Flutter SDK (없을 때만 설치)
if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Installing Flutter ${FLUTTER_VERSION}..."
  curl -fSL -o /tmp/flutter.tar.xz \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  mkdir -p /opt
  tar -xJf /tmp/flutter.tar.xz -C /opt
  rm -f /tmp/flutter.tar.xz
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# git "dubious ownership" 회피 + 애널리틱스 비활성화(실패해도 무시)
git config --global --add safe.directory "$FLUTTER_DIR" 2>/dev/null || true
git config --global --add safe.directory "${CLAUDE_PROJECT_DIR:-$PWD}" 2>/dev/null || true
flutter config --no-analytics >/dev/null 2>&1 || true

# 2. 의존성 설치 (컨테이너 캐시 활용을 위해 pub get)
cd "${CLAUDE_PROJECT_DIR:-$PWD}"
flutter pub get 2>&1 | tail -3

# 3. 이후 세션 명령에서 flutter 가 PATH 에 잡히도록 영속화
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"${FLUTTER_DIR}/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

echo "Flutter ready: $(${FLUTTER_DIR}/bin/flutter --version 2>/dev/null | head -1)"
