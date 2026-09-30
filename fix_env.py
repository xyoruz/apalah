import re, os, shutil, base64                     
raw = open(".env", encoding="utf-8-sig", errors="ignore").read().replace("\r", "")                  vals, order = {}, []                              
for line in raw.split("\n"):
    s = line.strip()
    if not s or s.startswith("#") or "=" not in s:
        continue                                      if s.startswith("export "):
        s = s[7:].strip()                             k, v = s.split("=", 1)
    k, v = k.strip(), v.strip()
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", k):
        continue
    if v[:1] in ("'", '"'):
        v = v[1:]
    if v[-1:] in ("'", '"'):
        v = v[:-1]
    if k not in vals:
        order.append(k)
    vals[k] = v.strip()

if not os.path.exists(".env.bak"):
    shutil.copy(".env", ".env.bak")

with open(".env", "w", encoding="utf-8") as f:
    for k in order:
        f.write("%s='%s'\n" % (k, vals[k].replace("'", "\\'")))

NEED = [
    "BOT_TOKEN", "BASE_API_URL", "BASE_CIAM_URL", "BASIC_AUTH", "UA",
    "API_KEY", "AX_FP_KEY", "ENCRYPTED_FIELD_KEY", "XDATA_KEY",
    "AX_API_SIG_KEY", "X_API_BASE_SECRET",
]

warn = ["%s kosong" % k for k in NEED if not vals.get(k)]
warn += ["%s terpotong (ada '>')" % k for k in NEED if ">" in vals.get(k, "")]

ba = vals.get("BASIC_AUTH", "")
try:
    d = base64.b64decode(ba + "=" * (-len(ba) % 4), validate=True).decode()
    if ":" not in d or len(d.split(":", 1)[1]) < 8:
        raise ValueError
except Exception:
    if ba and "BASIC_AUTH terpotong (ada '>')" not in warn:
        warn.append("BASIC_AUTH tidak lengkap")

print("PERINGATAN: " + "; ".join(warn) + " -> OTP bisa gagal" if warn else ".env OK")
