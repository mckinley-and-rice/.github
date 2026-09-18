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
| [docs/REPO-NAMING.md](./docs/REPO-NAMING.md) | What a repository may be called, and why renaming later is expensive. |
| [docs/DESIGN.md](./docs/DESIGN.md) | Tokens, type, motion, and the rules a product interface follows. |

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

This repository follows the standard it publishes, so a change lands through a pull request
into `develop`.

| | |
|---|---|
| `develop` | Default. Every change lands here first. |
| `main` | The published state. What the issue templates and the organization profile link to. |
| Branch names | `<type>/<slug>`, types `feat fix chore docs test refactor perf`. |
| Required check | `branch name follows the convention` |

Both branches are protected: pull requests only, no force pushes, no deletions.

`main` moves by a promotion pull request from `develop`, merged as a **merge commit**, and
that promotion is followed by a back-merge pull request from `main` into `develop`. Two pull
requests per promotion is the real cost of the model, and this repository pays it rather than
exempting itself from a rule it asks 242 other repositories to follow.

The back-merge is not optional bookkeeping. The `gitflow` workflow fails on every push to
`main` while `main` holds commits `develop` does not, and a merge-commit promotion always
leaves exactly that until the back-merge lands.

The one part of the model this repository does not use is `release/*` and version tags. There
is no artifact to build, so there is nothing to tag, and `sync` does not apply either because
there is no upstream. Its `ALLOWED_TYPES` is shorter than the full set in
[docs/GITFLOW.md](./docs/GITFLOW.md) for that reason, and says so in a comment.

These documents are read as rules, so a change to one is a change to how every repository is
expected to work. When a rule and a repository disagree, one of the two is wrong. Say which
in the pull request. A rule nothing enforces is a preference, so prefer a rule with a check
next to it, and when you cannot check it, say plainly in the document that it is unchecked.

## Our other organization

[github.com/redrob-labs](https://github.com/redrob-labs) is ours too. It holds the open
source products and research: Redrob Code, Cowork, Office, Design, Canvas, Query, Recall,
Eval, Studio, Verify and Image.

The split is by audience, not by ownership. This organization is client and platform work and
is mostly private; `redrob-labs` is what we publish for people outside the company to use.

**These defaults do not reach it.** GitHub health-file inheritance stops at the organization
boundary, so `redrob-labs` needs its own `.github` repository, and it does not have one yet.
Its repositories each carry their own `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` and
`SECURITY.md` today. The standards in `docs/` apply to both organizations as written; only the
automatic inheritance is limited to this one.
