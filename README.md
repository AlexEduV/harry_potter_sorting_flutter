# harry_potter_sorting_flutter
Harry Potter Magic Sorting Hat App

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)

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
- CachedNetworkImage

## Architecture
This project follows a **Clean Architecture** structure with the following layers:
- `data`: API services and local storage (Drift Database).
- `domain`: Business logic and entities, state management(Provider).
- `presentation`: UI and state management.

## Screenshots
Screenshots for the app are available here: [here](https://www.behance.net/gallery/218116601/Harry-Potter-Houses-Quiz-App)
