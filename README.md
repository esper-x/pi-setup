# pi-setup

Мой переносимый конфиг для [pi](https://pi.dev): глобальные инструкции, кастомные агенты, расширения, prompt-шаблоны, MCP и настройки интерфейса.

## Установка

Склонируйте репозиторий и запустите скрипт из его корня:

### Windows PowerShell

```powershell
.\install.ps1
```

### Linux/macOS/WSL

```bash
./install.sh
```

Скрипт копирует только переносимую конфигурацию в `~/.pi/agent` и не трогает локальные credentials, сессии и прочее состояние. Путь можно переопределить переменной `PI_CODING_AGENT_DIR`.

После установки авторизуйтесь на новом компьютере отдельно:

```text
/login
```

Пакеты из `config/settings.json` устанавливаются параметром `-InstallPackages` в PowerShell или `--install-packages` в shell-скрипте:

```powershell
.\install.ps1 -InstallPackages
```

```bash
./install.sh --install-packages
```

## Как переносить изменения обратно в репозиторий

Рабочая копия конфига находится в `~/.pi/agent`, а репозиторий — это его переносимая копия. Если вы изменили что-то непосредственно в `.pi`, экспортируйте изменения перед commit:

### Windows PowerShell

```powershell
.\export.ps1
```

### Arch Linux

```bash
./export.sh
```

Экспорт обновляет только переносимые файлы и специально не забирает credentials, сессии и кеши. После этого проверьте изменения и отправьте их в Git:

```bash
git diff
git add .
git commit -m "chore: update pi config"
git push
```

На другом компьютере выполните `git pull` и снова запустите соответствующий `install`-скрипт.

## Если npm сообщает об ошибке `ENOENT` в `_cacache`

Это повреждённый локальный кеш npm, а не ошибка конфига. На Arch Linux очистите кеш и повторите установку:

```bash
npm cache clean --force
./install.sh --install-packages
```

Если ошибка повторится, проверьте доступ к registry:

```bash
npm view pi-mcp-adapter version
```

## Что намеренно не хранится в Git

`auth.json`, сессии, история запусков, кеши, состояние миссий и локальные trust-решения содержат секреты или привязаны к конкретному компьютеру.

Расширения `orca-*` безопасно работают вне Orca: они проверяют окружение и ничего не делают, если Orca не запущена.
