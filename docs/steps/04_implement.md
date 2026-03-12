Zaimplementuj poniższy plan.

Pamiętaj aby przestrzegać zasad z @AGENTS.md

Dopilnuj, aby wszelkie cubity miały unit testy.

Nie rób jednego wielkiego commitu.

Spradzaj po drodze flutter analyze i jak jest okej to commituj i rób dalej.

Doplinuj, aby ostatecznie aplikacja przechodziła flutter analyze oraz wszystkie testy.

Dopilnij aby wszelkie migracje były zaimplemntowane po stronie Supabase - masz dostęp przez MCP.

Jak będzie gotowe, poinformuj o tym użytkownika oraz użyj wtedy emojis `🎉🎉🎉`.

# IMPLEMENTATION PLAN:

## 1. Setup & Dependencies
- [ ] Dodaj zależności: `cunning_document_scanner`, `pdf`, `printing`, `share_plus`, `path_provider`, `uuid`
- [ ] Konfiguracja uprawnień Camera (Android: Manifest, iOS: Info.plist)

## 2. Supabase Schema (Prefix: `mobiscan_`)
- [ ] Migracja 0005: Tabela `mobiscan_documents` (id, user_id, name, created_at)
- [ ] Migracja 0006: Tabela `mobiscan_pages` (id, document_id, storage_path, page_index)
- [ ] Skonfiguruj RLS dla obu tabel (tylko właściciel ma dostęp)

## 3. Data Layer (Clean Architecture)
- [ ] Modele: `DocumentModel`, `PageModel`
- [ ] `DocumentDataSource`: Abstrakcja + Supabase implementation
- [ ] `DocumentRepository`: Abstrakcja + Implementation (Strumień dokumentów)

## 4. Business Logic (Cubits)
- [ ] `DocumentListCubit`: Lista dokumentów (początkowy stan `initial`, ładowanie w konstruktorze)
- [ ] `DocumentScannerCubit`: Obsługa `cunning_document_scanner`, zapis tymczasowy zdjęć
- [ ] `DocumentDetailCubit`: Zarządzanie konkretnym dokumentem (zmiana nazwy, dodawanie stron, usuwanie)
- [ ] `PdfExportCubit`: Generowanie PDF z obrazów i udostępnianie

## 5. UI Layer
- [ ] `HomeScreen`: Lista skanów, FAB do skanowania, wyszukiwanie
- [ ] `DocumentScannerScreen`: Ekran integracyjny ze skanerem
- [ ] `DocumentDetailScreen`: Podgląd stron, edycja nazwy, przycisk Export PDF

## 6. Verification
- [ ] Unit testy dla wszystkich nowych Cubitów
- [ ] `flutter analyze`
