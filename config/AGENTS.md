# Agent instructions

## Browser routing inside Orca

- Before browser automation, check whether the session is running inside Orca using `ORCA_WORKSPACE_ID` or `ORCA_PANE_KEY`.
- Inside Orca, use the `$orca-cli` skill and Orca's embedded browser for ad-hoc visual verification, navigation, screenshots, DOM snapshots, console inspection, and network inspection.
- Do not use Playwright for ad-hoc visual verification inside Orca.
- Use Playwright only when the user explicitly requests it or when writing, running, or debugging the project's Playwright E2E tests.
- If the Orca browser is unavailable, report its exact error before falling back to another browser tool.
