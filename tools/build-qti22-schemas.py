#!/usr/bin/env python3
"""Build or check the reproducible, offline QTI 2.2 schema bundle.

Run from any directory with Python 3. No third-party Python packages are needed.
The original schemas and their copyright notices remain in the repository.
"""

import argparse
import io
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[1]
INST = ROOT / "inst"
OUTPUT = INST / "schemas" / "qti22.zip"


def bundle():
    paths = [INST / "xsd" / name for name in (
        "imsqti_v2p2.xsd", "imsqtiv2p2_html5_v1p0.xsd"
    )]
    for directory in ("w3", "apipv1p0"):
        paths.extend((INST / directory).rglob("*.xsd"))
    result = io.BytesIO()
    with zipfile.ZipFile(result, "w", compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9) as archive:
        for path in sorted(paths):
            info = zipfile.ZipInfo(path.relative_to(INST).as_posix(),
                                   date_time=(1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, path.read_bytes(), compresslevel=9)
    return result.getvalue()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = bundle()
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != data:
            parser.exit(1, "Schema bundle is stale; run tools/build-qti22-schemas.py\n")
        print("Schema bundle matches its source files.")
    else:
        OUTPUT.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT.write_bytes(data)
        print(f"Wrote {OUTPUT.relative_to(ROOT)} ({len(data):,} bytes)")
