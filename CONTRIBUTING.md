# Contributing

This is the default contribution agreement for every repository in this organization. A
repository with its own `CONTRIBUTING.md` uses that one instead, and where the two disagree
the repository wins: it knows its own build.

한국어: [CONTRIBUTING.ko.md](./CONTRIBUTING.ko.md)

## Before you start

Read the repository's `README.md` for how to build it and its `AGENTS.md` for the rules
that are specific to that tree. If the repository is a **fork**, read its `UPSTREAM.md` or
`docs/UPSTREAM.md` first: a fork's most consequential operation is absorbing upstream, and
the rules that protect that are not optional.

## Branches

Gitflow. `develop` integrates, `main` is what is released. The full model, including
releases and hotfixes, is in [docs/GITFLOW.md](./docs/GITFLOW.md).

Working branches are `<type>/<short-slug>`:

```
fix/composer-drop-zone
feat/reasoning-effort
chore/bump-electron
docs/upstream-sync
```

The allowed type list is **per repository**, held in that repository's
`.github/workflows/gitflow.yml` as `ALLOWED_TYPES`. Read it before you name a branch. Some
repositories use `feat`, others `feature`, and the check fails a branch that guessed.

A branch name says what the change is, never who or what produced it. `kiro/`, `claude/`
and `bot/` are not types, and the check exists because branches under exactly those
prefixes were merged before it did.

## Commits

Conventional prefixes, imperative mood, lower case subject:

```
fix(composer): show the drop zone during dragover, not only on drop
```

The body is where the value is. Say what was wrong and why the fix is the right shape, not
what the diff already shows. If the cause was somewhere other than where the symptom
appeared, say so. That is the sentence the next person needs.

Commit and pull request bodies are written in English, so that the history reads in one
language. Issues and discussion may be in either.

No em dashes, in commits or anywhere else. Use a colon, a comma, parentheses, or a separate
sentence.

## Before you open a pull request

Run the repository's own gates, listed in its `README.md` or `CONTRIBUTING.md`. Typically:

```bash
<install>          # pnpm install / bun install / cargo fetch
<test>
<typecheck>
<lint>
```

Then rebase on the base branch. Keep the branch focused: a reviewer should be able to state
what it does in one sentence.

**Measure, do not remember.** Any count, size, version or timing you put in a commit
message, pull request body, changelog or release note is re-measured from the built
artifact in the same sitting, and you say which surface produced it. A number carried
forward from an earlier summary is usually counting something else.

## Reviews and merging

A pull request needs its checks green and a maintainer merge. Several repositories allow a
single maintainer to self-merge; that is a staffing fact, not an invitation to skip the
checks.

Merge style is not a preference, it changes what the next merge can do:

| Situation | Style | Why |
|---|---|---|
| Working branch | **squash** | One concern, one commit on `develop`. |
| Upstream sync | **merge commit** | A squash destroys the merge base, and the next sync replays work already taken. |
| `develop` into `main` promotion | **merge commit** | Same reason: the relationship is the point. |

Never rebase-merge the last two.

A red check is diagnosed, not waved through. Look at the pull request's changed files first:
a documentation-only branch cannot fail a Windows unit test, and when it appears to, the
failure is the base branch's and belongs in a separate issue. When two branches point at
the same commit, a failed run from the old branch stays attached to the new pull request
even after the old branch is deleted; change the head commit to clear it.

## Secrets

Never commit `.env`, a credential file, or a token. Never put an environment variable's
value in a log, a commit message, or a chat message. Check `.gitignore` before the first
commit in a new repository, and check that a symlink named `node_modules` is not staged:
`node_modules/` with a trailing slash matches a directory and lets a symlink of the same
name straight through.

If you believe a credential reached a commit, say so immediately and privately per
[SECURITY.md](./SECURITY.md). Rotating it is cheap; a quiet one is not.

## User-facing strings

Every user-visible string goes through the repository's translation layer, and lands in
both the English and Korean tables. English is the source of truth.

Do not machine-translate to satisfy a completeness check. An untranslated English value
recorded in the repository's translation baseline is the honest state; an invented Korean
string looks like something a person reviewed.

A copyright notice is never translated. Korean documents keep their prose in Korean and
quote the notice verbatim, because a translated notice reads as a second, different holder.

## Design changes

Anything a user looks at follows [docs/DESIGN.md](./docs/DESIGN.md). Two rules matter more
than the rest: take token values from the canonical stylesheet rather than retyping them
from memory, and verify the result by looking at the built screen, not the diff. A green
build has repeatedly shipped an invisible button, an unreadable label, and a control that
did nothing.

## License of your contribution

By contributing you agree your work is released under the license in that repository's
`LICENSE`. You keep the copyright in your own contribution. Where a repository is a fork,
the upstream notice stays and ours is added below it, never in place of it.
