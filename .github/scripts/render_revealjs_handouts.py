from __future__ import annotations

import argparse
import shutil
import subprocess
from pathlib import Path
from urllib.parse import quote


DECKTAPE_PARAMS = "handout=true&pdfSeparateFragments=false"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Render revealjs handout PDFs from an already-rendered site tree."
    )
    parser.add_argument("--site-dir", type=Path, required=True)
    parser.add_argument("--base-url", required=True)
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--glob", default="lectures/**/lecture_*.html")
    parser.add_argument("--size", default="1600x900")
    parser.add_argument("--pause", type=int, default=1000)
    parser.add_argument("--load-pause", type=int, default=2000)
    return parser.parse_args()


def find_decktape() -> str:
    path = shutil.which("decktape")
    if path:
        return path
    # Try npx/bunx fallback
    for runner in ("bunx", "npx"):
        if shutil.which(runner):
            return runner
    raise FileNotFoundError(
        "decktape not found. Install with: npm install -g decktape"
    )


def build_url(base_url: str, relative_path: Path) -> str:
    relative_url = "/".join(quote(part) for part in relative_path.parts)
    return f"{base_url.rstrip('/')}/{relative_url}?{DECKTAPE_PARAMS}"


def main() -> int:
    args = parse_args()
    site_dir = args.site_dir.resolve()
    output_dir = (args.output_dir or args.site_dir).resolve()

    if not site_dir.is_dir():
        raise FileNotFoundError(f"Site directory does not exist: {site_dir}")

    html_paths = sorted(path for path in site_dir.glob(args.glob) if path.is_file())
    if not html_paths:
        raise FileNotFoundError(
            f"No lecture HTML files matched {args.glob!r} under {site_dir}"
        )

    decktape = find_decktape()
    is_runner = decktape in ("bunx", "npx")

    for html_path in html_paths:
        relative_html = html_path.relative_to(site_dir)
        pdf_path = output_dir / relative_html.with_suffix(".pdf")
        pdf_path.parent.mkdir(parents=True, exist_ok=True)

        url = build_url(args.base_url, relative_html)
        print(
            f"Printing {relative_html} -> {pdf_path.relative_to(output_dir)}",
            flush=True,
        )

        cmd = []
        if is_runner:
            cmd = [decktape, "decktape"]
        else:
            cmd = [decktape]

        cmd += [
            "reveal",
            url,
            str(pdf_path),
            "--size", args.size,
            "--pause", str(args.pause),
            "--load-pause", str(args.load_pause),
        ]

        result = subprocess.run(cmd, check=False)
        if result.returncode != 0:
            raise RuntimeError(
                f"decktape failed for {relative_html} (exit {result.returncode})"
            )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
