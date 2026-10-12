import type { Plugin } from "@opencode-ai/plugin"
import { spawn } from "node:child_process"

const DONE_SOUND = `${process.env.HOME}/dotfiles/sounds/freesound_community-flashlight-switch-102792.mp3`
const ERROR_SOUND = "/System/Library/Sounds/Basso.aiff"

function play(path: string) {
  const child = spawn("afplay", [path], { stdio: "ignore" })
  child.unref()
}

export default async () => {
  return {
    event: async ({ event }: { event: { type: string } }) => {
      if (event.type === "session.idle") {
        play(DONE_SOUND)
      } else if (event.type === "session.error") {
        play(ERROR_SOUND)
      }
    },
  }
}
