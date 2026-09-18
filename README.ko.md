# 엔지니어링 표준

이 조직의 모든 저장소가 따르는 작업 규약입니다. 저장소와 브랜치 이름을 어떻게 정하는지,
머지 전에 무엇이 초록불이어야 하는지, 에이전트가 우리 트리에서 무엇을 지켜야 하는지,
제품 화면이 어떤 모습이어야 하는지를 정합니다.

English: [README.md](./README.md)

## 문서 목록

| 문서 | 정하는 것 |
|---|---|
| [CONTRIBUTING.ko.md](./CONTRIBUTING.ko.md) | 기본 기여 규약. 저장소가 자기 것으로 덮어쓸 수 있습니다. |
| [CODE_OF_CONDUCT.ko.md](./docs/CODE_OF_CONDUCT.ko.md) | 서로를 대하는 방식. |
| [SECURITY.md](./SECURITY.md) | 취약점 신고를 보내는 곳. 공개 이슈는 절대 아닙니다. |
| [SUPPORT.md](./SUPPORT.md) | 질문을 보내는 곳. |
| [AGENTS.md](./AGENTS.md) | 우리 저장소에서 작업하는 AI 에이전트가 지켜야 할 것. |
| [docs/GITFLOW.ko.md](./docs/GITFLOW.ko.md) | 브랜치, 머지, 릴리스, 핫픽스, 그리고 CI가 실제로 강제하는 것. |
| [docs/REPO-NAMING.ko.md](./docs/REPO-NAMING.ko.md) | 저장소 이름 규칙과, 나중에 개명하는 비용이 왜 큰지. |
| [docs/DESIGN.ko.md](./docs/DESIGN.ko.md) | 토큰, 타이포, 모션, 그리고 제품 화면이 따르는 규칙. |

## GitHub가 자동으로 물려주는 것과 물려주지 않는 것

이 저장소 이름은 `.github` 이고, GitHub는 이 이름을 특별하게 취급합니다. 아래 경로의 파일은
**이 조직에서 자기 사본이 없는 모든 저장소**에 그대로 쓰입니다. 저장소 자신의 파일이 항상
이기므로, 이것은 덮어쓰기가 아니라 바닥값입니다.

자동 상속:

- `CODE_OF_CONDUCT.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `SUPPORT.md`
- `.github/ISSUE_TEMPLATE/*`
- `.github/pull_request_template.md`
- `profile/README.md` (조직 공개 프로필 페이지에 렌더링됩니다)

**상속되지 않는 것.** `AGENTS.md`, `docs/GITFLOW.md`, `docs/REPO-NAMING.md`,
`docs/DESIGN.md` 는 평범한 저장소의 평범한 파일입니다. GitHub에 이것을 전파하는 장치는 없고,
`AGENTS.md` 를 읽는 에이전트 도구는 자기가 작업 중인 트리의 것만 읽습니다. 이 문서들이 필요한
저장소는 여기를 링크하는 짧은 파일을 두거나, 실제로 따르는 부분만 복사합니다. 링크가 낫습니다.
사본은 갈라지고, 갈라진 것을 아무도 보고하지 않습니다.

`workflow-templates/` 는 상속이 아니라 제공입니다. 이 조직 저장소의 "New workflow" 목록에
우리 `gitflow` 검사를 올려, 새 저장소가 이름 잘못된 브랜치를 한 번 겪은 뒤에 게이트를 얻는 대신
처음부터 갖고 시작하게 합니다.

**상속은 조직 경계에서 멈춥니다.** 이 기본값은 이 조직의 저장소에만 닿습니다. 다른 조직의
저장소는 같은 사람이 둘 다 소유하더라도 그 조직 자신의 `.github` 저장소가 필요합니다.

**한국어 행동 규범은 영어판 옆이 아니라 `docs/` 에 있습니다.** GitHub는 health file 슬롯마다
파일 하나를 고르는데, 루트에 `CODE_OF_CONDUCT.md` 와 `CODE_OF_CONDUCT.ko.md` 가 함께 있으면
242개 저장소 전부에 대해 한국어판을 골랐습니다. `docs/` 는 루트보다 낮은 우선순위로 스캔되므로
영어 파일이 슬롯을 차지하고 한국어 파일은 여전히 한 번의 클릭 거리에 있습니다. 되돌려 놓지
마십시오. 다른 모든 한국어 문서는 영어 짝 옆에서 `.ko.md` 이름을 유지합니다. GitHub 슬롯이
가져가는 문서가 그것 말고는 없기 때문입니다.

## 표준을 바꿀 때

이 저장소는 자기가 발행하는 표준을 스스로 따릅니다. 그래서 변경은 `develop` 을 향한 풀 리퀘스트로
들어옵니다.

| | |
|---|---|
| `develop` | 기본. 모든 변경이 먼저 여기로 들어옵니다. |
| `main` | 발행된 상태. 이슈 템플릿과 조직 프로필이 링크하는 곳입니다. |
| 브랜치 이름 | `<type>/<slug>`, 타입은 `feat fix chore docs test refactor perf`. |
| 필수 체크 | `branch name follows the convention` |

두 브랜치 모두 보호됩니다. 풀 리퀘스트만 허용되고, force push와 삭제는 막습니다.

`main` 은 `develop` 에서 오는 승격 풀 리퀘스트로 움직이며 **merge 커밋**으로 머지되고, 그 승격 뒤에
`main` 을 `develop` 으로 되머지하는 풀 리퀘스트가 따라옵니다. 승격 한 번에 풀 리퀘스트 두 개가 이
모델의 실제 비용이고, 이 저장소는 242개의 다른 저장소에 요구하는 규칙에서 자기를 빼는 대신 그 비용을
냅니다.

되머지는 선택적인 사무 절차가 아닙니다. `gitflow` 워크플로는 `main` 이 `develop` 에 없는 커밋을 갖고
있는 동안 `main` 에 대한 모든 푸시에서 실패하며, merge 커밋 승격은 되머지가 들어올 때까지 항상 정확히
그 상태를 남깁니다.

이 저장소가 쓰지 않는 부분은 `release/*` 와 버전 태그입니다. 빌드할 산출물이 없어 태그할 것이 없고,
상류가 없으므로 `sync` 도 해당되지 않습니다. 그래서 이 저장소의 `ALLOWED_TYPES` 는
[docs/GITFLOW.ko.md](./docs/GITFLOW.ko.md) 의 전체 세트보다 짧고, 주석에 그 이유가 적혀 있습니다.

이 문서들은 규칙으로 읽히므로, 하나를 바꾸는 것은 모든 저장소가 어떻게 동작해야 하는지를 바꾸는
일입니다. 규칙과 저장소가 어긋나면 둘 중 하나가 틀린 것입니다. 어느 쪽인지 풀 리퀘스트에
적으십시오. 아무것도 검사하지 않는 규칙은 취향입니다. 그러니 검사가 옆에 붙은 규칙을 쓰고, 검사할 수
없다면 검사되지 않는다는 사실을 문서에 분명히 적으십시오.

## 우리의 다른 조직

[github.com/redrob-labs](https://github.com/redrob-labs) 도 우리 것입니다. 오픈소스 제품과 연구가
거기에 있습니다. Redrob Code, Cowork, Office, Design, Canvas, Query, Recall, Eval, Studio,
Verify, Image.

나뉜 기준은 소유가 아니라 대상입니다. 이 조직은 고객 작업과 플랫폼 작업이고 대부분 비공개입니다.
`redrob-labs` 는 회사 밖 사람들이 쓰도록 우리가 발행하는 것입니다.

**이 기본값은 그곳에 닿지 않습니다.** GitHub health file 상속은 조직 경계에서 멈추므로
`redrob-labs` 는 자기 `.github` 저장소가 필요하고, 아직 없습니다. 그곳의 저장소들은 현재 각자
`CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` 를 갖고 있습니다. `docs/` 의 표준은 쓰인
그대로 두 조직 모두에 적용되며, 이 조직에만 한정되는 것은 자동 상속뿐입니다.
