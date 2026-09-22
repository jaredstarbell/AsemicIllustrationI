#!/usr/bin/env bash
# idempotent install for the AsemicIllustrationI Processing sketch.
# installs Processing 3.5.4 (bundles JavaFX + Java 8, required for the
# fullScreen(FX2D) renderer this sketch uses) into $HOME/opt.
set -euo pipefail

PROCESSING_VERSION="3.5.4"
PROCESSING_TAG="processing-0270-3.5.4"
PROCESSING_TARBALL="processing-${PROCESSING_VERSION}-linux64.tgz"
PROCESSING_URL="https://github.com/processing/processing/releases/download/${PROCESSING_TAG}/${PROCESSING_TARBALL}"
INSTALL_ROOT="${HOME}/opt"
PROCESSING_HOME="${INSTALL_ROOT}/processing-${PROCESSING_VERSION}"

download_with_retry() {
  local url="$1" dest="$2" attempt=1 delay=4
  while (( attempt <= 5 )); do
    if curl -fsSL -m 600 -o "$dest" "$url"; then
      return 0
    fi
    echo "download attempt ${attempt} failed; retrying in ${delay}s..." >&2
    sleep "$delay"; delay=$(( delay * 2 )); attempt=$(( attempt + 1 ))
  done
  return 1
}

if [[ -x "${PROCESSING_HOME}/processing-java" ]]; then
  echo "Processing ${PROCESSING_VERSION} already present at ${PROCESSING_HOME}"
else
  echo "Installing Processing ${PROCESSING_VERSION} to ${PROCESSING_HOME}..."
  mkdir -p "${INSTALL_ROOT}"
  tmp_tarball="$(mktemp --suffix=.tgz)"
  download_with_retry "${PROCESSING_URL}" "${tmp_tarball}"
  tar xzf "${tmp_tarball}" -C "${INSTALL_ROOT}"
  rm -f "${tmp_tarball}"
  echo "Processing installed."
fi

"${PROCESSING_HOME}/processing-java" --help >/dev/null 2>&1 || true
echo "install complete: $("${PROCESSING_HOME}/java/bin/java" -version 2>&1 | head -1)"
