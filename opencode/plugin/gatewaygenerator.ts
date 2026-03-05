import { Plugin } from "@opencode-ai/plugin"

export const GatewayPatch: Plugin = async (ctx) => {
  return {
    auth: {
      provider: "portkey",
      methods: ["api_key"],
      loader: async (getAuth, provider) => {
        return {
          async fetch(input, init) {
            const opts = init ?? {}
            if (opts.body && typeof opts.body === "string") {
              try {
                const body = JSON.parse(opts.body)

                let modified = false;

                // 1. Rename max_tokens for newer models
                if (body.max_tokens !== undefined) {
                  body.max_completion_tokens = body.max_tokens
                  delete body.max_tokens
                  modified = true;
                }

                // 2. Remove incompatible parameters that crash the gateway
                if (body.reasoningSummary !== undefined) {
                  delete body.reasoningSummary
                  modified = true;
                }

                // 3. CRITICAL FIX: OpenAI gpt-5.4 blocks reasoning_effort + tools on /chat/completions
                if (body.reasoning_effort !== undefined) {
                  delete body.reasoning_effort
                  modified = true;
                }

                if (modified) {
                  opts.body = JSON.stringify(body)
                }
              } catch (e) {
                // Silently ignore JSON parsing errors
              }
            }
            return fetch(input, {
              ...opts,
              timeout: false,
            })
          },
        }
      },
    },
  }
}
