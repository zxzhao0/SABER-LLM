# Integrating Fine-Grained Audio-Visual Evidence for Robust Multimodal Emotion Reasoning

This is the official implementation of the paper: **"Integrating Fine-Grained Audio-Visual Evidence for Robust Multimodal Emotion Reasoning"**. 

[![Paper](https://img.shields.io/badge/cs.CL-arXiv%3A2601.18321-B31B1B.svg)](https://arxiv.org/abs/2601.18321)
[![Hugging Face Model](https://img.shields.io/badge/%F0%9F%A4%97%20Model-SABER--LLM-yellow)](https://huggingface.co/zhaoxiaoxian/SABER-LLM)
[![Hugging Face Dataset](https://img.shields.io/badge/%F0%9F%A4%97%20Dataset-SABER-green)](https://huggingface.co/datasets/zhaoxiaoxian/SABER-Dataset)

---
## 💡 Key Contributions

* **SABER Dataset**: A large-scale multimodal emotion reasoning dataset containing ~**600K** video clips, featuring a unique six-dimensional annotation schema.
* **SED Paradigm**: **Structured Evidence Decomposition** forces the model to disentangle and analyze uni-modal evidence (Visual, Acoustic, etc.) before synthesizing a final emotional conclusion.
* **CA-DPO**: **Consistency-Aware Direct Preference Optimization** refines the model's judgment in modality-conflicting scenarios (e.g., a "sarcastic smile" with a "hostile tone").
* **SOTA Performance**: Outperforms existing open-source baselines on EMER, EmoBench-M, and SABER-Test.

---
## 🔗 Resources

* **Paper**: [https://arxiv.org/abs/2601.18321](https://arxiv.org/abs/2601.18321)
* **Model Weights (7B)**: [https://huggingface.co/zhaoxiaoxian/SABER-LLM](https://huggingface.co/zhaoxiaoxian/SABER-LLM)
* **Training Dataset**: [https://huggingface.co/datasets/zhaoxiaoxian/SABER-Dataset](https://huggingface.co/datasets/zhaoxiaoxian/SABER-Dataset)
* **GitHub**: [https://github.com/zxzhao0/SABER-LLM](https://github.com/zxzhao0/SABER-LLM)

---
## 🚀 Quick Start & Inference

We use the [ms-swift](https://github.com/modelscope/ms-swift) framework for inference. Please ensure your environment is set up with `ms-swift` installed.

### Inference Script (`infer.sh`)

Save the following script to run stream inference on your custom JSONL data:

    #!/bin/bash
    # Usage: bash infer.sh <model_path> <input_jsonl> <result_path> [gpu_id]
    # Example: bash infer.sh MODEL/SABER-LLM data.jsonl result.jsonl 0
    #
    # Model download URL: https://huggingface.co/zhaoxiaoxian/SABER-LLM
    #
    # The `input_jsonl` file should be in the following format:
    # {"messages": [{"role": "user", "content": "请通过依次完成以下任务，对提供的媒体进行一次全面的多模态分析：\n- 请详细描述视频的场景及其背景信息。\n- 请对这段音频进行详细分析。\n- 请详细分析说话者的面部表情和肢体语言。\n- 最后，请综合以上所有观察结果，对说话者的情绪状态进行全面分析。"}], "audios": ["/path/to/your/audio.wav"], "videos": ["/path/to/your/video.mp4"]}
    
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

---
## 📊 Data Pipeline and Model Architecture

Our data construction pipeline integrates a unified fine-grained annotation strategy with automated quality control mechanisms across three stages.

![Data Processing Pipeline](data.png)
*Figure 1: (a) Overview of the SABER data pipeline, featuring Raw Data Cleaning, Fine-grained Multimodal Annotation, and Instruction Generation. (b) Training Paradigm: Stage 1 (SED) for sequential grounding and Stage 2 (CA-DPO) for preference alignment in conflicting scenarios.*

---

SABER-LLM utilizes a two-stage training paradigm to ensure robust evidence grounding.

![Model Architecture](model.png)

### Six-Dimensional Annotation Schema
1.  **Video Description**: Macro scene context.
2.  **Facial Expression**: Micro-expressions and gaze.
3.  **Body Language**: Posture, gestures, and social signals.
4.  **Acoustic Features**: Prosody, pitch, and tonal intensity.
5.  **Speech Content**: Verbatim transcripts and semantic info.
6.  **Multimodal Emotion Analysis**: Final holistic reasoning and causal logic.

---
## 📅 To-Do List

- [x] Release SABER-LLM-7B model weights
- [x] Release the full SABER training dataset
- [x] Quick Start and Inference Example scripts
- [ ] Provide automated data annotation scripts
