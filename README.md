# Engineering standards

The working agreement for every repository in this organization: how we name repositories
and branches, what has to be green before a merge, how agents work in our trees, and what
our interfaces look like.

한국어: [README.ko.md](./README.ko.md)

## What is here

| Document | What it settles |
|---|---|
| [CONTRIBUTING.md](./CONTRIBUTING.md) | The default contribution agreement. A repository may override it. |
| [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) | How we behave with each other. |
| [SECURITY.md](./SECURITY.md) | Where a vulnerability report goes. Never a public issue. |
| [SUPPORT.md](./SUPPORT.md) | Where a question goes. |
| [AGENTS.md](./AGENTS.md) | What an AI agent working in one of our repositories must do. |
| [docs/GITFLOW.md](./docs/GITFLOW.md) | Branches, merges, releases, hotfixes, and what CI enforces. |
| [docs/REPO-NAMING.md](./docs/REPO-NAMING.md) | What a repository may be called, the description and topics it must carry, and why renaming later is expensive. |
| [docs/DESIGN.md](./docs/DESIGN.md) | Tokens, type, motion, and the rules a product interface follows. |
| [scripts/audit-metadata.sh](./scripts/audit-metadata.sh) | Reports repositories missing a description or topics. `--fail` to gate on it. |

## What GitHub inherits from this repository, and what it does not

This repository is named `.github`, which GitHub treats specially. Files at the paths below
are used by **every repository in this organization that does not have its own copy**. A
repository's own file always wins, so this is a floor, not an override.

Inherited automatically:

- `CODE_OF_CONDUCT.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `SUPPORT.md`
- `.github/ISSUE_TEMPLATE/*`
- `.github/pull_request_template.md`
- `profile/README.md` (renders on the organization's public profile page)

**Not inherited.** `AGENTS.md`, `docs/GITFLOW.md`, `docs/REPO-NAMING.md` and
`docs/DESIGN.md` are ordinary files in an ordinary repository. GitHub has no mechanism that
propagates them, and the agent tooling that reads `AGENTS.md` reads the one in the tree it
is working in. A repository that wants these adds a short file that links here, or copies
the parts it actually follows. Linking is better: a copy drifts and nothing reports it.

`workflow-templates/` is offered rather than inherited. It puts our `gitflow` check in the
"New workflow" list for repositories in this organization so a new repository starts with
the gate instead of acquiring it after the first badly named branch.

**Inheritance stops at the organization boundary.** These defaults reach repositories in
this organization only. A repository in a different organization needs that organization's
own `.github` repository, even when the same people own both.

**The Korean code of conduct lives in `docs/`, not next to the English one.** GitHub picks
one file per health-file slot, and with both `CODE_OF_CONDUCT.md` and
`CODE_OF_CONDUCT.ko.md` at the root it picked the Korean one for all 242 repositories.
`docs/` is scanned at lower precedence than the root, so the English file wins the slot and
the Korean file is still one click away. Do not move it back. Every other Korean document
keeps its `.ko.md` name beside its English pair, because no other document is claimed by a
GitHub slot.

## Changing a standard

This repository has one branch, `main`. A change lands through a pull request straight into
`main`. There is no `develop`, no promotion and no back-merge.

| | |
|---|---|
| `main` | **Default and only branch.** GitHub serves the inherited health files from here. |
| Branch names | `<type>/<slug>`, types `feat fix chore docs test refactor perf`. |
| Required check | `branch name follows the convention` |

`main` is protected: pull requests only, no force pushes, no deletions, and admin enforcement
is on.

This is a deliberate deviation from [docs/GITFLOW.md](./docs/GITFLOW.md). GitHub reads
community health files from the default branch, so here the default branch is the surface
served to every repository in the organization, not the contributors' view. The repository
holds documents only: nothing is built, tagged or synced from upstream, so an integration
branch would only add a second pull request per change.

## Our other organization

[github.com/redrob-labs](https://github.com/redrob-labs) is ours too. It holds the open
source products and research: Redrob OS, Code, Browser, Canvas, Film, Shape,
CAD, Board, Grow, Eval, Image and UI.

The split is by audience, not by ownership. This organization is client and platform work and
is mostly private; `redrob-labs` is what we publish for people outside the company to use.

**These defaults do not reach it.** GitHub health-file inheritance stops at the organization
boundary, so `redrob-labs` has its own
[`.github`](https://github.com/redrob-labs/.github) repository supplying its health files. It
does not duplicate the four documents in `docs/`; it links to them, because both organizations
follow the same standards and a copy drifts. What it adds is what only applies there:
[FORKS.md](https://github.com/redrob-labs/.github/blob/main/FORKS.md), the rules for the eight
repositories in that organization that are forks.
