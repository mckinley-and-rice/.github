# Gitflow

한국어: [GITFLOW.ko.md](./GITFLOW.ko.md)

Two long-lived branches, short working branches off `develop`, releases promoted to `main`
through a reviewed pull request. This document is the explanation; the gate is
`.github/workflows/gitflow.yml` in each repository.

## Branches

| Branch | What it is |
|---|---|
| `develop` | **Default.** Integration. Every feature, fix and upstream sync lands here first. |
| `main` | The released state. Only ever advanced by a release pull request from `develop`. |
| `<type>/<slug>` | One change, opened as a pull request into `develop`. |
| `sync/upstream-<tag>` | An upstream absorption, opened as a pull request into `develop`. Forks only. |
| `hotfix/<slug>` | A fix for something already released, into `main` **and then** `develop`. |
| `release/<version>` | Only when a release must stabilise while `develop` keeps moving. Usually skipped. |

`develop` is the default branch on purpose. Pull requests target it without anyone having
to retarget them, and the people reading a repository's default branch are contributors.
End users install a release artifact; they do not clone.

We do not use `master`.

**One kind of repository inverts this.** In an organization's `.github` repository, GitHub
serves the community health files from the default branch, so the default branch is the
surface published to every repository in the organization rather than the contributors' view.
There, `main` is the default and `develop` still integrates. The reason above is what produces
that answer, so it is not an exception to the rule but an application of it.

**Changing the default branch is a breaking change to CI.** A workflow filtered on
`branches: [main]` stops running silently when the default moves to `develop`, and silence
is not a failure, so nothing reports it. In one repository `typecheck` ran zero times on
pull requests for that reason, and the test cache missed cold on every run. After changing
a default branch, audit every workflow's branch filters in the same change.

## Working branches

`<type>/<short-slug>`. The type list is **per repository**, in that repository's
`ALLOWED_TYPES`. The lists genuinely differ, and the check fails a guess:

| Type set | Repositories using it |
|---|---|
| `feat fix chore docs test refactor perf` plus `sync hotfix release` as applicable | most |
| `feature fix release hotfix` | the older repositories, and forks that mirror upstream's vocabulary |

Read `ALLOWED_TYPES` before you name a branch. New repositories should take the first set.

A branch name says what the change is, not who or what made it. An agent or tool name is
not a type.

Renaming a branch after the check has already failed is not enough on its own: a failed run
stays keyed to the commit, so amend the commit as well, or the new pull request shows the
old red X while reporting itself mergeable.

## Merging

| Situation | Style |
|---|---|
| Working branch into `develop` | **squash** |
| Upstream sync into `develop` | **merge commit** |
| `develop` into `main` promotion | **merge commit** |
| Hotfix into `main` | **merge commit** |

Squashing an upstream sync destroys the merge base, and the next sync then replays work
already taken. Squashing a promotion loses the same relationship. Never rebase-merge either.

## Releasing

Versions are ours: `v<major>.<minor>.<patch>`, starting at `0.1.0`. A fork's version is not
derived from the upstream version it is built on; that is recorded separately (for example
in an `UPSTREAM_VERSION` file) and the release notes read it, so a release still states what
it is based on.

Do not encode a fork generation as a prerelease suffix. A `-redrob.N` suffix makes every
release a semver prerelease, which sorts **below** the release it precedes.

The sequence:

1. Merge `develop` into `main` through a promotion pull request.
2. Tag `main` and build from that tag.
3. Publish.

Order matters and is checked. A release workflow that tags `origin/main` HEAD before the
promotion lands ships the **previous** state under the new version number. The release path
should refuse while `develop` is ahead of `main`, list the commits, and offer an explicit
override for the one legitimate case: a hotfix already on `main`.

`main` moves through a reviewed pull request rather than an automated push. It is what
people believe is released, and it is the one branch where an unreviewed push is hard to
notice.

Where a release is signed, run it once in `dry_run` mode first. That builds, signs and
notarizes while publishing nothing, and it is the only reliable way to confirm the signing
credentials are actually visible to this repository. Organization secrets are inherited by
name and are not listable without admin, so a `403` from the API means unreadable, not
absent.

Two release mechanics that cost us whole builds:

**Give the release job a git identity.** `git tag -a` records a tagger, and a bare runner
without `user.name` and `user.email` dies with an empty ident error at the last step, after
the build, the signing and the notarization have all succeeded.

**Upload assets individually, with retry.** `gh release create` with an assets glob is
atomic: one transient `5xx` on one of twenty assets rolls the whole release back and
discards a forty-minute run. Create the release empty, upload each asset with backoff, then
assert the published count matches the built count.

Make the release idempotent. Once a tag exists, a retry that tries to create it fails, and
that version is permanently unusable. Reuse an existing tag and edit an existing release
instead.

## Hotfixes

Branch from `main`, not `develop`, so the fix does not drag unreleased work with it. Open
the pull request into `main`, release from there, **then merge `main` back into `develop`**
or the fix is lost at the next release.

That last step is the one that gets skipped, so it is checked. On every push to `main` the
`gitflow` workflow fails while `main` holds commits `develop` does not, and lists them. The
invariant, which you can read yourself at any time:

```bash
git rev-list --count origin/develop..origin/main   # 0, outside a release window
```

It was not 0 for a month in one repository. A fix to `bun install --frozen-lockfile` landed
on `main`, the back-merge never happened, and the default branch could not install with the
bun version its `packageManager` pinned. The rule above was already written down. Nothing
checked it, and a rule nothing checks is a preference.

## Syncing upstream (forks)

Follow upstream **tags**, not its development branch. A tag is a point upstream themselves
decided was coherent.

```sh
# once
git remote add upstream <upstream-url>

# each sync
git fetch upstream --tags
git switch develop && git pull
git switch -c sync/upstream-<tag>
git merge <tag>
```

Open the pull request into `develop`. Never merge upstream straight into `main`.

Three things hold on every sync we have run:

- **The merge base is real, so most of upstream arrives for free.** A three-way merge takes
  upstream's version of every file we never touched. You resolve only genuine
  disagreements.
- **Conflicts cluster on rebranding.** Where upstream edits a line we renamed, the merge
  cannot know which side wins. Keep ours, take their surrounding change.
- **Some upstream identifiers are load-bearing.** Do not finish a rebrand while resolving a
  conflict. Legacy config directory names are read on purpose so existing installs keep
  working, error codes are a string-compare contract that clients branch on, and some
  package names are real published packages that are not ours to rename.

## What CI enforces, and what it cannot

`.github/workflows/gitflow.yml` runs two jobs on two triggers, because they answer different
questions at different moments. A branch name can only be judged once a pull request
exists. A missing back-merge can only be judged after `main` has moved.

Both jobs report rather than block unless a repository adds them to its required checks.

Do not put a branch filter on the pull request trigger. A filter that omits the default
branch silently stops running, which is the failure this workflow was partly written to
catch.

**Workflows cannot open pull requests, and should not be given the permission.**
`gh pr create` from a workflow fails with `GitHub Actions is not permitted to create or
approve pull requests` until an organization setting is enabled, and that single setting
grants both creating and approving. In a public repository a workflow able to approve pull
requests can approve its own. Leave it off: have the workflow push the branch and print a
compare URL in the run summary, and let a person open the pull request.

Never swallow that failure with `|| echo 'already open'`. It reports a hard failure as a
benign state and hides every other cause too.

## Branch protection

Protect `develop` and `main`: everything lands through a pull request, force pushes and
deletions blocked.

Required checks must be checks that actually run on a pull request. Requiring a
`workflow_dispatch`-only workflow leaves every pull request waiting forever, so a test suite
that is paused cannot be a required check; say so in `CONTRIBUTING.md` rather than requiring
it and wondering why nothing merges.

Branch protection is per repository and is **not** inherited from this one. A renamed or
newly forked repository starts with none, and its rulesets have to be recreated.
