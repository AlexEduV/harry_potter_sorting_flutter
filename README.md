# harry_potter_sorting_flutter

A quiz game, set in the Harry Potter universe, that let's you guess random character's house, implemented in Flutter.

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Platform Support](#platform-support)
- [Screenshots](#screenshots)

## Features
- A full-fledged quiz game in the Harry Potter Universe.
- A history of previous tries with an option to retry and reset tries.
- A search of the previously discovered characters in the database.
- A detail look available if the character is guessed correctly.
- requesting data from the Rest API.
- clean architecture, with code generation, jsonSerializable models.
- provider state management.
- a beautiful custom UI, with custom fonts, based on a third-party design.

## Tech Stack
- Flutter ^3.5.0
- Dart
- Provider (State management)
- Dio, JsonSerializable, Retrofit (Rest API)
- Auto_Route (Routing)
- Drift (Database)
- CachedNetworkImage, get_it (dependency injection)

## Architecture
This project follows a **Clean Architecture** structure with the following layers:
- `data`: API services and local storage (Drift Database).
- `domain`: Business logic and entities, state management(Provider).
- `presentation`: UI and state management.

## Project Structure

```
harry_potter_sorting_flutter/
|── android/                # Android configuration and manifests
|── assets/                 # project assets (images)
|── fonts/                  # project fonts
|── ios/                    # iOS configuration
├── lib/                    # main project folder
│   ├── core/                
│   │   └── di/             # dependency injection (get_it)
│   ├── data/               
│   │   ├── database/       # drift schema and access point
│   │   ├── network/        # dio client handler   
│   │   ├── repositories/   # repository implementations    
│   │   └── services/       # rest api service
│   ├── domain/
│   │   ├── models/         # model classes (dto's, entities)
│   │   ├── repositories/   # repository abstractions
│   │   └── usecases/       # usecases for the repositories
│   ├── presentation/       
│   │   ├── common/         # common widgeets
│   │   ├── pages/          # full pages, widgets, notifiers    
│   │   └── style/          # custom colors
│   ├── router/             # auto_route configuration
│   └── main.dart           # app entry point
|
├── test/                   # tests
└── pubscpec.yaml           # dependencies configuration

```

## Platform Support
This app supports Android and iOS

## Screenshots
Screenshots for the app are available here: [here](https://www.behance.net/gallery/218116601/Harry-Potter-Houses-Quiz-App)
