# AGENTS.md

Flutter app (Dart SDK ^3.13.2): interactive Spanish flashcards for 2-year-olds.

## Commands
- `flutter run` – run the app (fullscreen, iOS-style UI)
- `flutter test` – run all tests
- `flutter analyze` – lint + static analysis (flutter_lints). No CI; run manually.

## Architecture & conventions
- Clean architecture under `lib/features/flashcards/`: `data/` (hardcoded models +
  datasource), `domain/`, `presentation/` (Bloc). DI via get_it
  (`lib/core/di/injection.dart`).
- UI is **Cupertino, not Material**: use `flutter/cupertino.dart`, `CupertinoApp`,
  `CupertinoTheme`. All UI text, categories and card words are **Spanish**; keep new
  content Spanish.
- `FlashcardsPage` is a thin orchestrator: it composes `CategoryGrid`, `CardHeader`,
  `CardNavigationBar`, `ChangePhotoButton`, `AddCardPlaceholder` and
  `NavigateBackButton` (all in `presentation/widgets/`) around `SwipeableCard` +
  `CreateCardSheet`, and owns the two `image_picker` flows. Build small widgets there,
  don't grow the page.
- Flashcards/categories are hardcoded lists in
  `lib/features/flashcards/data/datasources/local_flashcards_datasource.dart`
  (source of truth for ~72 cards / 13 categories). New bundled images go in
  `assets/images/` (the whole directory is pre-registered in pubspec; no pubspec edit
  needed for new images).
- Sound is spoken by `flutter_tts` (es-ES, slow rate) — the `audioPath` field on models
  is vestigial; do not add mp3 assets.
- Hive is used only for persistence of user data: the `card_images` box
  (cardId -> absolute file path of a user-picked override image) and the `custom_cards`
  box (a single `cards` key -> `List<Map<String, dynamic>>` of user-created cards).
  Models have no `@HiveType`; there is no codegen — do not run `build_runner`.
- **Both Hive boxes must be opened in `configureDependencies` (`injection.dart`).**
  A box that is not opened makes `Hive.box('...')` throw, which `_onSelectCategory`
  catches silently — taps "do nothing" while the screen still scrolls. Bloc errors are
  swallowed into `errorMessage` with no UI, so always check the box is opened when
  adding storage.

## Custom images (uploaded from the phone)
- Pick flow: `FlashcardsPage._pickAndSetImage` (image_picker) dispatches `SetCardImage`
  → bloc calls `repository.saveCardImage` → image is copied to
  `<app documents>/custom_images/<cardId>_<ts>.<ext>` and the path is stored in the
  `card_images` Hive box.
- Cards with a custom image are rendered with `Image.file` instead of `Image.asset`
  (`SwipeableCard`, flagged by `customImagePath`/`nextCustomImagePath`).
- The overrides map lives in `FlashcardState.customCardImages`; it must be passed from
  bloc → page → card. Custom image paths are runtime-only, never committed.

## User-created cards
- Every category ends with an empty "+" slot (`_buildAddCard`, activated when
  `currentIndex >= cards.length`); the counter shows `cards.length + 1` (`totalSlots`).
  Tap it → `CreateCardSheet` (Cupertino page: title + gallery pick) → dispatches
  `CreateCustomCard` → `repository.addCustomCard` copies the image to
  `custom_images/` and appends the card to the `custom_cards` box.
- Created cards are rendered like any other: `getCardsByCategory` merges hardcoded +
  custom cards, and `SwipeableCard._buildCardImage` renders `Image.file` for any
  `imagePath` that does not start with `assets/` (no separate flag needed).

## Asset gotchas
- `Image.asset` picks its decoder by file **extension**. Watch for files that are JPEG
  but named `.png` (e.g. `dog.png`/`cat.png`/`cow.png` were fixed once) — they fail at
  runtime and show the empty-image fallback. Validate with `file assets/images/*.png`.
- Missing/broken images show an `Iconsax.gallery_slash` error widget, not a crash.

## Tests
- Widget tests must wrap pages in `BlocProvider<FlashcardsBloc>` with a fake
  repository implementing `FlashcardsRepository` (see `test/widget_test.dart`; it also
  implements the custom-image methods).

## Content docs
- Image generation prompts/history: `docs/image_generation_prompts.md`.
- README is unmaintained Flutter boilerplate (ignore).