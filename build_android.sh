#!/usr/bin/env bash
# Builda o app Android.
#
#   ./build_android.sh                  # APK release
#   ./build_android.sh appbundle        # AAB para a Play Store
#   ./build_android.sh apk --debug      # argumentos extras vão para `flutter build`
set -euo pipefail

cd "$(dirname "$0")"

# Usa o flutter do PATH; se não houver, o SDK apontado em android/local.properties.
if command -v flutter >/dev/null; then
  FLUTTER=flutter
else
  sdk=$(sed -n 's/^flutter\.sdk=//p' android/local.properties 2>/dev/null || true)
  FLUTTER="$sdk/bin/flutter"
  if [[ -z "$sdk" || ! -x "$FLUTTER" ]]; then
    echo "flutter não encontrado: ponha no PATH ou defina flutter.sdk em android/local.properties" >&2
    exit 1
  fi
fi

target=${1:-apk}
[[ $# -gt 0 ]] && shift

"$FLUTTER" pub get
# Regenera o código do drift (lib/data/database.g.dart).
"$FLUTTER" pub run build_runner build
"$FLUTTER" build "$target" "$@"
