# 🔒 Security & Environment Variables

## ⚠️ PENTING: API Key Protection

API key dan credential sensitif **TIDAK BOLEH** di-commit ke Git repository.

## ✅ Yang Sudah Diamankan

### 1. **File .gitignore sudah diupdate**
File-file berikut sudah otomatis diabaikan Git:
- `.env` dan semua variannya (`.env.local`, `.env.*.local`)
- `google-services.json` (Firebase)
- `firebase_options.dart`
- `secrets/` folder
- `api_keys.json`
- File konfigurasi sensitif lainnya

### 2. **Environment Variables System**
- ✅ Package `flutter_dotenv` sudah ditambahkan
- ✅ API key dipindahkan dari hardcode ke `.env` file
- ✅ Helper class `EnvConfig` untuk mengelola env variables
- ✅ Validasi otomatis saat aplikasi start
- ✅ Error handling jika `.env` tidak ada atau salah

### 3. **Template File**
- ✅ `.env.example` sebagai template untuk developer lain
- ✅ Dokumentasi cara setup lengkap

---

## 🚀 Setup untuk Development

### Langkah 1: Copy Template
```bash
# Di terminal, jalankan:
copy .env.example .env
```

Atau manual: Copy file `.env.example` dan rename menjadi `.env`

### Langkah 2: Isi API Keys
Edit file `.env` dan isi dengan API key Anda:

```env
GEMINI_API_KEY=AIzaSyAzrrKzQwadKTUyWDvEWntF3vz20jRe0NI
```

**Cara mendapatkan Gemini API Key:**
1. Buka https://makersuite.google.com/app/apikey
2. Login dengan Google Account
3. Klik "Create API Key"
4. Copy dan paste ke file `.env`

### Langkah 3: Install Dependencies
```bash
flutter pub get
```

### Langkah 4: Run Aplikasi
```bash
flutter run
```

---

## 📁 Struktur File Sensitif

```
muslim_app/
├── .env                    # ❌ JANGAN COMMIT (sudah di .gitignore)
├── .env.example            # ✅ Safe untuk commit (template saja)
├── lib/
│   └── config/
│       └── env_config.dart # ✅ Safe untuk commit (tidak ada API key)
└── .gitignore             # ✅ Sudah diupdate
```

---

## 🔐 Best Practices

### ✅ DO (Lakukan):
1. **Selalu simpan API key di `.env` file**
2. **Commit `.env.example` tapi JANGAN commit `.env`**
3. **Gunakan `EnvConfig.geminiApiKey` untuk akses API key**
4. **Rotate API key secara berkala**
5. **Tambahkan API key restrictions di Google Cloud Console**
6. **Review `.gitignore` sebelum commit**

### ❌ DON'T (Jangan):
1. **Hardcode API key di source code**
2. **Commit file `.env` ke Git**
3. **Share API key di chat/email/screenshot**
4. **Gunakan API key production di development**
5. **Push API key ke public repository**

---

## 🛡️ Menambahkan API Key Baru

### Contoh: Menambahkan API key untuk service lain

**1. Tambahkan ke `.env`:**
```env
GEMINI_API_KEY=your_gemini_key_here
QURAN_API_KEY=your_quran_api_key_here
PRAYER_API_KEY=your_prayer_api_key_here
```

**2. Tambahkan ke `.env.example`:**
```env
GEMINI_API_KEY=your_gemini_key_here
QURAN_API_KEY=your_quran_api_key_here
PRAYER_API_KEY=your_prayer_api_key_here
```

**3. Tambahkan getter di `env_config.dart`:**
```dart
static String get quranApiKey {
  return dotenv.env['QURAN_API_KEY'] ?? '';
}

static String get prayerApiKey {
  return dotenv.env['PRAYER_API_KEY'] ?? '';
}
```

**4. Update validasi di `env_config.dart`:**
```dart
static void validate() {
  final requiredKeys = [
    'GEMINI_API_KEY',
    'QURAN_API_KEY',      // Tambahkan ini
    'PRAYER_API_KEY',     // Tambahkan ini
  ];
  // ... rest of validation
}
```

---

## 🚨 Troubleshooting

### Error: "GEMINI_API_KEY tidak ditemukan"
**Solusi:**
1. Pastikan file `.env` ada di root project
2. Pastikan ada baris `GEMINI_API_KEY=your_key_here`
3. Restart aplikasi dengan `flutter run`

### Error: "Gagal load .env file"
**Solusi:**
1. Pastikan `.env` ada di: `d:\pa fajar aplikasi\muslim_app\.env`
2. Pastikan `.env` sudah ditambahkan di `pubspec.yaml` assets
3. Run `flutter clean` lalu `flutter pub get`

### API Key Terekspos di Git History
**Solusi:**
1. **IMMEDIATE**: Revoke API key di Google Cloud Console
2. Generate API key baru
3. Gunakan git-filter-repo atau BFG Repo-Cleaner untuk hapus dari history
4. Force push (hati-hati!)

```bash
# Hapus dari Git history (DANGER: backup dulu!)
git filter-branch --force --index-filter \
"git rm --cached --ignore-unmatch .env" \
--prune-empty --tag-name-filter cat -- --all

# Push dengan force
git push origin --force --all
```

---

## 📊 Checklist Sebelum Commit

- [ ] File `.env` sudah di `.gitignore`
- [ ] Tidak ada hardcoded API key di source code
- [ ] `.env.example` sudah update dengan key baru (tanpa value asli)
- [ ] Run `git status` dan pastikan `.env` tidak muncul
- [ ] Review `git diff` sebelum commit

---

## 🔍 Verify Security

### Check apakah .env ter-track oleh Git:
```bash
git status
```
Jika `.env` muncul di output, berarti belum di-ignore dengan benar!

### Check Git history:
```bash
git log --all --full-history --source -- .env
```
Output kosong = good ✅

### Search hardcoded API key:
```bash
# Cari di semua file
grep -r "AIzaSy" lib/
```
Jika ada hasil = masih ada hardcoded key ❌

---

## 📝 Deployment Considerations

### Production Build
Untuk production, API key sebaiknya:
1. Disimpan di CI/CD secrets (GitHub Actions, GitLab CI)
2. Diinjek saat build time
3. Gunakan API key terpisah untuk production

### Environment-specific Keys
```env
# Development
GEMINI_API_KEY=dev_key_here

# Production (jangan commit!)
# GEMINI_API_KEY=prod_key_here
```

---

## ✅ Status Keamanan

- [x] API key dipindahkan ke `.env`
- [x] `.env` sudah di `.gitignore`
- [x] Template `.env.example` tersedia
- [x] Environment config system sudah dibuat
- [x] Validasi otomatis di startup
- [x] Error handling untuk missing env vars
- [x] Dokumentasi keamanan lengkap

---

**Last Updated:** 2 Juni 2026
**Security Level:** ✅ SECURE
