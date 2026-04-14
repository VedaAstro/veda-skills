# Component Registry — veda-presentation

> Реальные компоненты, проверены в components/base/ и components/application/.
> Добавить компонент: `npx untitledui@latest add <name>`

## Base Components

| Компонент | Импорт | Props ключевые |
|-----------|--------|----------------|
| Button | `@/components/base/buttons/button` | `size="sm\|md\|lg\|xl"` `color="primary\|secondary\|tertiary\|link-gray\|link-color\|primary-destructive\|secondary-destructive\|tertiary-destructive\|link-destructive"` `iconLeading iconTrailing isDisabled isLoading showTextWhileLoading href` |
| Input | `@/components/base/input/input` | `size="sm\|md"` `label hint placeholder icon isRequired isDisabled isInvalid tooltip shortcut hideRequiredIndicator` |
| InputBase | `@/components/base/input/input` | Только поле без label/hint. Те же props кроме label/hint |
| InputGroup | `@/components/base/input/input-group` | Обёртка с ведущим/завершающим аддоном |
| Select | `@/components/base/select/select` | `size="sm\|md"` `label hint placeholder items isRequired isDisabled placeholderIcon` |
| Select.Item | `@/components/base/select/select` | `id supportingText icon avatarUrl isDisabled` |
| Select.ComboBox | `@/components/base/select/select` | Как Select + поиск |
| MultiSelect | `@/components/base/select/multi-select` | Multiple selection |
| Textarea | `@/components/base/textarea/textarea` | `size="sm\|md"` `label hint placeholder isRequired isDisabled isInvalid rows` |
| Checkbox | `@/components/base/checkbox/checkbox` | `size="sm\|md"` `label hint isSelected isDisabled isIndeterminate onChange` |
| RadioButtons | `@/components/base/radio-buttons/radio-buttons` | Group of radio buttons |
| Toggle | `@/components/base/toggle/toggle` | `size="sm\|md"` `label isSelected isDisabled onChange` |
| Avatar | `@/components/base/avatar/avatar` | `size="xxs\|xs\|sm\|md\|lg\|xl\|2xl"` `src alt initials placeholderIcon status="online\|offline"` `verified badge contrastBorder` |
| AvatarLabelGroup | `@/components/base/avatar/avatar-label-group` | `src title subtitle size` |
| Badge | `@/components/base/badges/badges` | `type="pill-color\|color\|modern"` `size="sm\|md\|lg"` `color="gray\|brand\|error\|warning\|success\|blue-light\|blue\|indigo\|purple\|pink\|orange\|gray-blue"` |
| BadgeWithDot | `@/components/base/badges/badges` | Те же props что Badge |
| BadgeWithIcon | `@/components/base/badges/badges` | `+ iconLeading iconTrailing` |
| BadgeWithButton | `@/components/base/badges/badges` | `+ onButtonClick buttonLabel` |
| BadgeWithFlag | `@/components/base/badges/badges` | `+ flag` (ISO 2-буквенный код) |
| BadgeWithImage | `@/components/base/badges/badges` | `+ imgSrc` |
| BadgeIcon | `@/components/base/badges/badges` | `icon` (только иконка без текста) |
| Tooltip | `@/components/base/tooltip/tooltip` | `title placement` |
| TooltipTrigger | `@/components/base/tooltip/tooltip` | Обёртка триггера |
| Dropdown | `@/components/base/dropdown/dropdown` | Базовое меню с действиями |
| DropdownAccountBreadcrumb | `@/components/base/dropdown/dropdown-account-breadcrumb` | Аккаунт-хлебные крошки |
| DropdownAccountButton | `@/components/base/dropdown/dropdown-account-button` | Кнопка аккаунта с меню |
| DropdownAccountCard (xs/sm/md) | `@/components/base/dropdown/dropdown-account-card-{xs,sm,md}` | Карточка аккаунта, 3 размера |
| DropdownAvatar | `@/components/base/dropdown/dropdown-avatar` | Аватар с выпадающим меню |
| DropdownButtonSimple | `@/components/base/dropdown/dropdown-button-simple` | Простая кнопка-дропдаун |
| DropdownButtonAdvanced | `@/components/base/dropdown/dropdown-button-advanced` | Расширенная кнопка-дропдаун |
| DropdownButtonLink | `@/components/base/dropdown/dropdown-button-link` | Ссылка-дропдаун |
| DropdownIconSimple | `@/components/base/dropdown/dropdown-icon-simple` | Иконка-дропдаун простая |
| DropdownIconAdvanced | `@/components/base/dropdown/dropdown-icon-advanced` | Иконка-дропдаун расширенная |
| DropdownIntegration | `@/components/base/dropdown/dropdown-integration` | Дропдаун для интеграций |
| DropdownSearchSimple | `@/components/base/dropdown/dropdown-search-simple` | Дропдаун с поиском простой |
| DropdownSearchAdvanced | `@/components/base/dropdown/dropdown-search-advanced` | Дропдаун с поиском расширенный |
| SelectShared | `@/components/base/select/select-shared` | Общие примитивы Select/ComboBox |
| TagSelect | `@/components/base/tag-select/tag-select` | Multi-select с тегами |
| ButtonGroup | `@/components/base/button-group/button-group` | Группа кнопок |
| DatePicker | `@/components/base/date-picker/date-picker` | `label isRequired isDisabled isInvalid` |
| DateRangePicker | `@/components/base/date-picker/date-range-picker` | `label` |
| Calendar | `@/components/base/calendar/calendar` | Встроенный календарь |
| FileUpload | `@/components/base/file-upload/file-upload-base` | Drag & drop загрузка файлов |
| FileUploadTrigger | `@/components/base/file-upload-trigger/file-upload-trigger` | Кнопка-триггер |
| PinInput | `@/components/base/pin-input/pin-input` | OTP/PIN ввод |
| Slider | `@/components/base/slider/slider` | `min max step` |
| ProgressIndicators | `@/components/base/progress-indicators/progress-indicators` | `value` |
| ProgressCircles | `@/components/base/progress-indicators/progress-circles` | `value` |
| LoadingIndicator | `@/components/base/loading-indicator/loading-indicator` | Спиннер |
| Toast | `@/components/base/toast/toast` | Системные уведомления (Sonner) |
| Breadcrumbs | `@/components/base/breadcrumbs/breadcrumbs` | `items` |
| Carousel | `@/components/base/carousel/carousel-base` | Слайдер контента |
| EmptyState | `@/components/base/empty-state/empty-state` | `icon title description action` |
| SlideoutMenu | `@/components/base/slideout-menus/slideout-menu` | Боковая панель |
| Toolbar | `@/components/base/toolbar/toolbar-sm` | Панель инструментов |
| Form | `@/components/base/form/form` | `@/components/base/form/hook-form` |
| AppNavigation | `@/components/base/app-navigation/sidebar-navigation-base` | Sidebar nav |
| HeaderNavigation | `@/components/base/app-navigation/header-navigation` | Top nav |

## Application Components

| Компонент | Импорт | Props ключевые |
|-----------|--------|----------------|
| FilterBar | `@/components/application/filter-bar/filter-bar` | Панель фильтров (v8) |
| FilterDropdownMenu | `@/components/application/filter-dropdown-menu/filter-dropdown-menu` | Dropdown в составе FilterBar (v8) |
| Modal / ModalOverlay | `@/components/application/modals/modal` | React Aria Dialog. `DialogTrigger Modal ModalOverlay Dialog` |
| Tabs | `@/components/application/tabs/tabs` | `type="button-brand\|button-gray\|button-border\|button-minimal\|underline"` `size="sm\|md"` `orientation="horizontal\|vertical"` |
| Table | `@/components/application/table/table` | Таблица с сортировкой |
| Pagination | `@/components/application/pagination/pagination` | `current total pageSize onChange` |
| Charts | `@/components/application/charts/charts-base` | Базовые графики |
| Metrics | `@/components/application/metrics/metrics` | Карточки метрик |

## Foundations

| Компонент | Импорт |
|-----------|--------|
| FeaturedIcon | `@/components/foundations/featured-icon/featured-icon` |

> `size="sm\|md\|lg\|xl"` `color="brand\|gray\|error\|warning\|success"` `theme="light\|gradient\|dark\|modern\|modern-neue\|outline"`

## Иконки

| Проект | Пакет | Стили |
|--------|-------|-------|
| veda-presentation | `@untitledui-pro/icons` | Line / Duocolor / Duotone / Solid |
| остальные проекты | `@untitledui/icons` | Line only |

```tsx
// Line
import { Home01, Settings01 } from "@untitledui-pro/icons";
// Solid
import { Home01 } from "@untitledui-pro/icons/solid";
// Duotone
import { Home01 } from "@untitledui-pro/icons/duotone";

// Использование
<Button iconLeading={ChevronDown}>Options</Button>
<Home01 className="size-5 text-fg-secondary" />
// Если как JSX-элемент
<Button iconLeading={<ChevronDown data-icon className="size-4" />}>Options</Button>
```

Размеры: `size-4` (16px) / `size-5` (20px) / `size-6` (24px)

## Другие проекты

veda-chat, bot-admin-ui, app-myveda = подмножество veda-presentation.
Если компонента нет в проекте: `npx untitledui@latest add <component-name>`
Полный каталог: MCP `list_components` или https://www.untitledui.com/react/components
