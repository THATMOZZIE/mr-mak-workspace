# Local workspace for this public fork

On Windows, always start this fork with **Start Mr. Mak.cmd**. It copies the
starter content once into `%LOCALAPPDATA%\Mr. Mak Workspace\workspaces\<id>` and
opens that folder in the installed app. The ID comes from the checkout's path.
Reports, the card registry, projects, notes, attachments, agent configuration and
runtime state then live outside the public checkout. Later launches reuse them
without copying over edits. The original starter files stay in the public fork.

The existing `.gitignore` excludes `.env`, `.mrmak`, inbox inputs and common job
receipts, but project folders and `workspace/workspace.json` contain tracked
starter files. Ignore rules cannot protect edits to files already tracked. The
separate local folder protects those edits too; it contains no `.git` directory
and has a defensive `*` ignore rule. Its `.ignore` allows agents to search notes.

## Windows start

1. Clone or download this fork into a folder you control.
2. Install the Windows x64 desktop app from the upstream GitHub Releases page
   linked in the README. No custom app build is needed for this launcher change.
3. Run **Start Mr. Mak.cmd** from this fork. In Chats, choose an already installed
   CLI with your own account and keep its working folder set to the local workspace.

To show the exact local path without starting the app, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\prepare-local-workspace.ps1
```

Save personal content in that local folder, and back it up separately. It is not
synced to GitHub. Moving the checkout creates a different ID; keep the old local
folder and select it in the app if you want to continue using the same content.
Existing content in an older checkout is not migrated or removed automatically.

Launching the app directly with `--repo` pointing at the public checkout, editing
files there, deliberately forcing Git to add local files, or configuring cloud
services is outside this protection. CLI agents still use their configured
providers. This change prevents accidental publication through the public fork;
it does not change provider connections or app permissions.

To undo the launcher change, revert its commit. That leaves all local content
intact. Do not revert and then save personal work into the public checkout.
