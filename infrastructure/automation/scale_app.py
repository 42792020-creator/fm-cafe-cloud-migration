#!/usr/bin/env python3
"""
scale_app.py

Usage:
  python scale_app.py <count>

What it does:
- Edits the provided tfvars file (default: ../envs/dev.tfvars)
  to set 'app_instance_count = <count>'.
- Runs 'terraform apply -var-file=... -auto-approve' from the
  infrastructure folder (cwd="..").

Notes:
- Intended for LocalStack / Terraform CLI automation.
- Ensure terraform and python are available in PATH.
"""

import subprocess
import sys
from pathlib import Path

def set_scale(count, tfvars_path="../envs/dev.tfvars"):
    p = Path(tfvars_path).resolve()
    if not p.exists():
        raise FileNotFoundError(f"tfvars file not found: {p}")

    # Read current file
    text = p.read_text(encoding="utf-8")
    lines = text.splitlines()
    out_lines = []
    found = False

    # Replace existing app_instance_count line if present
    for l in lines:
        if l.strip().startswith("app_instance_count"):
            out_lines.append(f'app_instance_count = {count}')
            found = True
        else:
            out_lines.append(l)
    if not found:
        # Append the variable if it did not exist
        out_lines.append(f'app_instance_count = {count}')

    # Write back
    p.write_text("\n".join(out_lines), encoding="utf-8")
    print(f"[INFO] Updated tfvars: {p}")

    # Run terraform apply from the infrastructure folder (one level up)
    print("[INFO] Running terraform apply ... (this may take a while)")
    subprocess.check_call(["terraform", "apply", "-var-file=" + str(p), "-auto-approve"], cwd=str(p.parent.parent))

if __name__ == "__main__":
    # Allow optional second argument for tfvars path
    if len(sys.argv) not in (2, 3):
        print("Usage: python scale_app.py <count> [tfvars_path]")
        sys.exit(1)

    count = sys.argv[1]
    tfvars_path = sys.argv[2] if len(sys.argv) == 3 else "../terraform/envs/dev.tfvars"

    try:
        count = int(count)
        if count < 0:
            raise ValueError("count must be >= 0")
    except ValueError as e:
        print(f"Invalid count: {e}")
        sys.exit(1)

    try:
        set_scale(count, tfvars_path)
    except Exception as exc:
        print(f"[ERROR] {exc}")
        sys.exit(2)
