from __future__ import annotations

import argparse
from pathlib import Path
from urllib.parse import quote

from playwright.sync_api import sync_playwright


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Render revealjs handout PDFs from an already-rendered site tree."
    )
    parser.add_argument("--site-dir", type=Path, required=True)
    parser.add_argument("--base-url", required=True)
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--glob", default="lectures/**/lecture_*.html")
    parser.add_argument("--paper-format", default="A4")
    parser.add_argument("--wait-selector", default=".reveal.ready")
    parser.add_argument("--timeout-ms", type=int, default=30000)
    parser.add_argument("--settle-ms", type=int, default=2000)
    return parser.parse_args()


def build_url(base_url: str, relative_path: Path) -> str:
    relative_url = "/".join(quote(part) for part in relative_path.parts)
    return f"{base_url.rstrip('/')}/{relative_url}?view=print"


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

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch()
        context = browser.new_context(
            color_scheme="light",
            service_workers="block",
            viewport={"width": 1600, "height": 900},
        )

        for html_path in html_paths:
            relative_html = html_path.relative_to(site_dir)
            pdf_path = output_dir / relative_html.with_suffix(".pdf")
            pdf_path.parent.mkdir(parents=True, exist_ok=True)

            url = build_url(args.base_url, relative_html)
            print(
                f"Printing {relative_html} -> {pdf_path.relative_to(output_dir)}",
                flush=True,
            )

            page = context.new_page()
            page.set_default_timeout(args.timeout_ms)

            response = page.goto(url, wait_until="networkidle")
            if response is None or not response.ok:
                status = "no response" if response is None else response.status
                raise RuntimeError(f"Failed to load {url} ({status})")

            page.locator(args.wait_selector).wait_for()
            page.wait_for_function("document.fonts.status === 'loaded'")
            page.wait_for_timeout(args.settle_ms)
            page.pdf(
                path=str(pdf_path),
                format=args.paper_format,
                margin={"top": "0", "right": "0", "bottom": "0", "left": "0"},
                print_background=True,
            )
            page.close()

        context.close()
        browser.close()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
