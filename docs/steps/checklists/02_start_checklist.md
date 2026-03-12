# Start Checklist

Jest to checklista instrukcji `docs/steps/checklists/02_start.md`.

Aktualizuj ten plik w trakcie pracy.

Statusy:
- `⬜` = `pending`
- `⏳` = `waiting_for_user`
- `✅` = `done`

## Krok 1. Sprawdź `PLATFORM_API_KEY` i dane autora

| Status | Item |
| --- | --- |
| ⬜ | `.env` istnieje |
| ⬜ | `.env` zawiera `PLATFORM_API_KEY=` |
| ⬜ | Jeśli `PLATFORM_API_KEY` brakowało: user dostał instrukcję uzupełnienia `.env` albo świadomie kontynuowano bez klucza |
| ⬜ | Jeśli `PLATFORM_API_KEY` było dostępne: podjęto próbę pobrania danych autora z endpointu user |
| ⬜ | Imię autora zostało ustalone |
| ⬜ | Nazwisko autora zostało ustalone |
| ⬜ | Jeśli endpoint user nie zwrócił danych: brak został poprawnie obsłużony ścieżką ręczną |

## Krok 2. Ustal i zweryfikuj pomysł aplikacji

| Status | Item |
| --- | --- |
| ⬜ | Ustalono konkretny pomysł na aplikację |
| ⬜ | Potwierdzono, że aplikacja robi jedną rzecz dobrze |
| ⬜ | Potwierdzono, że aplikacja jest prosta jako MVP |
| ⬜ | Potwierdzono, że aplikacja jest wykonalna w stacku Flutter + Supabase bez dodatkowych kosztów |
| ⬜ | Potwierdzono, że pomysł nie wymaga problematycznych integracji, umów ani nie narusza praw |
| ⬜ | Ustalono niszę i docelowego użytkownika |
| ⬜ | Potwierdzono, że autor sam chce z tej aplikacji korzystać |
| ⬜ | Sprawdzono endpoint community apps pod kątem duplikatu pomysłu |
| ⬜ | Potwierdzono, że pomysł nie dubluje istniejącej aplikacji community albo różnica została świadomie zaakceptowana |
| ⬜ | User zatwierdził pomysł do realizacji |

## Krok 3. Utwórz `IDEA.md`

| Status | Item |
| --- | --- |
| ⬜ | `IDEA.md` istnieje |
| ⬜ | `IDEA.md` zawiera nazwę aplikacji |
| ⬜ | `IDEA.md` zawiera imię i nazwisko autora |
| ⬜ | `IDEA.md` zawiera `APP_BUNDLE_ID` |
| ⬜ | `APP_BUNDLE_ID` ma poprawny format `com.imienazwisko.appname` |
| ⬜ | `IDEA.md` zawiera `SUPABASE_APP_SPECIFIC_TABLE_PREFIX` |
| ⬜ | `SUPABASE_APP_SPECIFIC_TABLE_PREFIX` jest równy ostatniemu segmentowi `APP_BUNDLE_ID` z dopisanym `_` |
| ⬜ | `IDEA.md` opisuje co aplikacja robi |
| ⬜ | `IDEA.md` opisuje wartość dla użytkownika |
| ⬜ | `IDEA.md` opisuje niszę aplikacji |
| ⬜ | `IDEA.md` zawiera krótki opis aplikacji |
| ⬜ | `IDEA.md` zawiera długi opis aplikacji |
| ⬜ | `IDEA.md` zawiera ustalenia z rozmowy z userem |
| ⬜ | `IDEA.md` zawiera opis pierwszego głównego ekranu po onboardingu |
| ⬜ | `IDEA.md` zawiera listę pozostałych ekranów |
| ⬜ | `IDEA.md` rozróżnia funkcje free i pro oraz proponuje podstawowe limity |
| ⬜ | `IDEA.md` zawiera plan wersji `0.0.1`, `0.0.2`, `0.0.3` |

## Krok 4. Zweryfikuj `IDEA.md` z userem

| Status | Item |
| --- | --- |
| ⬜ | User został poproszony o weryfikację `IDEA.md` |
| ⬜ | Jeśli user zgłosił uwagi do `IDEA.md`: zostały uwzględnione |
| ⬜ | User ostatecznie zatwierdził `IDEA.md` |

## Krok 5. Ustaw identyfikatory aplikacji

| Status | Item |
| --- | --- |
| ⬜ | `APP_BUNDLE_ID` został ustawiony w aplikacji |
| ⬜ | `APP_DISPLAY_NAME` został ustawiony w aplikacji |
| ⬜ | Zmiany wykonano zgodnie z `docs/tasks/UPDATE_APP_IDENTIFIERS.md` |
| ⬜ | Zmiany wykonano zgodnie z `docs/tasks/UPDATE_APP_DISPLAY_NAME.md` |

## Krok 6. Zaktualizuj `AGENTS.md`

| Status | Item |
| --- | --- |
| ⬜ | Placeholder `<app_prefix>` został podmieniony w `AGENTS.md` |
| ⬜ | Użyty prefix jest zgodny z ustalonym `SUPABASE_APP_SPECIFIC_TABLE_PREFIX` |

## Krok 7. Wykonaj commity

| Status | Item |
| --- | --- |
| ⬜ | `IDEA.md` został zapisany w osobnym commicie |
| ⬜ | Pozostałe zmiany zostały zapisane w oddzielnym commicie lub commitach |

## Krok 8. Wyślij dane aplikacji do platformy

| Status | Item |
| --- | --- |
| ⬜ | Jeśli `PLATFORM_API_KEY` był dostępny: wykonano request dodający aplikację do konta usera z kompletem wymaganych pól |
| ⬜ | Jeśli request dodający aplikację zakończył się sukcesem i zwrócił `id`: zapisano je do `.env` jako `APP_PLATFORM_ID=` |

## Końcowe potwierdzenie

| Status | Item |
| --- | --- |
| ⬜ | Stan faktyczny plików i wykonanych działań został sprawdzony |
| ⬜ | Checklista została zaktualizowana i wszystkie możliwe pozycje mają status `done` zgodny ze stanem rzeczywistym tego projektu |
