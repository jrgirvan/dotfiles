#!/bin/bash

echo "Reading models and providers from standard input..."

declare -a model_keys
MODELS_JSON=""

# Read all lines first into an array to know the total count for comma placement
declare -a lines
while read -r line; do
    if [[ -z "$line" || "$line" =~ ^-+$ || "$line" == *"Error"* || "$line" == *"Reading"* ]]; then continue; fi
    lines+=("$line")
done < /dev/stdin

total=${#lines[@]}

if [ "$total" -eq 0 ]; then
    echo "No valid models found in input!"
    echo "Usage: ./check_models.sh | ./generate_config.sh"
    exit 1
fi

echo "Found $total models. Building opencode2.json for custom PortKey provider..."

# Build the custom models JSON block dynamically
for i in "${!lines[@]}"; do
    words=(${lines[$i]})
    if [ ${#words[@]} -eq 1 ]; then
        provider="openai"
        model="${words[0]}"
    elif [ ${#words[@]} -ge 2 ]; then
        provider="${words[0]}"
        model="${words[1]}"
    fi

    # Normalize provider prefix so Xero Gateway can inject the corporate API keys
    if [[ "$provider" == *"open-ai"* || "$provider" == *"openai"* ]]; then
        model_key="@openai/${model}"
    elif [[ "$provider" == *"vertex-ai"* || "$provider" == *"vertexai"* ]]; then
        model_key="@vertexai/${model}"
    elif [[ "$provider" == *"bedrock"* ]]; then
        model_key="@bedrock/${model}"
    else
        model_key="@${provider}/${model}"
    fi

    model_keys+=("$model_key")

    # Determine proper context window limits based on model names
    if [[ "$model" == *"gpt-5.4-mini"* || "$model" == *"gpt-5.4-nano"* ]]; then
        cw=400000
    elif [[ "$model" == *"gpt-5.4"* ]]; then
        cw=1050000
    elif [[ "$model" == *"gemini"* && "$model" == *"pro"* ]]; then
        cw=2000000
    elif [[ "$model" == *"gemini"* && "$model" == *"flash"* ]]; then
        cw=1000000
    elif [[ "$model" == *"claude"* ]]; then
        cw=200000
    elif [[ "$model" == *"embed"* ]]; then
        cw=8192
    else
        cw=128000
    fi

    MODELS_JSON+=$(cat <<EOF
        "$model_key": {
          "name": "$model",
          "contextWindow": $cw
        }
EOF
)
    if [ $i -lt $((total - 1)) ]; then MODELS_JSON+=","; fi
    MODELS_JSON+=$'\n'
done

BUILD_MODEL=""
PLAN_MODEL=""
SUBAGENT_MODEL=""
COMPACTION_MODEL=""

# 1. Target the OpenAI GPT-5.4 Stack (Now that the plugin fixes the SDK crash!)
for key in "${model_keys[@]}"; do
    # Plan & Build: Standard 5.4 for daily heavy coding and architecture (Avoiding the expensive Pro tier)
    if [[ -z "$PLAN_MODEL" && "$key" == *"gpt-5.4"* && "$key" != *"pro"* && "$key" != *"mini"* && "$key" != *"nano"* ]]; then PLAN_MODEL="portkey/$key"; fi
    if [[ -z "$BUILD_MODEL" && "$key" == *"gpt-5.4"* && "$key" != *"pro"* && "$key" != *"mini"* && "$key" != *"nano"* ]]; then BUILD_MODEL="portkey/$key"; fi

    # Subagent: Fast log parsing and file exploration
    if [[ -z "$SUBAGENT_MODEL" && "$key" == *"gpt-5.4-mini"* ]]; then SUBAGENT_MODEL="portkey/$key"; fi

    # Compaction: Ultra-fast mechanical summarization
    if [[ -z "$COMPACTION_MODEL" && "$key" == *"gpt-5.4-nano"* ]]; then COMPACTION_MODEL="portkey/$key"; fi
done

# 2. First fallback wave (If exact 5.4 matches fail)
for key in "${model_keys[@]}"; do
    if [[ -z "$PLAN_MODEL" && "$key" == *"claude-opus-4-6"* ]]; then PLAN_MODEL="portkey/$key"; fi
    if [[ -z "$BUILD_MODEL" && "$key" == *"claude-sonnet-4-6"* ]]; then BUILD_MODEL="portkey/$key"; fi
    if [[ -z "$SUBAGENT_MODEL" && "$key" == *"gemini-3.1-flash-lite"* ]]; then SUBAGENT_MODEL="portkey/$key"; fi
    if [[ -z "$COMPACTION_MODEL" && "$key" == *"gemini-2.5-flash-lite"* ]]; then COMPACTION_MODEL="portkey/$key"; fi
done

# 3. Ultimate fallback (grab whatever is at the top of the list)
if [[ -z "$BUILD_MODEL" ]]; then BUILD_MODEL="portkey/${model_keys[0]}"; fi
if [[ -z "$PLAN_MODEL" ]]; then PLAN_MODEL="$BUILD_MODEL"; fi
if [[ -z "$SUBAGENT_MODEL" ]]; then SUBAGENT_MODEL="$BUILD_MODEL"; fi
if [[ -z "$COMPACTION_MODEL" ]]; then COMPACTION_MODEL="$SUBAGENT_MODEL"; fi

# Write the final JSON file
cat <<EOF > opencode2.json
{
  "provider": {
    "portkey": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "PortKey",
      "options": {
        "baseURL": "https://llm-gateway.xgw.xero-test.com/v1"
      },
      "models": {
$MODELS_JSON
      }
    }
  },
  "agent": {
    "compaction": {
      "mode": "subagent",
      "model": "$COMPACTION_MODEL"
    },
    "build": {
      "mode": "primary",
      "model": "$BUILD_MODEL",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "plan": {
      "mode": "primary",
      "model": "$PLAN_MODEL",
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "general": {
      "mode": "subagent",
      "model": "$SUBAGENT_MODEL"
    },
    "explore": {
      "mode": "subagent",
      "model": "$SUBAGENT_MODEL"
    }
  }
}
EOF

echo "✅ opencode2.json generated successfully!"
echo "🛠️  Architecture (Plan) assigned to:  $PLAN_MODEL"
echo "🛠️  Heavy Backend (Build) assigned to: $BUILD_MODEL"
echo "🛠️  Log/Context (Subagents) assigned to: $SUBAGENT_MODEL"
echo "🛠️  Context Saver (Compaction) assigned to: $COMPACTION_MODEL"
echo ""
echo "Note: Ensure your plugin is saved to ~/.config/opencode/plugin/max_completion_tokens.ts"
