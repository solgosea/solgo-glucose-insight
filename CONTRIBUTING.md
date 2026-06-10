# Contributing

## Before you start

Run the full check locally before opening a PR:

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

All three must pass. CI will reject PRs that fail any of them.

## Branches

- `main` is always releasable. Never push directly.
- Feature branches: `feat/<short-description>`
- Bug fixes: `fix/<short-description>`

## Commits

One logical change per commit. Subject line in imperative mood, under 72 chars:

```
fix: correct TIR calculation for partial-day windows
feat: improve high episode context card
```

## Pull requests

- Keep PRs small and focused: one feature or one bug per PR.
- Fill in the PR template (what changed, how to test).
- Link the related issue if one exists.

## Running with mock data

No CGM hardware needed. Launch the Python mock server, then run the app:

```bash
# Terminal 1
cd mockserver && pip install -r requirements.txt && python server.py

# Terminal 2
flutter run
```

See `mockserver/README.md` for all scenarios.

## Code of conduct

Be respectful. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
