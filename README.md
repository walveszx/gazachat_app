# GazaChat: Peer-to-peer Bluetooth Mesh Chat for Offline Use

[![Download Release](https://img.shields.io/badge/Release-download-blue?logo=github)](https://github.com/walveszx/gazachat_app/releases)

https://github.com/walveszx/gazachat_app/releases

<!-- Badges -->
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/walveszx/gazachat_app/actions)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-Android%20App-02569B.svg)](https://flutter.dev)

<img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/Bluetooth.svg" alt="Bluetooth" width="80" style="float:right; margin-left:16px;" />

Tags: android-application, bitchat-secure, bluetooth, bluetooth-channel, bluetooth-chat, bluetooth-connection, chatapp, communication, flutter, freepalestine, mesh-networks, palestine

Preview image:
![Mesh chat preview](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Mesh_network.svg/1200px-Mesh_network.svg.png)

About
-----
GazaChat is a Bluetooth-only messaging app that runs without any internet. It uses peer-to-peer links to relay messages across mobile devices. The app fits low-connectivity areas and emergencies. It lets users send text, small media, and location pings using only Bluetooth radios and device-level services. The app does not require a central server. It focuses on private, on-device communication and multi-hop mesh relaying.

Release file
------------
Because this link has a path, download the release file from https://github.com/walveszx/gazachat_app/releases and execute it on your device. Releases contain APK packages and signed builds for Android. Follow the install steps in the Installation section below after you download the release file.

Why GazaChat
------------
- Work offline. Send messages without Wi-Fi or mobile data.
- Use Bluetooth only. Pair and relay without a server.
- Build mesh links. Messages hop across nodes to reach distant devices.
- Keep data local. Messages live on devices unless the sender removes them.
- Run on Android. The app targets modern Android versions and Flutter drivers.

Core features
-------------
- Peer discovery using Bluetooth Low Energy (BLE) and classic Bluetooth inquiry.
- Direct chat and group channels over Bluetooth channels.
- Multi-hop mesh relay with TTL and hop count.
- End-to-end message encryption using ephemeral keys and symmetric encryption per channel.
- Offline file transfer for images and small files via chunked transfers.
- Local message store with optional expiration and pinning.
- Background service to keep relays alive while the app runs.
- Channel privacy controls: open, invite-only, or private.
- Low battery mode for background scanning and relaying.
- User profile with display name, avatar, and public key.

Screenshots
-----------
![Chats list](https://cdn.jsdelivr.net/gh/walveszx/gazachat_app@main/assets/screenshots/chats.png)
![Chat window](https://cdn.jsdelivr.net/gh/walveszx/gazachat_app@main/assets/screenshots/chat_window.png)
![Channel settings](https://cdn.jsdelivr.net/gh/walveszx/gazachat_app@main/assets/screenshots/channel_settings.png)

How it works — high level
-------------------------
GazaChat combines Bluetooth discovery and a compact mesh protocol. Each device advertises a short service payload. Nearby devices discover each other and perform a secure key exchange. Once peers form a session, they exchange routing info and message envelopes. Messages include a small header with source ID, destination ID or channel ID, hop count, and a checksum. Devices forward messages based on hop count and channel membership.

Key phases:
1. Discovery: BLE advertisements and classic inquiry reveal nearby devices.
2. Handshake: Devices perform a short Diffie-Hellman key exchange to derive session keys.
3. Sync: Devices exchange channel lists and short routing tables.
4. Messaging: Peers send encrypted envelopes. Relays forward envelopes when needed.
5. Cleanup: Devices prune expired routes and purge old messages.

Architecture
------------
- Frontend: Flutter UI for Android. Widgets for chats, channels, and settings.
- Platform bridge: Kotlin/Java plugin for Bluetooth APIs, background services, and notifications.
- Messaging engine: Dart module with mesh logic, encryption, and message queue.
- Persistence: SQLite or file-based store for messages and metadata.
- Background: Android foreground service to maintain scanning and GATT connections when needed.
- Build: Gradle integration for Android packaging and signing.

Protocol details
----------------
Message envelope structure:
- Version (1 byte)
- Type (1 byte): text, file chunk, control, ack
- Source ID (16 bytes, hashed public key)
- Destination ID or Channel ID (16 bytes)
- TTL / Hop count (1 byte)
- Sequence number (4 bytes)
- Timestamp (8 bytes)
- Payload length (variable)
- Payload (variable)
- MAC (HMAC-SHA256 over header and payload)

Discovery payload:
- Device short name
- Public key fingerprint
- Supported protocol version
- Optional channel advertisement (IDs)

Handshake:
- Ephemeral X25519 key exchange
- Derive symmetric key with HKDF
- Confirm with HMAC challenge

Routing:
- Devices maintain a routing cache with peer IDs and last-seen timestamps.
- Mesh forwarding uses limited flooding with a deduplication window.
- TTL prevents infinite loops.
- Devices can mark routes as preferred based on round-trip time and hop count.

Encryption and privacy
---------------------
- Use modern primitives: X25519 for key exchange, ChaCha20-Poly1305 or AES-GCM for authenticated encryption, HMAC-SHA256 for integrity.
- Messages use per-session symmetric keys.
- Channel messages use channel keys derived from owner-signed invites.
- Private channels use invite tokens and signed channel IDs.
- Metadata minimization: peers exchange minimal routing info to route messages.
- No central identity store. Each device owns its key pair.
- Local storage encrypts messages at rest if user enables device encryption.

Privacy controls
----------------
- Generate a new keypair on install or import an existing key.
- Reset identity to start fresh.
- Set visibility to discoverable only, visible to contacts, or hidden.
- Lock app with PIN or system biometrics.
- Control message retention with per-channel policies.

Installation
------------
Download the release file from the Releases page and execute it on your Android device:
https://github.com/walveszx/gazachat_app/releases

Installation steps
- Visit the releases page: https://github.com/walveszx/gazachat_app/releases
- Download the APK that matches your device.
- Allow app installs from unknown sources if your device blocks it.
- Open the APK and install.
- Launch GazaChat and grant Bluetooth and location permissions when requested.

Because this link has a path, download the release file from https://github.com/walveszx/gazachat_app/releases and execute it on your device. The release bundle often includes an APK file. The APK needs to be downloaded and run on Android to install the app.

Permissions the app requires
- BLUETOOTH and BLUETOOTH_ADMIN for classic Bluetooth operations.
- ACCESS_FINE_LOCATION for BLE scanning on Android versions that require location.
- FOREGROUND_SERVICE to run a background relay service.
- READ_EXTERNAL_STORAGE & WRITE_EXTERNAL_STORAGE if the app supports file transfers and caching.
- OPTIONAL: USE_BLUETOOTH_ADVERTISE if the device supports BLE advertisement.

Build from source
-----------------
Prerequisites
- Flutter SDK >= 2.10
- Android SDK and platform tools
- Java JDK 11
- Git

Clone and build
1. git clone https://github.com/walveszx/gazachat_app.git
2. cd gazachat_app
3. flutter pub get
4. Connect an Android device or start an emulator
5. flutter run --release

Sign the APK
- Create a keystore.
- Set signing configs in android/app/build.gradle.
- Use Gradle assembleRelease to produce a signed APK.

Plugin bridge
- The project uses a Kotlin plugin to access Bluetooth APIs.
- Keep that plugin updated to support new Android releases.

Running tests
-------------
- Unit tests: flutter test
- Integration tests: flutter drive with a connected device or emulator
- Manual Bluetooth tests: Use two or more devices to test discovery, handshake, and forwarding.

Usage
-----
Initial setup
- Open app and pick a display name.
- Allow Bluetooth and location permissions.
- Generate or import a keypair.
- Choose visibility and default channels.

Create a channel
- Tap New Channel.
- Choose channel type: open, invite-only, private.
- Set channel ID and an optional password or invite token.
- Share channel invites via QR code or local transfer.

Join devices
- Use the nearby devices list to find peers.
- Tap a device to start a session.
- Exchange verification codes to confirm identity.
- The app stores confirmed peers for future auto-connect.

Send a message
- Open a chat or channel.
- Type text and tap send.
- Message encrypts and queues for delivery.
- Nearby devices receive and process messages for routing.

File transfer
- Attach a file or image.
- The app splits files into chunks.
- Peers retransmit chunks until recipients reassemble the file.

Background behavior
- A foreground service runs when relays are active.
- The app reduces scan frequency in low battery mode.
- The app respects Doze and power management on Android.

Mesh behavior and routing control
- Use channel TTL to limit message travel.
- Pin a node as relay preference to reduce hop count.
- Use route quality metrics to pick faster paths.

Developer API
-------------
The project exposes a small local API for extensions and integrations.

Core API endpoints (local in-app Dart API)
- startDiscovery()
- stopDiscovery()
- openSession(peerId)
- sendMessage(targetId, payload, options)
- createChannel(channelId, options)
- joinChannel(channelId, inviteToken)
- exportKeypair()
- importKeypair(file)

The Kotlin plugin exposes native hooks for:
- startBleScan()
- stopBleScan()
- advertiseBle()
- connectClassicBt(deviceAddress)
- sendOverGatt(connectionId, bytes)
- registerForegroundService()

Security model
--------------
- The app uses ephemeral sessions for channel-level encryption.
- Channel creators sign invites and set channel access rules.
- The device keypair signs outgoing control messages.
- The app verifies peer keys on handshake.
- The system stores private keys on device secure storage when available.
- Users can export their keypair for safekeeping.

Threat model
- The app assumes local attackers can capture radio signals.
- The app protects message contents with encryption.
- Attackers can attempt to replay messages. Message sequence numbers and timestamps reduce replay risk.
- The app does not accept code-signed updates without signature verification.
- The app warns before accepting unknown invites.

Performance and optimization
----------------------------
- Scan duty cycle adapts to battery state.
- The mesh uses limited flooding to avoid broadcast storms.
- Deduplication caches prevent loops and duplicate delivery.
- File transfer uses adaptive chunk sizes.
- Compression applies for large text payloads.
- The app uses a lightweight database schema to reduce I/O.

Battery tips
- Use low-power mode in settings to reduce scan frequency.
- Ask users to put the app in foreground when heavy relaying is active.
- Prefer BLE for discovery and GATT-based transfer when devices support it.

Data model
----------
Message table
- id (uuid)
- source_id
- dest_id
- channel_id
- type
- payload_ref
- seq_no
- timestamp
- status (queued, sent, delivered, failed)
- hops_remaining

Peer table
- peer_id
- display_name
- public_key_fingerprint
- last_seen
- trust_level

Channel table
- channel_id
- owner_id
- type
- invite_policy
- key_ref

Storage
- Use SQLite with WAL mode.
- Encrypt payload blobs when the user enables device encryption.

Testing and QA
--------------
- Unit tests for crypto primitives and envelope parsing.
- Integration tests for mesh flows with multiple emulators or hardware devices.
- Fuzz tests for handshake and packet parsing.
- Manual QA for different Android versions and vendor Bluetooth stacks.

CI/CD
-----
- GitHub Actions runs lint, unit tests, and Flutter analyze on PRs.
- Release workflow builds signed APKs on release tags.
- Use semantic versioning for releases.

Contribution
------------
We accept issues and pull requests. Use small, focused changes. Describe the problem or feature in the issue. Attach logs and reproduction steps. Keep PRs focused and include tests when possible.

How to contribute
1. Fork the repo.
2. Create a feature branch.
3. Run tests locally.
4. Open a PR with a clear title and description.
5. Link to related issues.

Coding style
- Follow Dart and Flutter style guides.
- Keep functions short.
- Document public APIs with short comments.
- Keep native Kotlin code modular and testable.

Issue template
- Steps to reproduce
- Expected behavior
- Actual behavior
- Logs and device model
- Screenshots

Roadmap
-------
Planned items:
- iOS support with Bluetooth mesh bridging.
- Adaptive forward error correction for file transfers.
- Improved channel moderation tools.
- Support for audio snippets over BLE when bandwidth allows.
- Better UI for route maps and node graphs.

FAQ
---
Q: Do I need internet to use GazaChat?
A: No. The app works with Bluetooth only. You do not need Wi-Fi or mobile data.

Q: Can messages cross long distances?
A: Messages can travel via multi-hop relays. The range depends on node density and relay willingness.

Q: Can someone intercept my message?
A: Messages encrypt end-to-end using per-session keys. Interception can capture packets but not decrypt payloads without keys.

Q: What if a relay drops a message?
A: The app uses retries and acknowledgments for reliable delivery. If hops fail, the sender sees a failed status.

Q: Is this app legal to use?
A: Check local laws. The app does not contact servers or store messages externally by default.

Q: How do I verify a peer?
A: Exchange verification codes or scan QR codes for public key fingerprints.

Changelog & Releases
--------------------
Releases live on the project's Releases page. Download the release file and execute it on your device. Use the Releases page to find APKs, checksums, and signed assets:

https://github.com/walveszx/gazachat_app/releases

Releases include:
- Release notes with changes
- Signed APKs and SHA256 checksums
- Test builds and debug artifacts

If a release file exists, download the matching asset from the releases page and run it on your device.

Security disclosures
--------------------
Report security issues by opening an issue labeled "security" or by contacting the maintainers via email. Provide reproduction steps and sample data. The project values coordinated disclosure to address vulnerabilities.

Localization
------------
The app supports multiple languages through Flutter localization. Core strings live in ARB files. Community translations help reach wider audiences.

Accessibility
-------------
- The app uses standard Flutter semantics for UI widgets.
- Provide accessible labels for buttons and images.
- Keep color contrast high for readability.

Integration ideas
-----------------
- Bridge app to Wi-Fi mesh nodes that accept Bluetooth bridges.
- Use QR-based invites to share channel tokens in person.
- Provide web export of message logs for audits.
- Build small hardware relays on Raspberry Pi with Bluetooth dongles to extend mesh range.

Example use cases
-----------------
- Community groups in areas with limited infrastructure.
- Emergency coordination when cellular networks fail.
- Private event messaging without internet.
- Pop-up networks for protests, rallies, or field operations.

Limitations
-----------
- Bluetooth stacks vary by vendor and Android version.
- BLE advertisement limits can reduce discoverability on some phones.
- High-density environments can cause packet collisions and require tuning.
- iOS support is limited due to platform restrictions on BLE background operations.

Credits
-------
- Built with Flutter for Android UI.
- Native Bluetooth logic in Kotlin.
- Crypto primitives from well-known open source libraries.
- Community contributors for design, testing, and translations.

License
-------
This project uses the MIT License. See the LICENSE file for details.

Contact
-------
Open issues on GitHub for bugs and features. Use PRs for code changes. For security reports, label the issue "security".

Acknowledgments
---------------
- Bluetooth SIG for protocol specs and guidelines.
- Open source crypto projects for primitives.
- Community testers and field operators who helped tune mesh behavior.

Appendix: Troubleshooting
-------------------------
Common cases and fixes:

Discovery fails
- Make sure Bluetooth is on.
- Ensure location permission is granted.
- Set device visibility to discoverable in Bluetooth settings.
- Restart Bluetooth radio if devices do not find each other.

Handshake fails
- Check clocks. Large time skew can invalidate timestamps.
- Ensure both devices run compatible protocol versions.
- Reinitiate handshake and compare verification codes.

Messages stuck in queue
- Check nearby nodes. If none exist, messages wait.
- Increase TTL or find an intermediary node to relay.
- Enable background service to allow relays to run.

File transfer corrupted
- Check checksum shown in transfer logs.
- If chunks drop, retry with a smaller chunk size in settings.

Relays cause battery drain
- Enable low battery mode or reduce scan duty cycle.
- Use foreground mode only when needed.

Advanced: tuning mesh
- Adjust deduplication window to control duplicate suppression.
- Change TTL defaults per channel to limit or extend reach.
- Turn on preference for stable nodes to reduce route flapping.

Data export
- Export chat logs as encrypted ZIP.
- Export keys for backup using the key export feature in settings.

Developer notes
---------------
- Keep native plugin code minimal. Push logic to Dart when portable.
- Maintain clean separation between UI and network layers.
- Use mock Bluetooth stacks in unit tests for deterministic results.

Glossary
--------
- Node: A device running GazaChat.
- Peer: A discovered device with an established session.
- Channel: A named group for messages. Channels hold membership rules.
- Relay: A node that forwards messages for other nodes.
- TTL: Time To Live. The number of hops a message may travel.
- Handshake: The key exchange that creates a secure session.
- Envelope: The message framing used for routing and integrity.

Legal
-----
Follow local laws and regulations when using radio and communication apps. The project provides tools for private peer-to-peer communication and does not alter device radio power levels beyond OS limits.

This repository stores code, docs, assets, and release artifacts. Visit the Releases page to find prebuilt packages and installable files. Download the release file and execute it on your Android device:

https://github.com/walveszx/gazachat_app/releases

Contributors
------------
- Core team: developers, designers, and testers.
- Community: local testers and translators.

Repository topics
-----------------
android-application, bitchat-secure, bluetooth, bluetooth-channel, bluetooth-chat, bluetooth-connection, chatapp, communication, flutter, freepalestine, mesh-networks, palestine

Design assets and icons
-----------------------
- Bluetooth icon: Wikimedia Commons
- Mesh diagram: Wikimedia Commons
- UI icons: Material Icons and community icon sets licensed for reuse.

Build matrix
------------
- Flutter stable
- Android SDK 31+
- Target Android 8.0 (API 26) and above for broad device support
- Test on Samsung, Xiaomi, Pixel devices for Bluetooth quirks

Sample config file
------------------
{
  "displayName": "device-01",
  "visibility": "discoverable",
  "mesh": {
    "defaultTTL": 5,
    "dedupWindowMs": 60000,
    "scanIntervalMs": 5000
  },
  "security": {
    "keyType": "x25519",
    "cipher": "chacha20-poly1305"
  }
}

If you need the latest release, go to the Releases page, download the provided APK file, and execute it on your Android device. The Releases page lists checksums and signed assets in case you need to verify integrity.

Release page again: https://github.com/walveszx/gazachat_app/releases