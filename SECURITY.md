# Security policy

## Reporting a vulnerability

Email <security@redrob.ai>. Do not open a public issue.

Include what you found, the repository and file or URL, and the steps to reproduce it. We
reply about repositories in this organization, and we will tell you if the issue belongs to a
different repository than the one you reported it against.

Please give us a reasonable window to ship a fix before publishing details.

## Scope

This is the organization's default policy. A repository with its own `SECURITY.md` describes
its own scope, and that one is authoritative for it.

In scope by default:

- Anything that lets an attacker read or change data belonging to another account.
- Authentication and authorization bypass.
- Injection of content or script into a rendered page.
- Dependency vulnerabilities reachable from a shipped artifact.
- A credential or secret exposed in a repository, a build log, or a published artifact.

Out of scope by default:

- Findings against a preview or staging deployment that do not reproduce in production.
- Missing hardening headers with no demonstrated impact.
- Scanner output with no demonstrated impact.
- Reports about a third-party service we consume rather than operate.

## If you find a credential in a repository

Report it privately and immediately, and do not open a pull request that removes it: the pull
request is public and points at the commit.

Assume any credential that reached a commit is compromised, including in a private
repository, and rotate it. Removing it from the current tree does not remove it from the
history, and in a fork network a commit stays reachable from upstream after the branch is
deleted.
