# Pomysł na Aplikację: MobiScan

Aplikacja mobilna do szybkiego skanowania dokumentów, ich kategoryzacji oraz wysyłania plików w formacie PDF. Skupiona na prostocie, wydajności i całkowitym braku reklam.

- **Autor:** Anatol Karamanyan
- **Bundle ID:** `com.anatolkaramanyan.mobiscan`
- **Supabase Table Prefix:** `mobiscan_`

## Co ta aplikacja robi?
Aplikacja pozwala użytkownikowi w kilku krokach zamienić fizyczny dokument na cyfrowy plik PDF. Użytkownik otwiera aplikację, klika przycisk skanowania, robi zdjęcie dokumentu (z automatycznym wykrywaniem krawędzi) i zapisuje go w lokalnej bazie. Zapisany dokument można podejrzeć, zmienić jego nazwę i udostępnić jako PDF (np. mailem lub komunikatorem).

## Wartość dla użytkownika
- **Szybkość:** Brak zbędnych ekranów i reklam pozwala na skanowanie dokumentów "w biegu".
- **Porządek:** Dokumenty są przechowywane w jednym miejscu, łatwo dostępne bez szukania w galerii zdjęć.
- **Bezpieczeństwo i Higiena:** Brak reklam zapewnia czyste i profesjonalne doświadczenie.

## Dlaczego użytkownik miałby ją ściągnąć i wracać?
Użytkownicy szukają narzędzi, które nie bombardują ich reklamami w krytycznych momentach (np. gdy muszą szybko wysłać podpisany formularz). MobiScan stawia na "utility first" - aplikacja ma być niezawodnym narzędziem, które zawsze działa tak samo dobrze.

## Nisza
Osoby pracujące biurowo, studenci oraz każdy, kto potrzebuje sporadycznie lub regularnie zamieniać papierowe dokumenty na PDF-y, a frustrują go obecne, przeładowane funkcjami i reklamami rozwiązania.

## Opis aplikacji
- **Krótki opis:** Szybki skaner dokumentów do PDF bez reklam.
- **Długi opis:** MobiScan to proste i potężne narzędzie do skanowania dokumentów bezpośrednio z poziomu Twojego telefonu. Zapomnij o stacjonarnych skanerach. Wykrywaj krawędzie, koryguj perspektywę i twórz czyste pliki PDF w kilka sekund. Wszystko to w minimalistycznym wydaniu, bez przeszkadzających reklam i ukrytych subskrypcji za podstawowe funkcje.

## Ustalenia z rozmowy
> "Aplikacja do skanowwania dokumentów ich pszychowywania oraz wysłania w PDF. Szybka prosta i bez reklam."

## Ekrany aplikacji (MVP)

### Home (Główny ekran)
Lista wszystkich zapisanych skanów w formie siatki lub listy. Wyraźny "pływający" przycisk (FAB) do rozpoczęcia nowego skanowania. Możliwość wyszukiwania skanów po nazwie.

### Camera / Scanner
Widok kamery, który automatycznie próbuje wykryć prostokąt dokumentu. Po zrobieniu zdjęcia użytkownik może ręcznie dopasować rogi.

### Scan Details (Szczegóły)
Podgląd zeskanowanych stron dokumentu (możliwość dodania kolejnych stron). Edycja nazwy dokumentu. Przycisk "Generuj i wyślij PDF".

## Model biznesowy
Aplikacja MobiScan jest w pełni darmowa dla wszystkich użytkowników. Nie zawiera reklam ani płatnych subskrypcji. Wszystkie funkcje skanowania, edycji i eksportu do PDF są dostępne bez limitów.

## Mapa drogowa (Roadmap)
- **0.0.1:** Podstawowe skanowanie jednej strony, podgląd i wysyłka PDF.
- **0.0.2:** Skanowanie wielostronicowe, edycja nazwy i usuwanie skanów.
- **0.0.3:** Lepsze filtry obrazu (kontrast, jasność) i integracja z Google Drive.
