import { Plugin } from "@opencode/plugin"
import { spawn } from "node:child_process"

const DONE_SOUND = `${process.env.HOME}/dotfiles/sounds/freesound_community-flashlight-switch-102792.mp3`
const ERROR_SOUND = "/System/Library/Sounds/Basso.aiff"

function play(path: string) {
  const child = spawn("afplay", [path], { stdio: "ignore" })
  child.unref()
}

export default Plugin.define({
  id: "notify-done",
  setup(ctx) {
    const controller = new AbortController()
    let pending: ReturnType<typeof setTimeout> | undefined
    // Retry で失敗イベントの直後に execution.started が来るため、
    // 最終状態だけを鳴らすよう 2 秒デバウンスし、再実行で取消す。
    function schedule(kind: "done" | "error") {
      if (pending) clearTimeout(pending)
      pending = setTimeout(() => {
        pending = undefined
        play(kind === "done" ? DONE_SOUND : ERROR_SOUND)
      }, 2000)
    }
    function cancel() {
      if (pending) {
        clearTimeout(pending)
        pending = undefined
      }
    }
    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (
          event.type === "session.execution.succeeded" ||
          event.type === "session.execution.failed"
        ) {
          schedule(event.type === "session.execution.succeeded" ? "done" : "error")
        } else if (event.type === "session.execution.started") {
          cancel()
        }
      }
    })()
    return () => {
      controller.abort()
      if (pending) clearTimeout(pending)
    }
  },
})
