#!/bin/bash
# Generate multiple hash sets from passwords.txt
# Skips comment lines starting with '#'

INPUT="passwords.txt"

# Filter out comments
PWDS=$(grep -v '^#' "$INPUT")

# MD5
echo "[*] Generating MD5 hashes..."
echo "$PWDS" | while read -r p; do
    echo -n "$p" | md5sum | awk '{print $1}'
done > hashes_md5.txt

# SHA1
echo "[*] Generating SHA1 hashes..."
echo "$PWDS" | while read -r p; do
    echo -n "$p" | sha1sum | awk '{print $1}'
done > hashes_sha1.txt

# SHA256
echo "[*] Generating SHA256 hashes..."
echo "$PWDS" | while read -r p; do
    echo -n "$p" | sha256sum | awk '{print $1}'
done > hashes_sha256.txt

# NTLM (MD4 of UTF-16LE) using Python inline
echo "[*] Generating NTLM hashes..."
python3 - <<'PY'
import hashlib
pwds = [l.strip() for l in open("passwords.txt") if not l.startswith("#")]
with open("hashes_ntlm.txt","w") as out:
    for p in pwds:
        h = hashlib.new('md4', p.encode('utf-16le')).hexdigest()
        out.write(h + "\n")
PY

# SHA512
echo "[*] Generating SHA512 hashes..."
echo "$PWDS" | while read -r p; do
    echo -n "$p" | sha512sum | awk '{print $1}'
done > hashes_sha512.txt

echo "[*] Done! Generated hashes_md5.txt, hashes_sha1.txt, hashes_sha256.txt, hashes_ntlm.txt, hashes_sha512.txt"
