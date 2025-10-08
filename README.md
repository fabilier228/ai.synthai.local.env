# SynthAI Platform - Local Development Environment

## 🚀 Opis projektu

SynthAI Platform to nowoczesna aplikacja mikrousługowa składająca się z:

- **Frontend** (React/TypeScript) - interfejs użytkownika
- **Auth Service** (Node.js/Express) - serwis autoryzacji z integracją Keycloak
- **Logic Service** (Spring Boot/Java) - logika biznesowa aplikacji
- **PostgreSQL** - baza danych
- **Keycloak** - zarządzanie tożsamością i dostępem (IAM)
- **Redis** - cache i sesje
- **Nginx** - reverse proxy
- **Prometheus/Grafana** - monitoring (opcjonalnie)

## 📋 Wymagania

- **Docker** >= 20.10
- **Docker Compose** >= 2.0
- **Node.js** >= 18.0 (dla development lokalnego)
- **Java** >= 21 (dla development lokalnego)
- **Maven** >= 3.9 (dla development lokalnego)

## ⚡ Szybki start

### 1. Klonowanie i przygotowanie

```bash
# Przejdź do katalogu głównego projektu
cd projekt_zaspolowy

# Skopiuj plik konfiguracji środowiska
cd ai.synthai.local.env
cp .env.example .env

# Edytuj plik .env jeśli potrzeba (opcjonalnie)
# nano .env
```

### 2. Uruchomienie całej platformy

```bash
# Uruchom wszystkie serwisy
docker-compose up -d

# Lub z logami w czasie rzeczywistym
docker-compose up
```

### 3. Sprawdzenie statusu

```bash
# Status wszystkich kontenerów
docker-compose ps

# Logi konkretnego serwisu
docker-compose logs -f [nazwa-serwisu]
```

## 🌐 Dostęp do aplikacji

Po uruchomieniu, aplikacja będzie dostępna pod adresami:

| Serwis          | URL                              | Opis                      |
| --------------- | -------------------------------- | ------------------------- |
| **Frontend**    | http://localhost:3000            | Główna aplikacja React    |
| **Nginx Proxy** | http://localhost                 | Główny punkt wejścia      |
| **Auth API**    | http://localhost:3001            | API autoryzacji           |
| **Logic API**   | http://localhost:8081            | API logiki biznesowej     |
| **Keycloak**    | http://localhost:8080            | Panel administracyjny IAM |
| **H2 Console**  | http://localhost:8081/h2-console | Konsola bazy danych (dev) |
| **Prometheus**  | http://localhost:9090            | Metryki systemu           |
| **Grafana**     | http://localhost:3001            | Dashboard monitoringu     |

## 🔐 Domyślne dane logowania

### Keycloak Admin

- **URL**: http://localhost:8080
- **Username**: `admin`
- **Password**: `admin123`

### Aplikacja (testowi użytkownicy)

- **Admin**: `admin` / `admin123`
- **User**: `testuser` / `test123`

### Grafana

- **Username**: `admin`
- **Password**: `admin`

## 🏗️ Struktura projektu

```
projekt_zaspolowy/
├── ai.synthai.local.env/           # Środowisko Docker
│   ├── docker-compose.yml          # Główny plik orchestracji
│   ├── .env                         # Zmienne środowiskowe
│   ├── database/                    # Skrypty inicjalizacji bazy
│   ├── nginx/                       # Konfiguracja reverse proxy
│   ├── keycloak/                    # Konfiguracja Keycloak
│   └── monitoring/                  # Konfiguracja monitoringu
├── ai.synthai.src.authorization.backend/  # Serwis autoryzacji (Node.js)
├── ai.synthai.src.logic.backend/          # Serwis logiki (Spring Boot)
└── ai.synthai.src.frontend/               # Aplikacja frontend (React)
```

## 🛠️ Development

### Praca z poszczególnymi serwisami

#### Auth Service (Node.js)

```bash
cd ai.synthai.src.authorization.backend
npm install
npm run dev
```

#### Logic Service (Spring Boot)

```bash
cd ai.synthai.src.logic.backend
./mvnw spring-boot:run
```

#### Frontend (React)

```bash
cd ai.synthai.src.frontend
npm install
npm start
```

### Hot reload w Docker

Wszystkie serwisy są skonfigurowane z hot reload podczas development:

```bash
# Restart konkretnego serwisu po zmianach
docker-compose restart [nazwa-serwisu]

# Przebudowanie obrazu po zmianach w Dockerfile
docker-compose up --build [nazwa-serwisu]
```

## 📊 Monitoring i logi

### Sprawdzanie logów

```bash
# Wszystkie logi
docker-compose logs -f

# Logi konkretnego serwisu
docker-compose logs -f auth-service
docker-compose logs -f logic-service
docker-compose logs -f frontend

# Logi ostatnie 100 linii
docker-compose logs --tail=100 [serwis]
```

### Health checks

```bash
# Status wszystkich serwisów
curl http://localhost/health

# Auth service health
curl http://localhost:3001/health

# Logic service health
curl http://localhost:8081/actuator/health
```

## 🔧 Konfiguracja

### Zmienne środowiskowe

Główne zmienne konfiguracyjne znajdują się w pliku `.env`. Najważniejsze:

```env
# Hasła (ZMIEŃ W PRODUKCJI!)
POSTGRES_PASSWORD=postgres123
KEYCLOAK_ADMIN_PASSWORD=admin123

# Porty serwisów
FRONTEND_PORT=3000
AUTH_SERVICE_PORT=3001
LOGIC_SERVICE_PORT=8081

# Ustawienia CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:80
```

### Profile Spring Boot

Logic Service używa różnych profili:

- `default` - development z H2
- `docker` - production z PostgreSQL

## 🐛 Troubleshooting

### Częste problemy

1. **Port już używany**

   ```bash
   # Sprawdź co używa portu
   netstat -tulpn | grep :8080

   # Zmień port w .env lub zatrzymaj konfliktujący proces
   ```

2. **Brak połączenia z bazą danych**

   ```bash
   # Sprawdź status PostgreSQL
   docker-compose logs postgres

   # Restartuj bazę danych
   docker-compose restart postgres
   ```

3. **Problemy z Keycloak**

   ```bash
   # Wyczyść dane Keycloak i uruchom ponownie
   docker-compose down -v
   docker-compose up postgres
   # Poczekaj 30 sekund
   docker-compose up keycloak
   ```

4. **Frontend nie łączy się z API**
   - Sprawdź ustawienia CORS w `.env`
   - Sprawdź konfigurację proxy w `package.json`

### Czyszczenie środowiska

```bash
# Zatrzymaj wszystkie serwisy
docker-compose down

# Usuń wszystkie dane (UWAGA: usunie bazy danych!)
docker-compose down -v

# Usuń także obrazy
docker-compose down -v --rmi all

# Pełne czyszczenie Docker
docker system prune -a
```

## 🚀 Deployment na produkcję

### Przygotowanie do produkcji

1. Zmień hasła w `.env`:

   ```env
   NODE_ENV=production
   POSTGRES_PASSWORD=twoje-bezpieczne-haslo
   KEYCLOAK_ADMIN_PASSWORD=twoje-bezpieczne-haslo-admin
   ```

2. Skonfiguruj SSL/HTTPS w nginx

3. Użyj zewnętrznych baz danych dla większej wydajności

4. Skonfiguruj backup bazy danych

### Docker Registry

```bash
# Zbuduj obrazy dla produkcji
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build

# Wypchnij do registry
docker-compose push
```

## 📚 Dokumentacja API

- **Auth Service API**: http://localhost:3001/api (gdy uruchomiony)
- **Logic Service API**: http://localhost:8081/api/v1 (gdy uruchomiony)
- **Swagger/OpenAPI**: Będzie dodane w przyszłych wersjach

## 🤝 Rozwój

### Dodawanie nowych funkcji

1. Stwórz nową gałąź: `git checkout -b feature/nazwa-funkcji`
2. Implementuj zmiany
3. Testuj lokalnie: `docker-compose up --build`
4. Commit i push
5. Stwórz Pull Request

### Testowanie

```bash
# Testy Auth Service
cd ai.synthai.src.authorization.backend
npm test

# Testy Logic Service
cd ai.synthai.src.logic.backend
./mvnw test

# Testy Frontend
cd ai.synthai.src.frontend
npm test
```

## 📞 Wsparcie

W przypadku problemów:

1. Sprawdź sekcję Troubleshooting
2. Przejrzyj logi: `docker-compose logs`
3. Sprawdź Issues na GitHub
4. Skontaktuj się z zespołem

---

**Miłego kodowania! 🎉**
# ai.synthai.local.env
