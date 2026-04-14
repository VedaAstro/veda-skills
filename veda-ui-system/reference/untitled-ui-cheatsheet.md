# Untitled UI — Cheatsheet

> Quick reference. Полная документация → `untitled-ui-full.md`

## Setup
```bash
npx untitledui@latest init --nextjs --color blue --overwrite  # tokens
npx untitledui@latest add <component>                          # add component
npx untitledui@latest login                                    # PRO access
```

## MCP
```
search_components("date picker")   # find
get_component("button")            # install
list_components(version="8")       # browse all
search_icons("arrow right")        # icons
```

## Critical Rules

1. **React Aria imports — prefix `Aria*`**
   ```tsx
   import { Button as AriaButton } from "react-aria-components"; // ✅
   import { Button } from "react-aria-components"; // ❌
   ```

2. **Files — kebab-case**: `date-picker.tsx` not `DatePicker.tsx`

3. **Button — onClick not onPress**:
   ```tsx
   <Button onClick={handler}>Text</Button>  // ✅
   <Button onPress={handler}>Text</Button>  // ❌ (types break)
   ```

4. **Tailwind v4 tokens — property-specific**:
   ```
   bg-brand-solid  ✅    bg-brand-600  ❌ (transparent!)
   bg-error-solid  ✅    bg-error-600  ❌
   ```
   `text-*` classes work with palette directly: `text-brand-600` ✅

5. **Modal — ModalOverlay wraps Modal wraps Dialog**:
   ```tsx
   <ModalOverlay isDismissable isOpen={open} onOpenChange={setOpen}>
     <Modal><Dialog>content</Dialog></Modal>
   </ModalOverlay>
   ```
   Escape + backdrop = automatic. No manual useEffect.

## Component Quick Ref

| Component | Import | Key props |
|-----------|--------|-----------|
| Button | `base/buttons/button` | size: sm/md/lg/xl, color: primary/secondary/tertiary |
| Input | `base/input/input` | size: sm/md, icon, error, disabled |
| Select | `base/select/select` | placeholder, items, onChange |
| Checkbox | `base/checkbox/checkbox` | isSelected, onChange, label |
| Toggle | `base/toggle/toggle` | isSelected, onChange, size |
| Badge | `base/badge/badge` | color, size, variant |
| Avatar | `base/avatar/avatar` | src, size, fallback |
| Modal | `application/modals/modal` | ModalOverlay > Modal > Dialog |
| Table | `application/tables/table` | See component-registry.md |
| Dropdown | `base/dropdown-menu/dropdown-menu` | DropdownMenu > Item |

## Semantic Tokens

### Text
`text-primary` `text-secondary` `text-tertiary` `text-quaternary` `text-placeholder`
`text-brand-600` `text-error-600` `text-success-600` `text-warning-600`

### Background
`bg-primary` `bg-secondary` `bg-tertiary` `bg-brand-solid` `bg-error-solid`

### Border
`border-primary` `border-secondary` `border-brand` `border-error`

### Icons
`fg-primary` `fg-secondary` `fg-brand-primary`

## Spacing Scale
`4/8/12/16/24/32/48/64/96` — only these values. Nothing else.

## Structure
```
components/
  base/          ← core: button, input, select, checkbox, avatar, badge
  application/   ← complex: modal, table, sidebar, command-palette
  foundations/   ← tokens, colors, typography
  marketing/     ← landing-page components
  shared-assets/ ← illustrations, icons
```
