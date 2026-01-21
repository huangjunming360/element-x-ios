# Element X HarmonyOS

Element X for HarmonyOS is a native port of the [Element X iOS](https://github.com/element-hq/element-x-ios) Matrix client, built using ArkTS and ArkUI.

## Overview

Element X HarmonyOS is the next-generation [Matrix](https://matrix.org/) client for HarmonyOS devices, providing secure, decentralized messaging with a modern native UI.

This project is a port of Element X iOS to HarmonyOS, adapting the SwiftUI-based architecture to ArkTS/ArkUI while maintaining the same user experience and feature set.

## Architecture

The project follows a similar architecture to the iOS version:

### Structure

```
ElementX-Harmony/
├── AppScope/                    # Application scope configuration
│   ├── app.json5               # App configuration
│   └── resources/              # App-level resources
├── entry/                       # Entry module
│   ├── src/main/
│   │   ├── ets/                # ArkTS source files
│   │   │   ├── entryability/   # Entry ability (AppDelegate equivalent)
│   │   │   ├── pages/          # UI pages
│   │   │   ├── components/     # Reusable UI components
│   │   │   ├── services/       # Business logic services
│   │   │   ├── models/         # Data models
│   │   │   └── utils/          # Utility functions
│   │   ├── resources/          # Module resources
│   │   └── module.json5        # Module configuration
│   └── oh-package.json5        # Module package config
├── build-profile.json5         # Build configuration
├── hvigorfile.ts              # Build script
└── oh-package.json5           # Project package config
```

### Components Mapping (iOS → HarmonyOS)

| iOS (Swift/SwiftUI) | HarmonyOS (ArkTS/ArkUI) |
|---------------------|-------------------------|
| `@main App` | `EntryAbility` |
| `View` | `@Component struct` |
| `@State` | `@State` |
| `@ObservedObject` | `@Observed` / `@ObjectLink` |
| `NavigationStack` | `router` |
| `List` | `List` |
| `Text` | `Text` |
| `Button` | `Button` |
| `Image` | `Image` |
| `TextField` | `TextInput` |

## Features

### Implemented
- ✅ Application entry and lifecycle management
- ✅ Authentication flow (login/logout)
- ✅ Room list display with filters
- ✅ Room timeline view
- ✅ Message composer
- ✅ Settings screen
- ✅ User profile display
- ✅ Unread indicators and badges
- ✅ Search functionality
- ✅ Room filtering (Favourites, People, Unread)

### Planned
- [ ] Matrix SDK integration via native bridge
- [ ] End-to-end encryption
- [ ] Push notifications
- [ ] Voice/Video calls
- [ ] Media sharing (images, files, audio)
- [ ] Rich text formatting
- [ ] Reactions
- [ ] Reply/Thread support
- [ ] Room creation and management
- [ ] User search and invite
- [ ] Session verification
- [ ] Secure backup

## Development Setup

### Prerequisites

1. [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) (HarmonyOS IDE)
2. HarmonyOS SDK 5.0.0 or later
3. A HarmonyOS device or emulator

### Building

1. Open the `ElementX-Harmony` folder in DevEco Studio
2. Sync the project with Gradle
3. Build and run on a device or emulator

### Configuration

The app is configured via `AppScope/app.json5`:
- Bundle name: `io.element.elementx.harmony`
- Minimum SDK: 5.0.0 (API 12)

## Matrix SDK Integration

The HarmonyOS port is designed to integrate with the [Matrix Rust SDK](https://github.com/matrix-org/matrix-rust-sdk) similar to the iOS version. Integration options include:

1. **Native Bridge**: Use N-API to bridge Rust SDK to ArkTS
2. **HTTP API**: Direct Matrix client-server API calls
3. **WebSocket**: For real-time sync updates

Currently, the app uses mock implementations for demonstration. Full Matrix SDK integration is planned.

## Security

The app follows HarmonyOS security best practices:
- Secure storage using HUKS (HarmonyOS Universal KeyStore)
- HTTPS for all network communications
- Permission declarations in `module.json5`

Required permissions:
- `ohos.permission.INTERNET` - Network access
- `ohos.permission.GET_NETWORK_INFO` - Network state
- `ohos.permission.NOTIFICATION` - Push notifications
- `ohos.permission.MICROPHONE` - Voice messages/calls
- `ohos.permission.CAMERA` - Video calls
- `ohos.permission.READ_MEDIA` / `WRITE_MEDIA` - Media sharing

## Contributing

Contributions are welcome! Please follow the same contribution guidelines as the iOS version.

## License

Copyright (c) 2025 Element Creations Ltd.

This software is dual licensed under AGPL-3.0-only or LicenseRef-Element-Commercial.
See [LICENSE](../LICENSE) files in the repository root for full details.

## Related Projects

- [Element X iOS](https://github.com/element-hq/element-x-ios) - Original iOS version
- [Element X Android](https://github.com/element-hq/element-x-android) - Android version
- [Matrix Rust SDK](https://github.com/matrix-org/matrix-rust-sdk) - Underlying SDK
