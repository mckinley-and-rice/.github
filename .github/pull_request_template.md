## What this changes

<!-- One sentence a reviewer can repeat back. If it takes more, the branch is doing more than
one thing. -->

## Why

<!-- What was wrong, and why this is the right shape of fix. Not what the diff already shows.
If the cause was somewhere other than where the symptom appeared, say so. -->

## How it was verified

<!-- Name the command you ran or the screen you looked at, and what it said. A green build is
not verification of anything a user sees: run it and look at it.

Any count, size, version or timing in this description is re-measured from the built artifact,
and says which surface produced it. -->

- [ ] The repository's own gates pass locally
- [ ] Verified against the built artifact, not only the diff
- [ ] No credential, token or `.env` file in the diff
- [ ] User-facing strings go through the translation layer, in both locale tables

## Anything a reviewer should look at first

<!-- A decision you are unsure about, a tradeoff you made, a file that looks worse than it is.
Delete this section if there is nothing. -->
