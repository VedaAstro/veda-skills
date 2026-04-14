# Page Layouts — Шаблоны страниц

> Скелеты для типовых страниц Veda. Компоненты из `components/`, семантические токены.
> Все импорты — из Untitled UI (`@/components/base/...`, `@/components/application/...`).

---

## 1. CRM-список (клиенты, сделки, сессии)

```tsx
'use client';
import { useRequireAuth, useAuthFetch } from '@/app/context/AuthContext';
import { AppNavigation } from "@/components/base/app-navigation/sidebar-navigation-base";
import { Input } from "@/components/base/input/input";
import { Button } from "@/components/base/buttons/button";
import { Badge } from "@/components/base/badges/badges";
import { Table } from "@/components/application/table/table";
import { Pagination } from "@/components/application/pagination/pagination";
import { Plus, FilterLines } from "@untitledui-pro/icons";

export default function ListPage() {
  useRequireAuth('/login');

  return (
    <div className="p-5 space-y-4 bg-primary min-h-screen">

      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <h1 className="text-xl font-semibold text-primary">Клиенты</h1>
          <Badge type="pill-color" color="gray" size="sm">{count}</Badge>
        </div>
        <Button color="primary" size="sm" iconLeading={Plus}>Добавить</Button>
      </div>

      {/* Filters */}
      <div className="flex items-center gap-2">
        <Input
          size="sm"
          placeholder="Поиск..."
          className="max-w-[280px]"
        />
        <Button color="secondary" size="sm" iconLeading={FilterLines}>Фильтр</Button>
      </div>

      {/* Table */}
      <div className="bg-primary rounded-xl border border-primary overflow-hidden">
        <Table />
      </div>

      {/* Pagination */}
      <Pagination current={page} total={total} pageSize={20} onChange={setPage} />

    </div>
  );
}
```

---

## 2. Dashboard (KPI + графики)

```tsx
import { Metrics } from "@/components/application/metrics/metrics";
import { Charts } from "@/components/application/charts/charts-base";
import { Tabs } from "@/components/application/tabs/tabs";
import { Button } from "@/components/base/buttons/button";
import { Calendar } from "@untitledui-pro/icons";

export default function DashboardPage() {
  useRequireAuth('/login');

  return (
    <div className="p-5 space-y-5 bg-primary min-h-screen">

      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-semibold text-primary">Дашборд</h1>
        <Button color="secondary" size="sm" iconLeading={Calendar}>Эта неделя</Button>
      </div>

      {/* KPI row */}
      <div className="grid grid-cols-4 gap-3">
        <Metrics />
        <Metrics />
        <Metrics />
        <Metrics />
      </div>

      {/* Charts grid */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-primary rounded-xl border border-primary p-5">
          <h2 className="text-sm font-semibold text-primary mb-4">Воронка</h2>
          <Charts />
        </div>
        <div className="bg-primary rounded-xl border border-primary overflow-hidden">
          <div className="px-5 py-3 border-b border-primary">
            <h2 className="text-sm font-semibold text-primary">Топ менеджеры</h2>
          </div>
          <Table />
        </div>
      </div>

    </div>
  );
}
```

---

## 3. Рабочая станция (split panels)

```tsx
import { Panel, PanelGroup, PanelResizeHandle } from 'react-resizable-panels';
import { Input } from "@/components/base/input/input";
import { Avatar } from "@/components/base/avatar/avatar";

export default function WorkstationPage() {
  useRequireAuth('/login');

  return (
    <PanelGroup direction="horizontal" className="h-[calc(100vh-48px)]">

      {/* Left panel — список */}
      <Panel defaultSize={30} minSize={20} maxSize={40}>
        <div className="h-full flex flex-col bg-primary border-r border-primary">
          <div className="px-4 py-3 border-b border-primary">
            <h2 className="text-sm font-semibold text-primary">Сессии</h2>
          </div>
          <div className="px-3 py-2">
            <Input size="sm" placeholder="Поиск..." />
          </div>
          <div className="flex-1 overflow-y-auto px-2 py-1 space-y-1">
            {sessions.map(s => (
              <button
                key={s.id}
                className={`w-full text-left p-3 rounded-lg border transition-colors ${
                  activeId === s.id
                    ? 'bg-brand-primary border-brand'
                    : 'bg-primary border-primary hover:bg-secondary'
                }`}
              >
                <div className="text-sm font-medium text-primary">{s.clientName}</div>
                <div className="text-xs text-tertiary mt-0.5">{s.date}</div>
              </button>
            ))}
          </div>
        </div>
      </Panel>

      <PanelResizeHandle className="w-px bg-primary hover:bg-brand transition-colors" />

      {/* Right panel — контент */}
      <Panel defaultSize={70}>
        <div className="h-full overflow-y-auto p-5 bg-secondary">
          {/* Контент сессии */}
        </div>
      </Panel>

    </PanelGroup>
  );
}
```

---

## 4. Настройки / Форма

```tsx
import { Input } from "@/components/base/input/input";
import { Select } from "@/components/base/select/select";
import { Toggle } from "@/components/base/toggle/toggle";
import { Button } from "@/components/base/buttons/button";

export default function SettingsPage() {
  useRequireAuth('/login');

  return (
    <div className="p-5 max-w-[640px] bg-primary min-h-screen">

      <h1 className="text-xl font-semibold text-primary mb-5">Настройки</h1>

      {/* Section */}
      <div className="bg-primary rounded-xl border border-primary p-5 mb-4 space-y-4">
        <h2 className="text-sm font-semibold text-primary">Основное</h2>
        <Input label="Имя" placeholder="Введите имя" size="md" />
        <Input label="Email" placeholder="email@example.com" size="md" />
        <Select label="Роль" items={roles} size="md" />
      </div>

      {/* Notifications section */}
      <div className="bg-primary rounded-xl border border-primary p-5 mb-4 space-y-4">
        <h2 className="text-sm font-semibold text-primary">Уведомления</h2>
        <Toggle label="Email-уведомления" isSelected={emailNotif} onChange={setEmailNotif} />
        <Toggle label="Push в браузере" isSelected={pushNotif} onChange={setPushNotif} />
      </div>

      <div className="flex justify-end gap-3">
        <Button color="secondary" size="md">Отмена</Button>
        <Button color="primary" size="md">Сохранить</Button>
      </div>

    </div>
  );
}
```

---

## 5. Detail / Profile (с табами)

```tsx
import { Tabs } from "@/components/application/tabs/tabs";
import { Avatar } from "@/components/base/avatar/avatar";
import { Button } from "@/components/base/buttons/button";
import { Edit01, Phone01 } from "@untitledui-pro/icons";

export default function DetailPage() {
  return (
    <div className="bg-secondary min-h-screen">

      {/* Header card */}
      <div className="bg-primary border-b border-primary px-5 py-4">
        <div className="flex items-center gap-4">
          <Avatar size="lg" initials="ИС" src={avatarUrl} />
          <div>
            <h1 className="text-base font-semibold text-primary">Иван Сидоров</h1>
            <p className="text-sm text-tertiary mt-0.5">+7 999 123-45-67</p>
          </div>
          <div className="ml-auto flex items-center gap-2">
            <Button color="secondary" size="sm" iconLeading={Phone01}>Позвонить</Button>
            <Button color="primary" size="sm" iconLeading={Edit01}>Редактировать</Button>
          </div>
        </div>

        {/* Tabs */}
        <div className="mt-4 -mb-px">
          <Tabs type="underline" size="sm">
            {/* Tab items */}
          </Tabs>
        </div>
      </div>

      {/* Tab content */}
      <div className="p-5">
        <div className="bg-primary rounded-xl border border-primary p-5">
          {/* Контент таба */}
        </div>
      </div>

    </div>
  );
}
```

---

## Структурные правила

```
СТРАНИЦА:
  bg-secondary (фон) → p-5 → space-y-4/5 (gap между блоками)

КАРТОЧКИ:
  bg-primary rounded-xl border border-primary p-5
  (overflow-hidden для таблиц)

ЗАГОЛОВОК + ДЕЙСТВИЕ:
  flex items-center justify-between
  h1 text-xl font-semibold text-primary

KPI-ряд:
  grid grid-cols-{3|4} gap-3

SPLIT-LAYOUT:
  PanelGroup + Panel (react-resizable-panels)
  Левая = 30% min 20% max 40%
  PanelResizeHandle = w-px bg-primary

ИКОНКИ В КНОПКАХ:
  iconLeading={IconComponent} (FC, без JSX)
```
