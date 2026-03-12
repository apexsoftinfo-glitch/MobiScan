## Cel

Masz przeprowadzić usera przez wybór i doprecyzowanie pomysłu na jego własną aplikację mobilną, a następnie doprowadzić checklistę tego kroku do stanu, w którym wszystkie możliwe pozycje mają status `done`.

## Zasada pracy z checklistą

Nie aktualizujesz tego pliku. Tutaj jesteśmy w trybie read-only. 
Do zapisywania postępu tego taska używasz checklisty dostępnej tutaj: `docs/steps/checklists/02_start_checklist.md`.

- Na starcie otwórz checklistę i się z nią zapoznaj.
- Realizuj kroki dokładnie w kolejności `Krok 1 -> Krok 2 -> Krok 3 ...`.
- Nie wykonuj kilku kroków naraz.
- Po każdym kroku zatrzymaj się i sprawdź, czy wolno przejść dalej.
- Najpierw sprawdź stan faktyczny plików, `.env`, odpowiedzi usera i ewentualnych endpointów, a dopiero potem uzupełniaj checklistę.
- Nie zakładaj, że wszystko jest `pending`.
- Nie zakładaj, że stan checklisty na 100% pokrywa się ze stanem faktycznym.
- Jeśli coś już istnieje i jest poprawne, oznacz to jako `done`.
- Jeśli czekasz na ruch usera, oznacz to jako `waiting_for_user`.
- Po każdym wykonanym kroku zaktualizuj checklistę.
- Przy każdej aktualizacji checklisty zmień emoji statusu w pierwszej kolumnie.
- Używaj spójnie tylko tych statusów emoji: `⬜`, `⏳`, `✅`.
- Dla kroków konwersacyjnych aktualizuj checklistę na podstawie wyniku rozmowy, a nie samego faktu zadania pytania.
- Możesz dopisywać nowe zadania do checklisty.
- Nie zamykaj tego kroku jako ukończonego, dopóki wszystkie możliwe pozycje checklisty nie mają statusu `done`.

Twoim zadaniem jest pomóc w ustaleniu pomysłu na aplikację mobilną ios / android za pomocą Flutter'a.

Masz 8 kroków do wykonania. Step by step. Nie śpiesz się z ich wykonaniem. Powolutku.

Bądź przyjaznym asystentem, nie używaj marketingowego żargonu. Zakładaj, że twórca aplikacji jest osobą początkującą, nietechniczną. Prowadź rozmowę prostym językiem, ale konkretnie.

1. Sprawdź czy istnieje Klucz Do Platformy w .env. Jeżeli nie ma, powiedz userowi, żeby go wziął z platformy i wkleił do .env do pola `PLATFORM_API_KEY=`.

Poczekaj, aż ci na to odpowie, że wstawił klucz, lub nie. 

- Jeżeli podał, pobierz jego imię i nazwisko z endpointu GET
curl -s https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
  -H "X-API-Key: __PLATFORM_API_KEY__"
- Jeżeli nie podał lub endpoint nie działa, zapytaj go jak ma na imię i nazwisko, bo będzie nam to potrzebne do określenia __APP_BUNDLE_ID__ tej aplikacji.

Poczekaj na odpowiedź. Masz to? Dopiero teraz przejdź do drugiego kroku:

Po zakończeniu kroku 1 zaktualizuj checklistę.

2. Zapytaj go czy ma pomysł na aplikację czy nie.

Jak tak to niech o niej opowie i ją zweryfikuj czy ma sens. Jak nie to okej - wypytaj go o jego zainteresowania, pasje, w czym czuje się mocny i coś zasugeruj. Może ma aplikacje z których korzysta i chciałby zrobić swoją na własnych zasadach. Może do czegoś używa Excela / Google Sheets? To jest zawsze dobry transfer na aplikację mobilną.

NIE ZASYPUJ GO WIĘCEJ NIŻ JEDNYM PYTANIEM NA RAZ. Na spokojnie. Daj mu czas na odpowiedź.

Upewnij się, że
- jest to prosta aplikacja. Że **robi jedną rzecz, ale dobrze**, a nie 10 rzeczy średnio / słabo. Musi być intuicyjna. Rozbuduje się ją później update'ami po pierwszym release'ie. Hamuj użytkownika jeżeli za bardzo wybiega w przyszłość. Celujemy w mega proste MVP.
- upewnij się, że jest wykonalna, że nie trzeba podpisywać jakichś umów z firmami zewnętrznymi czy nie narusza praw autorskich.
- oceń stopień trudności wykonania. jeżeli zaproponujesz mu kilka pomysłów, to do każdego z nich wrzuć ocenę trudności wykonania w skali od 1 do 5.
- koniecznie musi być coś z czego on sam będzie chciał korzystać - przypilnij tego! rób wywiad tak długo ile trzeba, aż to będzie pewnik.
- prowadź rozmowę od użytkownika do produktu, nie od produktu do strategii. Najpierw pytaj o samego autora: jego codzienne sytuacje, potrzeby, frustracje, zainteresowania, obecne sposoby radzenia sobie i to, jak sam chciałby używać aplikacji. Nie przerzucaj na użytkownika definiowania problemu, niszy, targetu ani MVP. To Ty masz to wywnioskować z rozmowy, zaproponować i dać userowi tylko potwierdzić albo skorygować.

Zrób brainstorming, aby zebrać jak najwięcej informacji o użytkowniku, jego codziennych sytuacjach i obecnych workaroundach. Następnie zaproponuj konkretny problem, który aplikacja rozwiązuje, oraz proste MVP.
Więcej mu pomagaj niż żądaj decyzji biznesowych do podjęcia. Zwłaszcza jak odpowie, że nie ma pomysłu to po prostu spróbuj go poznać i coś do niego dopasuj.

Celem kroku drugiego jest ustalenie i zweryfikowanie konkretnego pomysłu na prostą aplikację. Ma być do wykonania na stacku Flutter + Supabase bez dodatkowych kosztów.

Sprawdź jakie aplikacje robią inni kursanci tego community i upewnij się, że ten pomysł już nie istnieje. Aplikacje muszą być różnorodne.

GET /apps/community
https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/apps/community
X-API-Key: __PLATFORM_API_KEY__

Zanim przejdziesz do kroku 3, upewnij się, że użytkownik ZATWIERDZA ten pomysł, że będzie chciał z tej aplikacji korzystać i że chce go zrealizować.

Po zakończeniu kroku 2 zaktualizuj checklistę.

3. Zapisz jak najwięcej z tych ustaleń do pliku IDEA.md w głównym katalogu projektu.

Wypełnij istniejący szkielet w `IDEA.md`.

Niech tam będzie ustalona nazwa aplikacji.

Niech będzie zapisane tam imię i nazwisko autora.

Zapisz tam __APP_BUNDLE_ID__ w formacie: com.imienazwisko.appname (wszystko z małych liter [a-z], żadnych cyf, żadnych znaków specjalnych, brak polskich znaków)

Ustal table prefix (__SUPABASE_APP_SPECIFIC_TABLE_PREFIX__) dla Supabase (ustaw jako ostatni segment `APP_BUNDLE_ID` z dopisanym `_` - przykład: `com.adamsmaka.mytodoapp` -> `mytodoapp_`).

Zapisz tam co ta aplikacja robi.

Jaką wartość daje dla usera.

Czemu jej użytkownik miałby chcieć ją ściągnąć, uruchomić, do niej wracać i z niej korzystać.

Jaką ma niszę.

Krótki, długi opis. 

Ustalenia wszelkie z rozmowy co ta aplikacja ma spełniać, najlepiej zapisz cytaty użytkownika z kroku drugiego z brainstormingu odnośnie tego jak on ją widzi.

Co jest na pierwszym ekranie gdy użytkownik ją odpala (chodzi o funkcjonalny screen, a nie welcome czy logowania. chodzi o home, gdy użytkownik przeszedł już onboarding i np powraca do aplikacji).

Uwzględnij, że w template istnieją już ekrany: Welcome, logowanie, rejestracja, Home i Profile. Nie rozpisuj ich od zera i nie dodawaj dodatkowego ekranu typu Settings, jeśli jego rola już jest pokryta przez istniejący Profile.

Rozpisz tylko ekrany specyficzne dla tego pomysłu aplikacji.

Potrzebujemy już na tym etapie wskazać, które ekrany będą dostępne w wersji free, a które, dodatkowe będą w wersji pro za paywallem. 

Zaproponuj też prosty podział limitów między free i pro, np. limit liczby elementów, zapisów, projektów, odczytów, historii albo eksportów, jeśli pasuje to do pomysłu aplikacji.

Po zakończeniu kroku 3 zaktualizuj checklistę.

4. Daj użytkownikowi do weryfikacji. Niech zapozna się z plikiem IDEA.md. Poczekaj na jego odpowiedź. Nie idź dalej dopóki go nie zatwierdzi. Niech da znać czy ma jakieś uwagi. Jak coś mu się nie podoba to popraw. Jak jest git to dopiero przejdź do kroku 5.

Po zakończeniu kroku 4 zaktualizuj checklistę.

5. Ustaw wygenerowany __APP_BUNDLE_ID__ oraz __APP_DISPLAY_NAME__ w aplikacji za pomocą instrukcji w @docs/tasks/UPDATE_APP_IDENTIFIERS.md oraz @docs/tasks/UPDATE_APP_DISPLAY_NAME.md 

Po zakończeniu kroku 5 zaktualizuj checklistę.

6. Zaktualizuj plik @AGENTS.md

Znajdź odniesienie odnośnie tabel Supabase i podmień <app_prefix> na ustalony tutaj __SUPABASE_APP_SPECIFIC_TABLE_PREFIX__

Po zakończeniu kroku 6 zaktualizuj checklistę.

7. Zacommituj plik IDEA.md oraz resztę w oddzielnych commitach.

Po zakończeniu kroku 7 zaktualizuj checklistę.

8. Jeżeli dostarczył Klucz Do Platformy X-API-Key dodaj następujące dane o aplikacji do jego konta:

curl -s -X POST https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user/apps \
  -H "X-API-Key: __PLATFORM_API_KEY__" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "__APP_DISPLAY_NAME__",
    "description": "__APP_DESCRIPTION__",
    "idea_md": "**zawartość pliku IDEA.md**",
    "bundle_id": "__APP_BUNDLE_ID__",
    "table_prefix": "__SUPABASE_APP_SPECIFIC_TABLE_PREFIX__"
  }'

Jeżeli request zakończy się sukcesem i endpoint zwróci response w stylu `{ "id": "..." }`, zapisz ten identyfikator do `.env` jako `APP_PLATFORM_ID=...`.

Po zakończeniu kroku 8 zaktualizuj checklistę.

## Zakończenie

- Na końcu jeszcze raz otwórz:
  - `docs/steps/checklists/02_start_checklist.md`
- Sprawdź stan faktyczny plików i rezultatów rozmowy, a nie tylko wpisane statusy.
- Jeśli jakaś możliwa pozycja nadal ma status `⬜` albo `⏳`, nie zamykaj tego kroku jako zakończonego.
- Jeśli checklista albo pliki repo zostały zmienione, zrób wymagane commity.
- Gdy wszystko jest skończone, poinformuj o tym użytkownika z użyciem emojis: `🎉🎉🎉`.
