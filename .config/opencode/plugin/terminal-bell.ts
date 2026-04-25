import type { Plugin } from "@opencode-ai/plugin"

export const TerminalBell: Plugin = async () => {
	const subagentSessionIDs = new Set<string>()

	return {
		event: async ({ event }) => {
			if (event.type === "session.created" && event.properties.info.parentID) {
				subagentSessionIDs.add(event.properties.info.id)
			}
			if (event.type === "session.deleted") {
				subagentSessionIDs.delete(event.properties.info.id)
			}
			if (event.type === "session.idle" && !subagentSessionIDs.has(event.properties.sessionID)) {
				await Bun.write(Bun.stdout, "\x07")
			}
		}
	}
}
