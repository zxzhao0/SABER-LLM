#!/bin/bash
# Usage: bash infer.sh <model_path> <input_jsonl> <result_path> [gpu_id]
# Example: bash infer.sh MODEL/SABEER-LLM data.jsonl result.jsonl 0
#
# Model download URL: https://huggingface.co/zhaoxiaoxian/SABER-LLM
#
# The `input_jsonl` file should be in the following format:
# {"messages": [{"role": "user", "content": "请通过依次完成以下任务，对提供的媒体进行一次全面的多模态分析：\n- 请详细描述视频的场景及其背景信息。\n- 请对这段音频进行详细分析。\n- 请详细分析说话者的面部表情和肢体语言。\n- 最后，请综合以上所有观察结果，对说话者的情绪状态进行全面分析。"}, "audios": ["/path/to/your/audio.wav"], "videos": ["/path/to/your/video.mp4"]}
 
if [ "$#" -lt 3 ]; then
    echo "Usage: bash infer.sh <model_path> <input_jsonl> <result_path> [gpu_id]"
    exit 1
fi

MODEL_PATH=$1
INPUT_JSONL=$2
RESULT_PATH=$3
GPU_ID=${4:-0} # Default to GPU 0 if not provided

SWIFT_PATH="/xxx/xxx/ms-swift"
cd "$SWIFT_PATH" || exit

echo "Using GPU: $GPU_ID"
echo "Starting inference for $INPUT_JSONL..."

CUDA_VISIBLE_DEVICES=$GPU_ID \
VIDEO_MAX_PIXELS=50176 \
FPS_MAX_FRAMES=40 \
MAX_PIXELS=1003520 \
ENABLE_AUDIO_OUTPUT=0 \
swift infer \
    --model "$MODEL_PATH" \
    --stream true \
    --infer_backend pt \
    --write_batch_size -1 \
    --max_new_tokens 4096 \
    --val_dataset "$INPUT_JSONL" \
    --result_path "$RESULT_PATH"

echo "Finished processing $INPUT_JSONL. Results saved to $RESULT_PATH."