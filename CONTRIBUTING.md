# Contributing

Thank you for taking a look at Solgo Insight.

## Before You Start

Run the local checks before opening a pull request:

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## Branches

- `main` should stay releasable.
- Feature branches: `feat/<short-description>`
- Bug fixes: `fix/<short-description>`

## Commits

Prefer one logical change per commit when possible. A clear subject is more useful than a clever one:

```text
fix: correct stale source status mapping
feat: add status monitor probe summary
```

Some early public releases may still contain larger commits because the app architecture is actively changing. Future changes should become easier to review as the public scope stabilizes.

## Pull Requests

- Keep PRs focused.
- Explain what changed and how it was tested.
- Avoid committing private health data, signing keys, API secrets, local databases, or generated release artifacts unless they are intentionally public assets.

## Development Data

Use mock or synthetic glucose data for development and tests. Do not add personal CGM exports to the repository.

## Conduct

Be respectful. This project touches health-related workflows, so clarity and care matter.
