# Repository naming

한국어: [REPO-NAMING.ko.md](./REPO-NAMING.ko.md)

## The shape

```
<product>-<component>[-<qualifier>]
```

Lower case. Hyphens between words. Nothing else.

```
careerchat-jobs-api
secondoffice-dashboard
redrob-console
seers-api
```

`<product>` is the product family, not the company. This organization holds many product
families, so a company prefix would say nothing: it is the same for all 242 repositories.
The product is what tells two repositories apart.

`<component>` is the surface or service: `web`, `api`, `mobile`, `android`, `ios`, `admin`,
`dashboard`, `landing`, `contracts`, `infra`. Prefer one of these over a synonym, so that
`api` and `backend` do not both exist for the same idea.

`<qualifier>` narrows a component when a product has more than one of them:
`careerchat-recruiters-web` and `careerchat-jobs-web`.

## The sibling organization

[github.com/redrob-labs](https://github.com/redrob-labs) is ours too, and its repositories
look different on purpose: `redrob-code`, `redrob-cowork`, `redrob-office`. There the product
family is Redrob itself and each repository is one product, so the shape is
`redrob-<product>` with no component token, because each of those products ships as one
application rather than as a web tier and an API tier.

Both shapes are the same rule: `<product>-<component>` where a single-artifact product has no
component to name. Do not add a `-app` or `-desktop` suffix to make it look symmetrical, and
do not drop the `redrob-` prefix there: in that organization it is the product family, not a
company prefix.

## Rules

**Put the component last.** `careerchat-jobs-api`, not `api-careerchat-jobs`. Alphabetical
sort then groups a product together, which is how anyone actually reads a 242-entry list.
Measured today: 91 repositories end in a component token, and 15 do not, all of them in one
family (`redrob-ai-ms-*`, `redrob-ai-ui-*`, `redrob-ms-mail`, `redrob-ui-mail`). Those 15
are the reason this rule is written down; they are grandfathered, not a precedent.

**Lower case, hyphens, digits.** The name must match `^[a-z0-9]+(-[a-z0-9]+)*$`. Twelve
existing repositories do not, and each form costs something real:

| Form | Examples today | What it costs |
|---|---|---|
| Underscore | `jobs_scraper`, `redrob_ats_gaurav` | Splits sorting and makes the name unguessable: nobody types the underscore on the first try. |
| Upper case | `Translack`, `ShortconV2` | Git is case-sensitive and macOS is not, so a clone can differ from the remote. |
| Dot | `careerchat.me`, `redrob.io` | Reads as a hostname, and a dot is meaningful in package names, module paths and DNS. |

**No person's name.** `redrob-ats-shreeti`, `redrob-hrms-tamil` and `redrob_ats_gaurav`
name whoever was working on them. The person moves on and the name is then actively
misleading. Name the branch after a person if you must; never the repository.

**No version in the name.** `ShortconV2` cannot become v3 without a rename, and a rename is
expensive (below). A version lives in tags and releases, which are made for it.

**No `-new`, `-old`, `-poc`, `-test`, `-demo`, `-copy`, `-final`.** These describe a moment,
and the moment passes while the name stays. `devops-poc` and `marvel-demo-api` are both
still here. If a repository is genuinely temporary, say so in its description and archive it
when it is done. `-old` has exactly one legitimate use, described below.

**Suffix `-internal` for the private counterpart of a public repository.** When an open
source repository is published and a private tree is kept for the parts that cannot ship,
the private one takes `-internal`. That is the one case where a qualifier describes
visibility rather than function, and it earns it: someone reading the name needs to know
before they push.

**Match the shipped name.** The slug and the product name users see must agree. A repository
called `beaver` that ships strings saying "Redrob Data" makes every search fail in one
direction or the other. Rename it before publishing, not after.

## Description and topics

A name alone does not find a repository in a list of 241. The description and the topics are
what make one findable, and both are required.

**Every repository has a description.** One sentence, present tense, saying what the thing is
and who it is for. Start with the product name so the sentence still makes sense when GitHub
shows it without the repository name next to it.

```
Redrob Query is a JVM-free, AI-native desktop database client for PostgreSQL, MySQL, SQLite, and MongoDB.
```

Keep it under about 120 characters. GitHub accepts far more, but a long description is
truncated in the org listing and in search results, which is exactly where it was supposed to
help. Never use the repository name as its own description, and never leave a placeholder: an
empty description and `TODO` cost the same and one of them looks deliberate.

**Every repository has at least three topics.** Aim for four to twelve, drawn from these axes:

| Axis | Examples |
|---|---|
| Product family | `redrob`, `careerchat`, `secondoffice` |
| Component | `desktop-app`, `browser-extension`, `cli`, `microservices` |
| Domain | `graphics-editor`, `sql-client`, `identity-verification`, `evaluation` |
| Primary language and runtime | `rust`, `typescript`, `python`, `tauri`, `nextjs`, `electron` |
| Notable property | `local-first`, `self-hosted`, `open-weights`, `i18n`, `korean` |

Topics are lower case with hyphens; GitHub enforces that, so the shape is not up to you. Do
not add a topic that duplicates the name (`redrob-query` on `redrob-query`), and do not pad
to look thorough: a topic exists to be clicked.

**A fork names its upstream in a topic.** `opencode-fork`, `openwork`, `openpencil`,
`freecad`, `chromium`. Someone deciding whether to trust a fork wants to know what it forked
before they read a line of it, and this is where they look first.

**Set the homepage** for anything with a deployed URL. It renders next to the description and
saves a round trip through the README.

### The state of this today

The gap is not small, and it is one-sided:

| Organization | Repositories | Failing the rule |
|---|---|---|
| `redrob-labs` | 17 | 0 |
| `mckinley-and-rice` | 241 | 237 |

`redrob-labs` is complete because it is public and someone would notice. This organization is
mostly private, so nobody noticed: 79% have no description at all and 87% have no topics.

### Checking it

GitHub has no setting that requires either field, so this rule needs a check of its own:

```bash
./scripts/audit-metadata.sh mckinley-and-rice        # report
./scripts/audit-metadata.sh redrob-labs --fail       # non-zero exit when anything is missing
```

It reads the same two fields the rule is about, skips archived repositories, and fails only
with `--fail`, so it can report while a backlog exists and gate once the backlog is cleared.
The thresholds it enforces are a description of at least 20 characters and at least 3 topics.

Fixing one repository is one command:

```bash
gh repo edit <owner>/<name> \
  --description "One sentence saying what it is and who it is for." \
  --homepage "https://example.com" \
  --add-topic typescript --add-topic desktop-app --add-topic korean
```

## Renaming is expensive, and partly irreversible

GitHub redirects the old name to the new one, and that redirect is fragile in ways that are
easy to discover too late.

- **New repositories take priority over redirects.** The moment something else is created at
  the old name, the redirect stops. So the old name is not free to reuse, ever, if anything
  still refers to it.
- **Actions do not follow redirects at all.** A workflow with `uses: org/name@ref` breaks
  immediately on rename, with no redirect to save it.
- **Releases do not move.** They stay on the repository they were published from, so every
  release download link breaks when the repository they came from is replaced rather than
  renamed.
- **Branch protection and rulesets are per repository** and are recreated by hand.
- **A `ghcr.io/<org>/<name>` package is bound to the repository that first published it, and
  that binding does not follow a rename.** After the rename the new repository is denied
  both push and pull with `permission_denied: read_package`, whatever permissions the
  workflow has. Publish as `ghcr.io/${{ github.repository }}/<name>` instead, which is
  repository-owned and survives a rename.

So: **decide the name before the first push.** Where a rename is unavoidable, the order that
does not lose anything is:

1. Rename the existing repository to `<name>-old`.
2. **Repoint every local clone's remote and every workflow reference at `-old` explicitly.**
   This is the dangerous gap. Skip it and an existing clone's next push goes silently to
   whatever now sits at the original name.
3. Create or rename the replacement into the freed name.
4. Recreate branch protection and rulesets.
5. Republish any container image under the new repository.

## Visibility

A repository is private by default and made public deliberately, after an audit of its
**whole history**, not its current tree. Going public is effectively irreversible: forks
created while it was public survive as separate networks, and a commit that entered a fork
network stays reachable from upstream after you delete the branch.

A fork is public the moment it is created, and a fork's visibility cannot be changed. There
is no such thing as a private staging area for a fork of a public repository.

## Archiving

Archive rather than delete. Deleting a repository takes its issues, pull request discussion
and tags with it, and those are usually the only record of why something was done the way it
was. Before deleting anything, name what only exists there.
