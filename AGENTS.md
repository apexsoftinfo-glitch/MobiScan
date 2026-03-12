# Project

To jest projekt Flutter na `iOS` i `Android`.

# Critical Rules

Używaj Clean Architecture.
Używaj `Cubit`.
Dozwolony flow: `UI -> Cubit -> Repository -> Data Source`.
`UI` zna tylko `Cubit`.
`Cubit` zna tylko `Repository`.
`Repository` zna tylko `Data Source`.
`Data Source` nie zna nic z wyższych warstw.
Nigdy nie wstrzykuj jednego `Cubit` do drugiego `Cubit`.
`Cubit` komunikują się tylko w warstwie `UI` przez `BlocListener` lub `BlocConsumer`.

Dane współdzielone między ekranami, które mogą zmienić się na innym ekranie, udostępniaj z `Repository` jako `Stream`.
`Cubit` ma subskrybować `Stream` z `Repository`.
Jeśli `Cubit` subskrybuje `Stream`, anuluj subskrypcję w `close()`.
Nie odświeżaj takich danych ręcznie po powrocie na ekran.
Jeśli ekran nie używa `Stream`, a dane mogą się zestarzeć, dodaj pull-to-refresh przez `RefreshIndicator`.

`Cubit` nie może zaczynać od stanu `loading`.
Każdy `Cubit` ma mieć początkowy stan `initial`.
Screen `Cubit` ma uruchamiać pierwsze ładowanie w konstruktorze.
`UI` nie uruchamia pierwszego ładowania. `UI` obsługuje `initial` i po błędzie pozwala na `retry()`.
`retry()` ma być bezpieczne przy wielokrotnym wywołaniu.

Nie ładuj danych przed nawigacją.
Nawigacja ma następować natychmiast.
Ekran docelowy ma ładować własne dane i pokazać stan `loading`.

`Data Source` zwraca tylko surowe dane transportowe, np. `Map<String, dynamic>` lub `List<Map<String, dynamic>>`.
`Data Source` nie mapuje danych na modele.
`Repository` mapuje surowe dane na modele.

Każdy `Cubit` musi mieć testy.
Gdy zmieniasz istniejący `Cubit`, zaktualizuj też jego testy.
Testy `Cubit` pisz przy użyciu `bloc_test`.
Mocki w testach pisz przy użyciu `mocktail`.

`SnackBar` używaj tylko dla sukcesu.
Błędy pokazuj inline w `UI`, nie w `SnackBar`.
Treść błędu renderuj w `SelectableText`.
Na ekranach i dialogach create/edit po `Save` ustaw `loading`, zablokuj interakcje i nie zamykaj widoku przed sukcesem.
Po sukcesie zamknij widok i pokaż success `SnackBar`.
Po błędzie zostaw widok otwarty i pokaż błąd inline.
Na ekranach create/edit i w formularzach edycji ostrzegaj o utracie niezapisanych zmian.
Nie dotyczy prostych ekranów logowania.
Przy każdym przechwyconym błędzie loguj surowy błąd przez `debugPrint`.
Nie pokazuj surowego błędu użytkownikowi.
`Data Source` i `Repository` nie mogą połykać błędów.
Jeśli przechwytują błąd, powinny zalogować surowy błąd, a następnie go zmapować lub rethrowować.
Nie zapisuj gotowego tekstu błędu w `Cubit`.
`Cubit` emituje tylko `errorKey`, np. `network_error`, `permission_denied`, `unknown_error`.
`UI` mapuje `errorKey` na tekst widoczny dla użytkownika.

Po każdej zmianie uruchom `flutter analyze` i napraw wszystkie błędy, warningi i info.

# Auth

Brak sesji zawsze prowadzi do `Welcome`.
`Welcome` ma tylko `Log in to existing account` albo `Continue as guest`.
`Continue as guest` używa anonymous auth w `Supabase`.
Nie ma klasycznej rejestracji z `Welcome`.
Flow wyglądający dla usera jak rejestracja jest dostępny z profilu i upgrade'uje bieżącego anonymous usera na tym samym `user.id`.
`Log in to existing account` z konta guest to account switch, nie merge.
Jeśli guest ma dane lub `Pro`, preferuj upgrade bieżącego konta zamiast switch.
Guest może kupić `Pro`.
Dla `RevenueCat` używaj `Supabase user.id` jako `appUserID` od pierwszej sesji, także dla guest.
Dane usera jak `firstName` trzymaj w `shared_users`, nie w auth metadata.
`shared_users` to tabela współdzielona między wszystkimi aplikacjami usera.
Nie modyfikuj `shared_users` bez wyraźnej potrzeby.
Minimalny kontrakt `shared_users`: `id` (1:1 z `auth.users.id`) i `first_name`.
Dane app-specific, np. onboarding lub preferencje aplikacji, trzymaj w osobnych tabelach.

# Conventions

Strukturę folderów prowadź w stylu `feature-first`.
Grupuj pliki według feature, nie według typu pliku dla całej aplikacji.
Feature nie powinien importować innego feature bezpośrednio.
Wyjątek: warstwa `app` lub `core` może łączyć feature'y.
Współdzielony kod przenoś do warstwy wspólnej.

Dla `Repository` i `Data Source` zawsze twórz abstrakcję i implementację.
Abstrakcja i implementacja mają być w tym samym pliku.
Nazewnictwo: `UserRepository` + `UserRepositoryImpl`, `AuthDataSource` + `AuthDataSourceImpl`.

Dla `freezed` używaj jawnego modyfikatora klasy: Dla data class używaj `abstract class`, a dla union i state używaj `sealed class`.
W `freezed` nie używaj `when`, `maybeWhen`, `map` ani `maybeMap`.
Dla `freezed` używaj pattern matchingu Darta.
Dla union i state `freezed` używaj publicznych wariantów, np. `Loading`, nie `_Loading`.
Po zmianach w `freezed`: `dart run build_runner build -d`.
`Cubit` i `State` trzymaj w tym samym pliku.
`State` ma używać `freezed`.

Używaj `get_it` i `injectable` do DI.
Nie twórz zależności ręcznie w `UI`.
Dla `Repository` i `Data Source` domyślnie używaj `@lazySingleton`.
Dla `Cubit` domyślnie używaj `@injectable`, nie `@lazySingleton`.
`@singleton` używaj tylko dla obiektów potrzebnych od startu aplikacji.
`Cubit` może być `@lazySingleton` tylko jeśli reprezentuje stan globalny lub sesyjny.
Per-screen `Cubit` przekazuj przez `BlocProvider(create:)`.
`Cubit` typu `@lazySingleton` przekazuj przez `BlocProvider.value(...)`.
Nigdy nie używaj `BlocProvider(create:)` z singletonowym `Cubit`.

Modele nazywaj z końcówką `Model`.
Dla plików projektu używaj relative imports.
Nie hardcoduj tekstów widocznych dla użytkownika. Dodawaj je do ARB i używaj przez `context.l10n`.
Lokalizacja należy do UI. `Cubit`, modele, `Repository` i `Data Source` nie zwracają gotowych tekstów, tylko dane i `errorKey`.
Po zmianach w ARB lub konfiguracji l10n uruchom `flutter gen-l10n`.

Nie twórz metod budujących UI, np. `Widget _buildSomething()`.
Zamiast tego wydzielaj mniejsze prywatne widgety w tym samym pliku, np. `class _WidgetName extends StatelessWidget`.
Widgety mają być małe i jednozadaniowe.
Gdy widget zbliża się do `100` linii albo obsługuje więcej niż jedną sekcję UI, podziel go.
Ekrany z polami input muszą być scrollowalne, aby klawiatura nie zasłaniała treści.
Tap poza aktywnym polem ma zamykać klawiaturę.
Dla każdego `TextField` dobieraj właściwe `keyboardType` i `textCapitalization`.
Na ekranach mobilnych respektuj `SafeArea`.

# Supabase

Ten projekt Flutter działa w jednym wspólnym projekcie Supabase razem z innymi aplikacjami.
Każda nowa tabela specyficzna dla tej aplikacji musi mieć prefix `mobiscan__`, np. `mobiscan__tasks`.
Jeśli używasz `Supabase`, logika `Supabase` ma być w `Data Source`.
Wyjątek: bootstrap aplikacji i DI mogą inicjalizować klienta `Supabase`.
Dla tabel używanych w `Stream` włącz `RLS` i utwórz odpowiednie policies.
Dla `Supabase Realtime` dodaj tabelę do publikacji `supabase_realtime`.
Jeśli `update` lub `delete` mają zwracać poprzednie dane w `Realtime`, ustaw `REPLICA IDENTITY FULL`.
Nie rób automatycznie destrukcyjnych zmian w tabeli współdzielonej, np. `drop`, kasowania danych lub niekompatybilnej zmiany schemy.

# Memory

Przy większym lub powtarzalnym problemie sprawdź `MEMORY.md` i zapisuj tam powtarzalne learnings z developmentu.
