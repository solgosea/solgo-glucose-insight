# Security Policy

## Reporting A Vulnerability

Please do not open a public GitHub issue for security vulnerabilities.

Report privately via GitHub Security Advisories:

**Repository -> Security -> Advisories -> Report a vulnerability**

Or contact the maintainer through the repository About section.

## Scope

In scope:

- data leakage
- insecure storage of API secrets
- issues that could expose a user's glucose data to a third party
- vulnerabilities in configured data-source handling

Out of scope:

- theoretical issues with no practical impact
- issues in dependencies already tracked by their own projects
- medical interpretation disagreements

## Data Handling Note

Solgo Insight stores glucose data locally on-device and transmits it only to URLs the user explicitly configures. The community preview has no account system and no telemetry.
