<div align="center">

# Agora Setup in Flutter

### Focused Flutter reference for real-time video calling with Agora and Cubit

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Agora](https://img.shields.io/badge/Agora-099DFD?style=flat-square)](https://www.agora.io)
[![BLoC](https://img.shields.io/badge/State-Cubit-34AADC?style=flat-square)](https://bloclibrary.dev)

</div>

## Overview

A small reference application that isolates the core pieces of an Agora video-call experience: engine setup, local and remote video surfaces, call state, in-call actions, and call completion UI.

## Included building blocks

- Agora RTC engine integration.
- Local and remote video widgets.
- Cubit-based call state management.
- Camera, microphone, and call-action components.
- Dedicated active-call and call-ended screens.

## Project structure

```text
lib/call_video/
├── presentation/components/
├── presentation/controller/
└── presentation/screens/
```

## Getting started

1. Create an Agora project and use development credentials that belong to you.
2. Keep the App ID and any tokens outside committed source files.
3. Install dependencies and run:

   ```bash
   flutter pub get
   flutter run
   ```

Camera and microphone permissions must be configured for the target platform.

## Maintainer

[Abdelrahman Dandash](https://github.com/27dandash) - Flutter Developer
