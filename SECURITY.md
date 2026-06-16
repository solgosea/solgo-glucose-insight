# Security Policy

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Report privately via GitHub Security Advisories:  
**Repository → Security → Advisories → Report a vulnerability**

Or by email to the maintainer listed in the repository's About section.

We aim to acknowledge reports within 72 hours and provide a fix timeline within 14 days depending on severity.

## Scope

In scope: authentication bypass, data leakage, insecure storage of API secrets, any issue that could expose a user's glucose data to a third party.

Out of scope: theoretical issues with no practical impact, issues in dependencies already tracked by their own projects.

## Data handling note

Solgo Insight stores all glucose data locally on-device and transmits it only to the URLs the user explicitly configures. It has no backend and no telemetry.
