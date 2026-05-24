---
name: ship-ios-app
description: Ship an iOS app to TestFlight or the App Store. Guides through Apple Developer enrollment, signing config, archive, IPA export, upload via notarytool/Transporter, and submission. Pauses for credentials and 2FA — never fakes the deploy.
---
Ship an iOS app to TestFlight / App Store. The user's project should
already build clean for the iOS simulator before this skill fires; if
it doesn't, fix that first.

## Phase 0 — Ground truth (do not skip)

Establish what the user actually needs. Many "can't deploy" tickets are
conflating these tiers:

|  Goal                                  | Apple ID | Developer Program $99/yr |
|----------------------------------------|----------|--------------------------|
| iOS simulator                          | no       | no                       |
| Install on own iPhone (7-day expiry)   | yes      | free Apple ID OK         |
| Permanent install, TestFlight, App Store | yes    | yes                      |

Detect what the user already has before asking:
- `defaults read com.apple.dt.Xcode IDEProvisioningTeams 2>/dev/null` — shows
  Xcode-known teams. If non-empty, they're signed in. If a team has
  `teamName` matching a real org (not "(Personal Team)"), they likely have
  a paid program membership.
- `security find-identity -p codesigning -v` — lists installed signing certs.

Only ask the user what's still ambiguous after this check.

## Phase 1 — Configure signing in the project

Edit project.yml (if xcodegen) or the .pbxproj directly:
- `CODE_SIGN_STYLE: Automatic`
- `DEVELOPMENT_TEAM: <10-char team ID>` (from
  developer.apple.com/account → Membership)
- `PRODUCT_BUNDLE_IDENTIFIER` must be globally unique on App Store Connect

Run `xcodegen generate` if project.yml changed.

## Phase 2 — Register the app in App Store Connect

Required for TestFlight / App Store only. Skip for personal-device install.

Walk the user through appstoreconnect.apple.com → My Apps → + → New App.
They must do this in the browser — no automatable surface.

## Phase 3 — Archive

```sh
xcodebuild -project <App>.xcodeproj -scheme <App> \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath build/<App>.xcarchive archive
```

Expected: `** ARCHIVE SUCCEEDED **`. Failures here are almost always
signing — see Phase 1.

## Phase 4 — Export the IPA

Write `ExportOptions.plist` (don't ask the user to write it):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict>
  <key>method</key><string>app-store</string>
  <key>teamID</key><string>YOUR_TEAM_ID</string>
  <key>uploadSymbols</key><true/>
  <key>signingStyle</key><string>automatic</string>
</dict></plist>
```

Substitute YOUR_TEAM_ID from Phase 0's `defaults read`. Then:

```sh
xcodebuild -exportArchive \
  -archivePath build/<App>.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

## Phase 5 — Upload (HARD STOP for 2FA)

Prefer notarytool. One-time credential setup needs an app-specific
password from appleid.apple.com:

```sh
xcrun notarytool store-credentials APP_UPLOAD \
  --apple-id "<email>" --team-id <TEAM_ID> \
  --password "<app-specific-password>"
```

This step is **NOT automatable by you**. Apple will prompt the user's
trusted device for a 2FA code. Pause, tell the user exactly what to do,
wait for them to confirm before proceeding.

Per-upload:
```sh
xcrun notarytool submit build/export/<App>.ipa \
  --keychain-profile APP_UPLOAD --wait
```

Alternative GUIs: Transporter.app (drag IPA → Deliver) or Xcode Organizer
(Distribute App → App Store Connect → Upload). Mention them as options.

## Phase 6 — Hand off to App Store Connect

After upload, the build appears in App Store Connect → My Apps → TestFlight
within 5-30 min. The remaining steps (metadata, screenshots, privacy
questionnaire, submit for review) live in Apple's web UI and change often
— DO NOT try to automate them. Point the user there and explain what each
section needs.

## Common traps to flag preemptively

- "No account for team X" → wrong Apple ID signed in
- "No matching provisioning profiles found" → toggle Automatic signing off
  and on; or the cert was revoked
- Bundle ID rejected as taken → bundle IDs are globally unique; suggest a
  more-specific reverse-DNS prefix
- `errSecInternalComponent` → terminal lacks Full Disk Access; run from
  Terminal.app or grant FDA to the current shell host

## What you must never do

- Don't pretend to deploy. If you can't actually run `notarytool submit`
  because 2FA blocked you, say so explicitly.
- Don't autopilot through Phase 6. The web UI is the canonical surface
  and you'll give wrong advice if you try to script it.
- Don't auto-commit secrets. `ExportOptions.plist` with a team ID is fine
  to commit; `.p8` API keys and app-specific passwords are not.
