# Minna Dịch 🇯🇵🇻🇳

Ứng dụng luyện dịch Việt → Nhật theo giáo trình ngữ pháp **Minna no Nihongo (Bài 1–25)** viết bằng **SwiftUI thuần** (iOS 16+, Swift 5.9+).

- **100% Offline**, không dùng WebView, không phụ thuộc server hay internet.
- **Không Entitlements / Capabilities đặc biệt** (không Push, iCloud, App Group...) giúp tương thích 100% và ký cực kỳ dễ dàng qua **eSign, TrollStore, Scarlet, GBox, AltStore, Sideloadly**.
- Tự động đóng gói `.ipa` unsigned qua **GitHub Actions CI/CD** hoàn toàn miễn phí.

---

## 📱 Tính năng chính

1. **Màn hình chính (25 Bài)**:
   - Danh sách bài 1 đến 25 bám sát lộ trình Minna no Nihongo.
   - Thẻ thống kê tổng quan: tổng số câu đã làm, số câu đúng, tỷ lệ hoàn thành (%).
   - Thanh tiến độ (Progress bar) cho từng bài học.
   - Thanh tìm kiếm bài học và mẫu ngữ pháp nhanh chóng.

2. **Màn hình luyện tập**:
   - Câu tiếng Việt mẫu hiển thị to rõ.
   - Ô nhập liệu tiếng Nhật: hỗ trợ bộ gõ IME Nhật Bản, tự động tắt auto-correct để không bị nhảy chữ.
   - Nút **Kiểm tra**:
     + Chuẩn hóa thông minh (`JapaneseNormalizer`): tự động bỏ khoảng trắng full-width `　`, half-width ` `, dấu câu tiếng Nhật `。` `、` và phương Tây.
     + Hỗ trợ nhiều cách viết tương đương (**alternatives**): Kanji, Hiragana, Katakana.
   - Nút **Xem đáp án**: Hiển thị câu chuẩn, Romaji phiên âm (bật/tắt trong Cài đặt).
   - **Giải thích trợ từ chi tiết**: Phân tích rõ các trợ từ trong câu (`は`, `が`, `を`, `に`, `で`, `へ`, `の`, `も`, `と`, `から`, `まで`, `ね`, `よ`...) kèm lý do vì sao dùng.
   - Xem tóm tắt **Mẫu ngữ pháp chính** của bài học.
   - Đánh dấu sao (**Bookmark ★**) các câu khó để ôn tập lại.

3. **Chế độ Ôn tập**:
   - Tổng hợp các câu làm sai và các câu đã đánh dấu sao.
   - Lọc theo chế độ: *Tất cả*, *Chỉ câu làm sai*, *Chỉ câu đã đánh dấu*.
   - Nút **Xáo trộn (Shuffle)** để luyện phản xạ ngẫu nhiên từ nhiều bài học khác nhau.

4. **Cài đặt & Cá nhân hóa**:
   - Bật / Tắt phiên âm Romaji.
   - Giao diện: Tự động theo Hệ thống / Sáng (Light) / Tối (Dark).
   - Cỡ chữ linh hoạt: Nhỏ, Tiêu chuẩn, Lớn, Rất lớn.
   - Đặt lại toàn bộ tiến độ học tập (Reset Progress) kèm cảnh báo an toàn.

---

## 📂 Cấu trúc mã nguồn

```
Nihongo/
├── .github/
│   └── workflows/
│       └── build-ipa.yml        # CI/CD tự build IPA unsigned trên macOS runner
├── project.yml                  # Cấu hình XcodeGen (generate .xcodeproj chuẩn)
├── MinnaDich/
│   ├── MinnaDichApp.swift       # Entry point @main của ứng dụng
│   ├── Models/
│   │   ├── Lesson.swift         # Data model Bài học
│   │   ├── Exercise.swift       # Data model Câu bài tập
│   │   ├── ParticleNote.swift   # Model chú thích trợ từ
│   │   └── UserProgress.swift   # Model lưu tiến độ người dùng
│   ├── Services/
│   │   ├── LessonLoader.swift       # Đọc dữ liệu từ lessons.json
│   │   ├── ProgressStore.swift      # Quản lý & lưu trữ tiến độ (UserDefaults + Codable)
│   │   └── JapaneseNormalizer.swift # Thuật toán chuẩn hóa & so khớp câu dịch tiếng Nhật
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── PracticeViewModel.swift
│   │   ├── ReviewViewModel.swift
│   │   └── SettingsViewModel.swift
│   ├── Views/
│   │   ├── MainTabView.swift
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   └── LessonRowView.swift
│   │   ├── Practice/
│   │   │   ├── PracticeView.swift
│   │   │   ├── ParticleExplanationSheet.swift
│   │   │   ├── GrammarPointsSheet.swift
│   │   │   └── AnswerComparisonView.swift
│   │   ├── Review/
│   │   │   └── ReviewView.swift
│   │   └── Settings/
│   │       └── SettingsView.swift
│   └── Resources/
│       ├── lessons.json             # Bộ 80 câu tự soạn bài 1-5 & khung 25 bài
│       ├── Info.plist               # Cấu hình bundle iOS thuần
│       └── Assets.xcassets/         # AppIcon & AccentColor
└── README.md
```

---

## 🚀 Hướng dẫn Build IPA bằng GitHub Actions (Không cần Mac)

1. Tạo một repository mới trên GitHub (public hoặc private).
2. Đẩy toàn bộ mã nguồn này lên repo:
   ```bash
   git init
   git add .
   git commit -m "Initial commit Minna Dịch iOS app"
   git branch -M main
   git remote add origin https://github.com/<username>/<repo-name>.git
   git push -u origin main
   ```
3. Trên trang GitHub của bạn, vào tab **Actions**:
   - Workflow **Build Unsigned IPA** sẽ tự động chạy (hoặc bấm **Run workflow**).
   - Quá trình chạy mất khoảng 2–3 phút trên máy ảo `macos-14` của GitHub.
4. Khi build hoàn tất (tích xanh):
   - Cuộn xuống phần **Artifacts** ở cuối trang chạy.
   - Nhấn tải file `MinnaDich-unsigned-ipa.zip` về máy.
   - Giải nén sẽ có file `MinnaDich-unsigned.ipa`.

---

## 📲 Hướng dẫn ký và cài đặt bằng eSign trên iPhone / iPad

1. Gửi file `MinnaDich-unsigned.ipa` vào ứng dụng **Tệp (Files)** trên iPhone.
2. Mở ứng dụng **eSign** (hoặc TrollStore / Scarlet / GBox).
3. Chọn tính năng **Import (Nhập)** file `MinnaDich-unsigned.ipa`.
4. Chọn chứng chỉ bạn đang có (chứng chỉ Doanh nghiệp, chứng chỉ DNS cert, hoặc chứng chỉ Dev cá nhân) và bấm **Ký (Sign)**.
5. Sau khi ký xong, nhấn **Cài đặt (Install)** trực tiếp lên màn hình chính và bắt đầu luyện dịch!

---

## ✍️ Cách bổ sung thêm câu hỏi vào các bài 6–25

Mở file [MinnaDich/Resources/lessons.json](file:///c:/Users/nntfy/Desktop/Nihongo/MinnaDich/Resources/lessons.json), tìm đến bài bạn muốn thêm bài tập và điền vào mảng `exercises`:

```json
{
  "id": "L6-001",
  "vi": "Tôi uống cà phê tại quán giải khát.",
  "answer": "きっさてんで コーヒーを のみます。",
  "romaji": "Kissaten de koohii o nomimasu.",
  "alternatives": [
    "喫茶店でコーヒーを飲みます。",
    "きっさてんでコーヒーを飲みます。"
  ],
  "particleNotes": [
    {
      "particle": "で",
      "explain": "Chỉ nơi chốn diễn ra hành động uống (tại quán nước)."
    },
    {
      "particle": "を",
      "explain": "Đọc là 'o', trợ từ chỉ đối tượng của tha động từ (uống cà phê)."
    }
  ]
}
```
Sau đó chỉ cần `git push`, GitHub Actions sẽ tự động re-build lại file IPA mới cho bạn!
