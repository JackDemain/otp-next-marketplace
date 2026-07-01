# OTP NEXT — Маркетплейс

> ⚠️ **Дисклеймер:** Это независимый концептуальный прототип. Проект **не является официальным продуктом ОТП Банка** и не аффилирован с АО «ОТП Банк» или OTP Group. Все товары, поставщики, цены и данные — вымышленные и используются исключительно в демонстрационных целях.

B2B-маркетплейс оптовой торговли с встроенными финансовыми сервисами (факторинг, BNPL).

---

## Структура репозитория

```
otp-next-marketplace/
├── docs/                          # 🌐 Витрина-лендинг (GitHub Pages)
│   ├── index.html                 # React + Babel CDN, single-page
│   └── assets/                    # Картинки, стили, скрипты
├── backend/                       # 🧠 Backend MVP0 (Spring Boot)
│   └── src/main/                  # (в разработке)
├── .github/workflows/             # ⚙️ CI/CD + autonomous ops
│   └── remote-exec.yml            # Универсальный workflow для Claude
├── .gitignore
└── README.md
```

---

## Витрина (GitHub Pages)

Раздаётся с ветки `main` из папки `/docs`.

**URL:** https://jackdemain.github.io/otp-next-marketplace/

**Стек:** React + Babel (CDN), zero build tools. Просто откройте `docs/index.html` в браузере.

Локально:
```bash
cd docs && python3 -m http.server 8000
# → http://localhost:8000
```

---

## Backend MVP0 (в разработке)

**Стек:** Java 17 + Spring Boot 3.2 + PostgreSQL 16 + Flyway + JWT.

**Скоуп демо:** каталог → карточка товара → корзина (client-side) → заказ → отмена.

Инструкция по локальному запуску и деплою появится по мере наполнения `backend/`.

---

## Автономные операции (Claude)

Репозиторий содержит `.github/workflows/remote-exec.yml` — универсальный workflow, через который Claude автономно исполняет команды на VPS без прямого SSH. См. скилл `claude-autonomous-ops`.

**Требуемые GitHub Secrets:** `DEPLOY_HOST`, `DEPLOY_SSH_KEY`, `DEPLOY_USER`.
