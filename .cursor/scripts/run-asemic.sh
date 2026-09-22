#!/usr/bin/env bash
# run the AsemicIllustrationI Processing sketch headlessly on a virtual X
# display and capture a screenshot (and optionally a video) of the generated
# art. Processing requires the sketch folder name to match the main tab, so a
# properly named folder of symlinks to the repo sources is built on the fly.
#
# usage:
#   .cursor/scripts/run-asemic.sh [--seconds N] [--size WxH]
#                                 [--screenshot PATH] [--video PATH]
set -euo pipefail

SECONDS_TO_RUN=12
SIZE="1400x900"
SCREENSHOT=""
VIDEO=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --seconds) SECONDS_TO_RUN="$2"; shift 2 ;;
    --size) SIZE="$2"; shift 2 ;;
    --screenshot) SCREENSHOT="$2"; shift 2 ;;
    --video) VIDEO="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROCESSING_HOME="${HOME}/opt/processing-3.5.4"
PROCESSING_JAVA="${PROCESSING_HOME}/processing-java"

if [[ ! -x "${PROCESSING_JAVA}" ]]; then
  echo "Processing not found at ${PROCESSING_HOME}; run .cursor/scripts/install.sh first" >&2
  exit 1
fi

# build a sketch folder named after the main tab, linking to repo sources.
SKETCH_ROOT="$(mktemp -d)"
SKETCH_DIR="${SKETCH_ROOT}/AsemicIllustrationI"
mkdir -p "${SKETCH_DIR}"
for f in "${REPO_ROOT}"/*.pde; do ln -sf "$f" "${SKETCH_DIR}/"; done
ln -sfn "${REPO_ROOT}/data" "${SKETCH_DIR}/data"

# pick a free-ish display number.
DISPLAY_NUM=99
while [[ -e "/tmp/.X11-unix/X${DISPLAY_NUM}" ]]; do DISPLAY_NUM=$(( DISPLAY_NUM + 1 )); done
export DISPLAY=":${DISPLAY_NUM}"

Xvfb ":${DISPLAY_NUM}" -screen 0 "${SIZE}x24" >/tmp/asemic-xvfb.log 2>&1 &
XVFB_PID=$!
SKETCH_PID=""

cleanup() {
  [[ -n "${SKETCH_PID}" ]] && kill "${SKETCH_PID}" 2>/dev/null || true
  kill "${XVFB_PID}" 2>/dev/null || true
  rm -rf "${SKETCH_ROOT}"
}
trap cleanup EXIT
sleep 2

OUT_DIR="${SKETCH_ROOT}/build-out"
"${PROCESSING_JAVA}" --sketch="${SKETCH_DIR}" --output="${OUT_DIR}" --force --run \
  >/tmp/asemic-sketch.log 2>&1 &
SKETCH_PID=$!

echo "running AsemicIllustrationI for ${SECONDS_TO_RUN}s on ${DISPLAY} (${SIZE})..."
sleep "${SECONDS_TO_RUN}"

if ! kill -0 "${SKETCH_PID}" 2>/dev/null; then
  echo "sketch exited early; log:" >&2
  tail -40 /tmp/asemic-sketch.log >&2
  exit 1
fi

if [[ -n "${VIDEO}" ]]; then
  mkdir -p "$(dirname "${VIDEO}")"
  ffmpeg -y -f x11grab -framerate 20 -video_size "${SIZE}" -i "${DISPLAY}.0" \
    -t 8 -pix_fmt yuv420p "${VIDEO}" >/tmp/asemic-ffmpeg-video.log 2>&1
  echo "video saved: ${VIDEO}"
fi

if [[ -z "${SCREENSHOT}" ]]; then
  SCREENSHOT="/tmp/asemic-frame.png"
fi
mkdir -p "$(dirname "${SCREENSHOT}")"
ffmpeg -y -f x11grab -video_size "${SIZE}" -i "${DISPLAY}.0" -frames:v 1 \
  "${SCREENSHOT}" >/tmp/asemic-ffmpeg-shot.log 2>&1
echo "screenshot saved: ${SCREENSHOT}"

echo "done."
