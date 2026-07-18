#!/usr/bin/env python3
"""Render verified links outside docs/ as canonical GitHub repository links."""

from pathlib import Path
import re
import sys
from typing import Match, Optional
from urllib.parse import quote, unquote, urlsplit, urlunsplit


REPO_ROOT = Path(__file__).resolve().parents[1]
DOCS_DIR = REPO_ROOT / "docs"
DEFAULT_REPOSITORY_URL = "https://github.com/henryvn27/orca-framework"
DEFAULT_REPOSITORY_REF = "main"

INLINE_LINK = re.compile(
    r"(?P<open>!?\[[^\]]*\]\()"
    r"(?P<destination><[^>]+>|[^\s)]+)"
    r"(?P<title>\s+(?:\"[^\"]*\"|'[^']*'|\([^)]*\)))?"
    r"(?P<close>\))"
)
FENCE = re.compile(r"^ {0,3}(?P<marker>`{3,}|~{3,})")


def _relative_to(path: Path, parent: Path) -> Optional[Path]:
    try:
        return path.relative_to(parent)
    except ValueError:
        return None


def _rewrite_destination(
    destination: str,
    *,
    source_uri: str,
    repo_root: Path,
    docs_dir: Path,
    repository_url: str,
    repository_ref: str,
) -> str:
    wrapped = destination.startswith("<") and destination.endswith(">")
    raw_destination = destination[1:-1] if wrapped else destination
    parsed = urlsplit(raw_destination)

    if (
        parsed.scheme
        or parsed.netloc
        or raw_destination.startswith(("#", "/"))
        or not parsed.path
    ):
        return destination

    source = docs_dir / Path(source_uri)
    target = (source.parent / unquote(parsed.path)).resolve()
    repository_path = _relative_to(target, repo_root)
    documentation_path = _relative_to(target, docs_dir)

    # MkDocs already owns links between included docs and their static assets.
    if repository_path is None or documentation_path is not None:
        return destination

    # Missing targets are intentionally left alone so `mkdocs build --strict`
    # continues to reject real broken links.
    if not target.exists():
        return destination

    target_kind = "tree" if target.is_dir() else "blob"
    path = quote(repository_path.as_posix(), safe="/")
    rewritten = urlunsplit(
        (
            urlsplit(repository_url).scheme,
            urlsplit(repository_url).netloc,
            f"{urlsplit(repository_url).path.rstrip('/')}/{target_kind}/{repository_ref}/{path}",
            parsed.query,
            parsed.fragment,
        )
    )
    return f"<{rewritten}>" if wrapped else rewritten


def rewrite_markdown(
    markdown: str,
    *,
    source_uri: str,
    repo_root: Path = REPO_ROOT,
    docs_dir: Path = DOCS_DIR,
    repository_url: str = DEFAULT_REPOSITORY_URL,
    repository_ref: str = DEFAULT_REPOSITORY_REF,
) -> str:
    """Rewrite verified repository links while preserving fenced examples."""

    active_fence: Optional[str] = None
    rendered = []

    for line in markdown.splitlines(keepends=True):
        fence = FENCE.match(line)
        if fence:
            marker = fence.group("marker")
            if active_fence is None:
                active_fence = marker
            elif marker[0] == active_fence[0] and len(marker) >= len(active_fence):
                active_fence = None
            rendered.append(line)
            continue

        if active_fence is not None:
            rendered.append(line)
            continue

        def replace(match: Match[str]) -> str:
            destination = _rewrite_destination(
                match.group("destination"),
                source_uri=source_uri,
                repo_root=repo_root,
                docs_dir=docs_dir,
                repository_url=repository_url,
                repository_ref=repository_ref,
            )
            return "".join(
                (
                    match.group("open"),
                    destination,
                    match.group("title") or "",
                    match.group("close"),
                )
            )

        rendered.append(INLINE_LINK.sub(replace, line))

    return "".join(rendered)


def on_page_markdown(markdown, page, config, **kwargs):
    """MkDocs hook entry point."""

    return rewrite_markdown(
        markdown,
        source_uri=page.file.src_uri,
        repository_url=str(config.get("repo_url") or DEFAULT_REPOSITORY_URL),
        repository_ref=str(config.get("extra", {}).get("repository_ref", DEFAULT_REPOSITORY_REF)),
    )


def _self_test() -> None:
    source_uri = "choose-your-path.md"
    repository_link = "[demo](../commands/orca-demo.md#usage)"
    expected = (
        "[demo](https://github.com/henryvn27/orca-framework/"
        "blob/main/commands/orca-demo.md#usage)"
    )

    assert rewrite_markdown(repository_link, source_uri=source_uri) == expected
    assert rewrite_markdown("[intro](intro.md)", source_uri=source_uri) == "[intro](intro.md)"
    assert rewrite_markdown("[missing](../missing.md)", source_uri=source_uri) == "[missing](../missing.md)"
    assert rewrite_markdown("[web](https://example.com)", source_uri=source_uri) == "[web](https://example.com)"
    assert rewrite_markdown(
        "```md\n[demo](../commands/orca-demo.md)\n```\n",
        source_uri=source_uri,
    ) == "```md\n[demo](../commands/orca-demo.md)\n```\n"


if __name__ == "__main__":
    if sys.argv[1:] != ["--self-test"]:
        raise SystemExit("usage: mkdocs_repo_links.py --self-test")
    _self_test()
    print("mkdocs-repo-links: ok")
