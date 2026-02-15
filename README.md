### Note: This framework was written by me but these docs were written with the help of AI. Please let me know if you have any issues!

# Xenterface Documentation

**Xenterface** is a declarative, tag-based UI framework for Roblox that enables developers to create interactive, animated user interfaces using CollectionService tags and attributes.

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Getting Started](#getting-started)
4. [Core Concepts](#core-concepts)
5. [Animation Sequence DSL](#animation-sequence-dsl)
6. [API Reference](#api-reference)
7. [Classes Reference](#classes-reference)
8. [Services Reference](#services-reference)
9. [Configuration](#configuration)
10. [Examples](#examples)
11. [Advanced Usage](#advanced-usage)

---

## Overview

Xenterface is a UI framework that allows you to build complex, animated user interfaces through a simple tag-based approach. Instead of writing complex scripts for each UI element, you configure them using Roblox's CollectionService tags and attributes.

### Key Features

- **Tag-Based Architecture**: Use CollectionService tags to define UI behavior
- **Attribute-Driven Configuration**: Configure animations and behavior through attributes
- **Custom Animation DSL**: Powerful string-based animation syntax
- **Page/Tab System**: Built-in support for tabbed interfaces
- **Hover Effects**: Easy mouse interaction animations
- **Element Registry**: Access UI elements by ID from anywhere
- **Event System**: Custom signal implementation for reactive UIs
- **Preset System**: Reusable animation configurations

---

## Architecture

### Framework Structure

```
xenterface/
├── init.luau              # Main entry point and public API
├── Classes/               # Core class implementations
│   ├── Signal.luau        # Custom event system
│   ├── Controller.luau    # Page group controller
│   ├── Page.luau          # Page element wrapper
│   ├── Tab.luau           # Tab button wrapper
│   ├── Toggle.luau        # Base toggle behavior
│   ├── Hover.luau         # Hover interaction handler
│   └── Sequence.luau      # Animation sequence parser/player
├── Services/              # Singleton service managers
│   ├── ControllerService.luau  # Manages controllers
│   ├── ElementService.luau     # Tracks elements by ID
│   └── TagService.luau         # Generic tag listener
├── Modules/               # Utility modules
│   ├── extender.luau      # Metatable extension utility
│   └── Tagger.luau        # Sets up tag listeners
└── Config/                # Configuration files
    ├── ParameterConfig.luau    # Animation DSL definitions
    └── PresetConfig.luau       # Animation presets
```

### Component Hierarchy

```
Toggle (Base Class)
├── Page
├── Tab
└── Hover
```

All interactive elements inherit from `Toggle`, which provides activate/deactivate functionality.

---

## Getting Started

### Installation

1. Place the `xenterface` folder in `ReplicatedStorage` or another accessible location
2. Require the module in your client-side script:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local xenterface = require(ReplicatedStorage.xenterface)
```

### Basic Setup

The framework automatically initializes when required. It listens for tagged elements in the PlayerGui.

### Creating Your First Tab System

1. **Create a ScreenGui** with your UI structure
2. **Add a Tab button** (GuiButton):
   - Add the `Tab` tag using CollectionService
   - Set attributes:
     - `PageGroup` (string): The group this tab belongs to (e.g., "MainMenu")
     - `PageId` (string): The page this tab activates (e.g., "Settings")
     - `Active` (string): Animation when activated
     - `Inactive` (string): Animation when deactivated

3. **Add a Page** (GuiObject):
   - Add the `Page` tag
   - Set attributes:
     - `PageGroup` (string): Same as the tab's PageGroup
     - `PageId` (string): Same as the tab's PageId
     - `Active` (string): Animation when shown
     - `Inactive` (string): Animation when hidden

4. **Control programmatically** (optional):

```lua
local controller = xenterface:Controller("MainMenu")

-- Switch to a different page
controller:Fire("Settings")

-- Listen for page changes
controller.Fired:Connect(function(data)
    print("Active page:", data.ActiveId)
    print("Previous page:", data.InactiveId)
end)
```

---

## Core Concepts

### Tags

Xenterface uses CollectionService tags to identify UI elements:

- **`Tab`**: Interactive button that switches pages
- **`Page`**: Content area that shows/hides based on active tab
- **`Hover`**: Element with mouse hover animations
- **`Element`**: Element accessible by ID through ElementService

### Attributes

Elements are configured using attributes:

#### Tab/Page Attributes

- **`PageGroup`** (string): Groups tabs and pages together
- **`PageId`** (string): Unique identifier for the page within the group
- **`Active`** (string): Animation sequence when element becomes active
- **`Inactive`** (string): Animation sequence when element becomes inactive
- **`Preset`** (string): Use a predefined animation preset
- **`Toggle`** (boolean): For tabs - allow toggling off by clicking active tab

#### Element Attributes

- **`ElementId`** (string): Unique identifier for accessing the element

### Hierarchy

Tags can be applied to:
1. The GuiObject itself
2. A Configuration child of the GuiObject (for advanced configuration)

```
TextButton (Tab tag here)
└── Configuration (Or Tab tag here with attributes)
```

### Priority System

When multiple tags exist on the same element, animations follow this priority:

```
Hover > Page > Tab
```

If an element has both `Hover` and `Tab` tags, the Hover animations take precedence.

---

## Animation Sequence DSL

Xenterface features a powerful Domain-Specific Language (DSL) for defining animations as strings.

### Syntax Overview

Sequences are space, comma, or semicolon-separated phrases:

```
"pos-c ap-0.5 t-0.2 linear out"
```

### Timing Keywords

| Keyword | Description | Example |
|---------|-------------|---------|
| `t-<number>` | Duration of tween in seconds | `t-0.5` |
| `<number>` | Delay before next phrase | `0.2` |

### Easing Styles

| Keyword | Enum |
|---------|------|
| `linear` | `Enum.EasingStyle.Linear` |
| `sine` | `Enum.EasingStyle.Sine` |
| `quad` | `Enum.EasingStyle.Quad` |
| `cubic` | `Enum.EasingStyle.Cubic` |
| `quart` | `Enum.EasingStyle.Quart` |
| `quint` | `Enum.EasingStyle.Quint` |
| `exp` / `exponential` | `Enum.EasingStyle.Exponential` |
| `circ` / `circular` | `Enum.EasingStyle.Circular` |
| `back` | `Enum.EasingStyle.Back` |
| `bounce` | `Enum.EasingStyle.Bounce` |
| `elastic` | `Enum.EasingStyle.Elastic` |

### Easing Directions

| Keyword | Enum |
|---------|------|
| `in` | `Enum.EasingDirection.In` |
| `out` | `Enum.EasingDirection.Out` |
| `inout` | `Enum.EasingDirection.InOut` |

### Dynamic Properties

Properties that can be tweened:

| Shorthand | Property | Type |
|-----------|----------|------|
| `ap` | `AnchorPoint` | Vector2 |
| `bgc` | `BackgroundColor3` | Color3 |
| `bgt` | `BackgroundTransparency` | number |
| `bc` | `BorderColor3` | Color3 |
| `bsp` | `BorderSizePixel` | number |
| `p` / `pos` | `Position` | UDim2 |
| `r` / `rot` | `Rotation` | number |
| `s` / `size` | `Size` | UDim2 |
| `tc` | `TextColor3` | Color3 |
| `ts` | `TextSize` | number |
| `tsc` | `TextStrokeColor3` | Color3 |
| `tst` | `TextStrokeTransparency` | number |
| `tt` | `TextTransparency` | number |
| `ic` | `ImageColor3` | Color3 |
| `iro` | `ImageRectOffset` | Vector2 |
| `irs` | `ImageRectSize` | Vector2 |
| `it` | `ImageTransparency` | number |

### Static Properties

Properties that change instantly (not tweened):

| Shorthand | Property | Type |
|-----------|----------|------|
| `lo` | `LayoutOrder` | number |
| `v` | `Visible` | boolean |
| `z` | `ZIndex` | number |

### Property Value Syntax

#### UDim2

```lua
"pos-c"              -- UDim2.fromScale(0.5, 0.5) - Center
"pos-0.5"            -- UDim2.new(UDim.new(0.5, 0), UDim.new(0.5, 0)) - Same for both axes
"pos-0.5-100"        -- UDim2.new(UDim.new(0.5, 0), UDim.new(100, 0)) - X: scale, Y: offset
"pos-1-0-1-0"        -- UDim2.new(1, 0, 1, 0) - Full XSXOYSYO format
```

**UDim Rules:**
- Whole numbers (except 1) are treated as offset: `100` → `UDim.new(0, 100)`
- Decimals and 1 are treated as scale: `0.5` → `UDim.new(0.5, 0)`, `1` → `UDim.new(1, 0)`

#### Color3

```lua
"bgc-rgb-255-0-0"    -- Color3.fromRGB(255, 0, 0)
"bgc-hsv-360-1-1"    -- Color3.fromHSV(360, 1, 1)
"bgc-hex-FF0000"     -- Color3.fromHex("#FF0000")
"bgc-new-1-0-0"      -- Color3.new(1, 0, 0)
```

#### Number

```lua
"rot-45"             -- Rotation = 45
"ts-24"              -- TextSize = 24
```

#### Vector2

```lua
"ap-0.5"             -- Vector2.new(0.5, 0.5)
"ap-0.5-0.5"         -- Vector2.new(0.5, 0.5)
```

#### Boolean

```lua
"v-t"                -- Visible = true
"v-f"                -- Visible = false
```

### Special Keywords

#### Initial (`i` / `initial`)

Use the element's current property value:

```lua
"i"                  -- Captures all properties from other sequences
"pos-i"              -- Use current Position value
```

#### Present (`p` / `present`)

Use the property's value at the moment the sequence plays (for dynamic values):

```lua
"pos-p-add-0.1"      -- Add 0.1 to current position when sequence plays
```

### Operations

Modify property values with operations:

| Keyword | Operation | Example |
|---------|-----------|---------|
| `add` / `a` | Addition | `pos-add-0-10` (add 10 pixels) |
| `sub` / `s` | Subtraction | `size-sub-0.1` |
| `mult` / `m` | Multiplication | `size-mult-1.2` |
| `div` / `d` | Division | `size-div-2` |

#### Operation Syntax

```lua
"pos-i-add-0-10"              -- Take initial position and add UDim2.new(0, 10, 0, 10)
"pos-p-add-0-10"              -- Take present position and add offset
"size-add-0.1"                -- Add to current size (inferred)
"rot-mult-2"                  -- Double the rotation
"bgc-rgb-i-add-0.1-0-0"       -- Add red to current color
```

### Parentheses for Negative Numbers

Use parentheses around negative numbers:

```lua
"pos-0-(-10)"                 -- Position with negative offset
"p-a-0-(-10)"                 -- Add negative offset to position
```

### Complete Examples

#### Simple fade in
```lua
"bgt-0 t-0.5 linear"
```
Sets BackgroundTransparency to 0 over 0.5 seconds with linear easing.

#### Slide from bottom
```lua
"pos-i-add-0-100 bgt-1, t-0.3 quad out pos-i bgt-0"
```
- Start: Below initial position, invisible
- Animate: Back to initial position, fully visible over 0.3s

#### Hover effect
```lua
Active: "size-a-0.01 t-0.1 linear"
Inactive: "i t-0.1 linear"
```
- Hover: Grow by 0.01 scale
- Leave: Return to initial size

#### Complex multi-step
```lua
"pos-c ap-0.5 0.2 t-0.3 back out size-0.8 0.1 size-1 t-0.2 elastic"
```
1. Set position to center, anchor to center
2. Wait 0.2 seconds
3. Tween to scale 0.8 over 0.3s with back-out easing
4. Wait 0.1 seconds
5. Tween to scale 1 over 0.2s with elastic easing

---

## API Reference

### Main Module (`xenterface`)

#### `xenterface:Controller(pageGroup: string) -> Controller`

Gets or creates a controller for the specified page group.

```lua
local mainController = xenterface:Controller("MainMenu")
```

#### `xenterface:Get(elementId: string) -> GuiObject?`

Gets an element by its `ElementId` attribute.

```lua
local healthBar = xenterface:Get("HealthBar")
if healthBar then
    healthBar.Size = UDim2.fromScale(0.5, 1)
end
```

#### `xenterface:Wait(elementId: string) -> GuiObject`

Waits for an element with the specified `ElementId` to exist, then returns it.

```lua
local inventory = xenterface:Wait("InventoryPanel")
print("Inventory loaded!")
```

---

## Classes Reference

### Signal

Custom event implementation similar to Roblox's BindableEvent.

#### Constructor

```lua
local Signal = require(path.to.Signal)
local mySignal = Signal.new()
```

#### Methods

Inherits all methods from `RBXScriptSignal` and `BindableEvent`:

```lua
mySignal:Connect(function(...)
    print("Signal fired with:", ...)
end)

mySignal:Fire("Hello", "World")
```

---

### Controller

Manages a group of tabs and pages. Automatically created when using `xenterface:Controller()`.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `PageGroup` | string | The page group this controller manages |
| `Active` | string? | The currently active PageId |
| `Fired` | Signal | Signal that fires when pages change |
| `Sequences` | table | Internal sequence tracking |

#### Methods

##### `Controller:Fire(pageId: string, tab: GuiButton?)`

Switches to the specified page.

```lua
controller:Fire("Settings") -- Switch to Settings page
controller:Fire("") -- Deactivate all pages
```

#### Events

##### `Controller.Fired`

Fires when the active page changes.

**Event Data:**

```lua
{
    ActiveId: string,              -- New active PageId
    InactiveId: string,            -- Previous active PageId
    ActiveTab: GuiButton?,         -- New active tab
    InactiveTab: GuiButton?,       -- Previous active tab
    ActiveTabs: {GuiButton},       -- All tabs for active page
    InactiveTabs: {GuiButton},     -- All tabs for inactive page
    ActivePage: GuiObject?,        -- New active page
    InactivePage: GuiObject?,      -- Previous active page
    ActivePages: {GuiObject},      -- All pages for active id
    InactivePages: {GuiObject},    -- All pages for inactive id
    SelectedTab: GuiButton?        -- The tab that was clicked
}
```

**Example:**

```lua
controller.Fired:Connect(function(data)
    print("Switched from", data.InactiveId, "to", data.ActiveId)

    if data.ActiveTab then
        data.ActiveTab.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end)
```

---

### Page

Represents a page element. Extends `Toggle`.

#### Constructor

```lua
local Page = require(path.to.Page)
local page = Page.new(guiObject, source?)
```

**Parameters:**
- `guiObject`: The GuiObject to wrap
- `source`: Optional Configuration object with attributes (defaults to guiObject)

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Page` | GuiObject | The wrapped page element |
| `Active` | Sequence? | Animation when activated |
| `Inactive` | Sequence? | Animation when deactivated |

#### Methods

Inherits from `Toggle`:
- `Page:Activate()` - Play the active animation
- `Page:Deactivate()` - Play the inactive animation

---

### Tab

Represents a tab button. Extends `Toggle`.

#### Constructor

```lua
local Tab = require(path.to.Tab)
local tab = Tab.new(guiButton, source?)
```

**Parameters:**
- `guiButton`: The GuiButton to wrap
- `source`: Optional Configuration object with attributes (defaults to guiButton)

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Tab` | GuiButton | The wrapped tab button |
| `PageGroup` | string | The page group this tab belongs to |
| `PageId` | string | The page this tab activates |
| `Active` | Sequence? | Animation when activated |
| `Inactive` | Sequence? | Animation when deactivated |
| `Connections` | table | Event connections |

#### Methods

- `Tab:Activate()` - Play the active animation
- `Tab:Deactivate()` - Play the inactive animation
- `Tab:Disconnect()` - Disconnect all event connections

#### Behavior

Automatically connects to `MouseButton1Click` to fire the controller.

**Toggle Mode:**

If the tab has a `Toggle` attribute set to `true`, clicking the active tab will deactivate it:

```lua
tab:SetAttribute("Toggle", true)
-- Now clicking the active tab will fire controller:Fire("")
```

---

### Toggle

Base class for activatable/deactivatable elements.

#### Constructor

```lua
local Toggle = require(path.to.Toggle)
local toggle = Toggle.new(guiObject, source, systemType)
```

**Parameters:**
- `guiObject`: The GuiObject to wrap
- `source`: Configuration source (GuiObject or Configuration)
- `systemType`: "Tab", "Page", or "Hover" (for priority system)

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Active` | Sequence? | Animation when activated |
| `Inactive` | Sequence? | Animation when deactivated |

#### Methods

##### `Toggle:Activate()`

Plays the active animation (stops inactive animation if playing).

##### `Toggle:Deactivate()`

Plays the inactive animation (stops active animation if playing).

---

### Hover

Handles mouse hover interactions. Extends `Toggle`.

#### Constructor

```lua
local Hover = require(path.to.Hover)
local hover = Hover.new(guiObject, source?)
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Hover` | GuiObject | The wrapped element |
| `Active` | Sequence? | Animation on mouse enter |
| `Inactive` | Sequence? | Animation on mouse leave |
| `Connections` | table | Event connections |

#### Methods

- `Hover:Entered()` - Called on MouseEnter
- `Hover:Left()` - Called on MouseLeave
- `Hover:Disconnect()` - Disconnect all connections

---

### Sequence

Parses and plays animation sequences.

#### Constructor

```lua
local Sequence = require(path.to.Sequence)
local sequence = Sequence.new(guiObject, sequenceString, otherSequences, state)
```

**Parameters:**
- `guiObject`: The element to animate
- `sequenceString`: The animation sequence DSL string
- `otherSequences`: Array of other sequence strings (to capture initial values)
- `state`: "Active" or "Inactive" (for error messages)

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `GuiObject` | GuiObject | The element being animated |
| `RawSequence` | string | Original sequence string |
| `Sequence` | table | Parsed sequence data |
| `Tweens` | {Tween} | Active tweens |
| `Thread` | thread? | Active animation thread |
| `State` | string | "Active" or "Inactive" |

#### Methods

##### `Sequence:Play()`

Plays the animation sequence. Automatically stops any currently playing sequence.

##### `Sequence:Stop()`

Stops the sequence and cancels all tweens.

---

## Services Reference

### ControllerService

Singleton service that manages all controllers.

#### Methods

##### `ControllerService:Create(pageGroup: string) -> Controller`

Creates a new controller for the page group.

##### `ControllerService:Get(pageGroup: string) -> Controller`

Gets an existing controller or creates one if it doesn't exist.

##### `ControllerService:Fire(pageGroup: string, pageId: string, tab: GuiButton?)`

Fires a controller's Fire method directly.

---

### ElementService

Singleton service that tracks elements by their `ElementId` attribute.

#### Methods

##### `ElementService:Get(elementId: string) -> GuiObject?`

Returns the element with the specified ElementId, or nil if not found.

##### `ElementService:Wait(elementId: string) -> GuiObject`

Yields until an element with the specified ElementId exists, then returns it.

**Example:**

```lua
-- Element doesn't exist yet
local element = ElementService:Wait("MyElement")
-- Yields until someone creates an element with ElementId = "MyElement"
print("Element found:", element)
```

---

### TagService

Generic tag listening system. More flexible than CollectionService.

#### Methods

##### `TagService:Listen(tag: string, apply: function, unapply: function, ancestor: Instance)`

Listens for instances with the specified tag under the ancestor.

**Parameters:**
- `tag`: CollectionService tag to listen for
- `apply`: Function called when tagged instance is added
  - Signature: `(instance: Instance) -> any`
  - Return value is stored as "data" for the instance
- `unapply`: Function called when tagged instance is removed
  - Signature: `(instance: Instance, data: any) -> nil`
- `ancestor`: Only process instances under this ancestor

**Example:**

```lua
TagService:Listen("CustomButton", function(button)
    local connection = button.MouseButton1Click:Connect(function()
        print("Custom button clicked!")
    end)
    return connection -- Store connection as data
end, function(button, connection)
    connection:Disconnect() -- Clean up
end, game.Players.LocalPlayer.PlayerGui)
```

##### `TagService:Unlisten(tag: string)`

Stops listening for a tag and calls unapply for all instances.

##### `TagService:GetAllApplied(tag: string) -> {[Instance]: any}`

Returns a table of all instances with the tag and their associated data.

##### `TagService:GetApplied(tag: string, instance: Instance) -> any`

Returns the data associated with a specific instance.

##### `TagService:GetListenedTags() -> {string}`

Returns an array of all currently listened tags.

##### `TagService:GetListenedTagsOfInstance(instance: Instance) -> {string}`

Returns an array of all listened tags that the instance has.

---

## Configuration

### ParameterConfig

Defines the animation DSL syntax.

**Editable sections:**

- `Config.EasingDirections` - Map keywords to EasingDirection enums
- `Config.EasingStyles` - Map keywords to EasingStyle enums
- `Config.DynamicProperties` - Map keywords to tweenable properties
- `Config.StaticProperties` - Map keywords to instant-change properties
- `Config.Operations` - Define math operations

**Adding custom properties:**

```lua
-- Add a custom shorthand
Config.DynamicProperties.myProp = "MyCustomProperty"
```

### PresetConfig

Defines reusable animation presets.

**Built-in presets:**

- `Example` - Basic center positioning
- `Menu` - Menu open/close with back easing
- `Hover` - Size increase on hover
- `Hover2` - Position shift on hover

**Adding custom presets:**

```lua
PresetConfig.MyPreset = {
    Active = "pos-c t-0.5 back out size-1",
    Inactive = "i t-0.3 linear"
}
```

**Using presets:**

```lua
element:SetAttribute("Preset", "MyPreset")
-- Can override with specific Active/Inactive attributes
element:SetAttribute("Active", "pos-c t-1 elastic") -- Overrides preset's Active
```

---

## Examples

### Example 1: Simple Tab Navigation

```lua
-- No code needed! Just set up in Studio:

-- Tab 1 Button:
--   Tag: "Tab"
--   PageGroup: "Main"
--   PageId: "Home"
--   Active: "bgc-rgb-0-255-0 t-0.2"
--   Inactive: "bgc-rgb-100-100-100 t-0.2"

-- Tab 2 Button:
--   Tag: "Tab"
--   PageGroup: "Main"
--   PageId: "Settings"
--   Active: "bgc-rgb-0-255-0 t-0.2"
--   Inactive: "bgc-rgb-100-100-100 t-0.2"

-- Home Page Frame:
--   Tag: "Page"
--   PageGroup: "Main"
--   PageId: "Home"
--   Active: "v-t"
--   Inactive: "v-f"

-- Settings Page Frame:
--   Tag: "Page"
--   PageGroup: "Main"
--   PageId: "Settings"
--   Active: "v-t"
--   Inactive: "v-f"
```

### Example 2: Animated Tab System

```lua
-- Home Page:
--   Active: "pos-c ap-0.5 bgt-0 t-0.3 back out"
--   Inactive: "pos-0-(-100) bgt-1 t-0.2 linear"

-- Settings Page:
--   Active: "pos-c ap-0.5 bgt-0 t-0.3 back out"
--   Inactive: "pos-0-100 bgt-1 t-0.2 linear"

-- Creates slide-in/slide-out effect
```

### Example 3: Hover Button

```lua
-- Button with hover effect:
--   Tags: "Hover"
--   Active: "size-a-0.02 t-0.15 quad out"
--   Inactive: "i t-0.15 quad out"
```

### Example 4: Programmatic Control

```lua
local xenterface = require(game.ReplicatedStorage.xenterface)

-- Get controller
local controller = xenterface:Controller("MainMenu")

-- Listen for page changes
controller.Fired:Connect(function(data)
    print("Active page:", data.ActiveId)

    -- Custom logic based on active page
    if data.ActiveId == "Settings" then
        -- Load settings
    elseif data.ActiveId == "Inventory" then
        -- Load inventory
    end
end)

-- Switch pages programmatically
task.wait(2)
controller:Fire("Settings")

task.wait(2)
controller:Fire("Inventory")
```

### Example 5: Element Registry

```lua
-- Frame with ElementId = "HealthBar"

local xenterface = require(game.ReplicatedStorage.xenterface)

-- Wait for health bar to exist
local healthBar = xenterface:Wait("HealthBar")

-- Update health bar
game.Players.LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(health)
    local maxHealth = game.Players.LocalPlayer.Character.Humanoid.MaxHealth
    healthBar.Size = UDim2.fromScale(health / maxHealth, 1)
end)
```

### Example 6: Complex Multi-Step Animation

```lua
-- Popup notification:
--   Tag: "Page"
--   PageGroup: "Notifications"
--   PageId: "Popup"
--   Active: "pos-0.5-(-50) ap-0.5 size-0 bgt-1 0.1 t-0.3 back out pos-c size-0.3 bgt-0 0.5 t-0.2 linear bgt-1"
--   Inactive: "v-f"

-- Breakdown:
-- 1. Set initial state (off-screen, invisible, size 0)
-- 2. Wait 0.1s
-- 3. Slide in and grow over 0.3s with back-out easing
-- 4. Wait 0.5s
-- 5. Fade out over 0.2s
```

### Example 7: Using Presets

```lua
-- Button:
--   Tag: "Hover"
--   Preset: "Hover"

-- This automatically applies the Hover preset's animations
```

### Example 8: Tab with Toggle

```lua
-- Collapsible panel tab:
--   Tag: "Tab"
--   PageGroup: "Sidebar"
--   PageId: "ExpandedPanel"
--   Toggle: true  -- Can click to collapse

-- Click once: Opens panel
-- Click again: Closes panel (fires controller:Fire(""))
```

### Example 9: Relative Animations

```lua
-- Button that slides down on hover:
--   Tag: "Hover"
--   Active: "pos-p-add-0-5 t-0.1 linear"
--   Inactive: "pos-p-sub-0-5 t-0.1 linear"

-- Adds/subtracts 5 pixels from current position
```

### Example 10: Color Transitions

```lua
-- Status indicator:
--   Tag: "Page"
--   PageId: "StatusGreen"
--   Active: "bgc-rgb-0-255-0 t-0.5 linear"

--   Tag: "Page"
--   PageId: "StatusRed"
--   Active: "bgc-rgb-255-0-0 t-0.5 linear"

-- Script:
local controller = xenterface:Controller("Status")

if systemHealthy then
    controller:Fire("StatusGreen")
else
    controller:Fire("StatusRed")
end
```

---

## Advanced Usage

### Custom Tag Listeners

Use TagService to create your own custom behaviors:

```lua
local TagService = require(game.ReplicatedStorage.xenterface.Services.TagService)

TagService:Listen("Draggable", function(frame)
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local connection = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    return connection
end, function(frame, connection)
    connection:Disconnect()
end, game.Players.LocalPlayer.PlayerGui)
```

### Multiple Page Groups

You can have multiple independent tab systems:

```lua
-- Main navigation
local mainNav = xenterface:Controller("MainNav")

-- Settings sub-tabs
local settingsNav = xenterface:Controller("SettingsTabs")

mainNav.Fired:Connect(function(data)
    if data.ActiveId == "Settings" then
        -- Reset settings tabs when entering settings
        settingsNav:Fire("General")
    end
end)
```

### Animation Chaining

Create complex multi-step animations:

```lua
local sequence = [[
    -- Start hidden above screen
    pos-0.5-(-100) ap-0.5-0 bgt-1 size-0

    -- Slide in
    0.5 t-0.4 back out pos-c size-1 bgt-0

    -- Bounce
    0.2 t-0.1 quad out size-1.05
    t-0.1 quad in size-1

    -- Wait
    2

    -- Slide out
    t-0.3 back in pos-0.5-100 bgt-1
]]
```

### Dynamic Sequences

Modify sequences at runtime:

```lua
local controller = xenterface:Controller("Menu")

controller.Fired:Connect(function(data)
    if data.ActivePage then
        -- Store custom data
        data.ActivePage:SetAttribute("OpenTime", os.clock())
    end

    if data.InactivePage then
        local openTime = data.InactivePage:GetAttribute("OpenTime")
        if openTime then
            print("Page was open for", os.clock() - openTime, "seconds")
        end
    end
end)
```

### Combining with Other Systems

Integrate with other frameworks:

```lua
local xenterface = require(game.ReplicatedStorage.xenterface)
local SoundManager = require(game.ReplicatedStorage.SoundManager)

local controller = xenterface:Controller("MainMenu")

controller.Fired:Connect(function(data)
    -- Play sound on tab change
    if data.SelectedTab then
        SoundManager:Play("TabClick")
    end

    -- Track analytics
    Analytics:LogEvent("TabChanged", {
        from = data.InactiveId,
        to = data.ActiveId
    })
end)
```

### Debugging Sequences

If a sequence fails to parse, you'll get a detailed error:

```
Invalid phrase 'invalid-syntax' in 'Active' sequence affecting PlayerGui.MainMenu.Tab
```

Common issues:
- Forgetting to separate phrases with spaces/commas
- Using invalid property shortcuts
- Incorrect number of values for a property type
- Missing parentheses around negative numbers

---

## Best Practices

### Organization

1. **Use Configuration objects** for complex elements with many attributes
2. **Group related pages** under the same PageGroup
3. **Use ElementId** for elements you need to access programmatically
4. **Use descriptive PageIds** that reflect their purpose

### Performance

1. **Avoid creating too many sequences** with very high frame counts
2. **Stop sequences when elements are hidden** to save resources
3. **Use Static Properties** (`v`, `lo`, `z`) for instant changes
4. **Reuse presets** instead of duplicating animation strings

### Maintainability

1. **Define presets** for commonly used animations
2. **Document custom presets** in PresetConfig
3. **Use consistent naming** for PageGroups and PageIds
4. **Keep sequences readable** with proper spacing

### Animation Quality

1. **Match easing styles** to the motion type (back for menus, elastic for bouncy)
2. **Keep timings consistent** across related UI
3. **Use delays strategically** for sequenced animations
4. **Test on different screen sizes** when using scale values

---

## Troubleshooting

### Tabs not responding

- Verify `Tag` is "Tab" (case-sensitive)
- Check `PageGroup` and `PageId` attributes exist
- Ensure tab is a GuiButton or has a GuiButton parent
- Check if tab is under PlayerGui

### Pages not showing

- Verify `Tag` is "Page" (case-sensitive)
- Check `PageGroup` and `PageId` match a tab
- Ensure `Active` sequence includes visibility changes
- Verify page is under PlayerGui

### Animations not playing

- Check for syntax errors in sequence string
- Verify property shortcuts are correct
- Check console for error messages
- Ensure properties match element type (e.g., don't use `tc` on ImageLabel)

### Element not found with :Get()

- Verify `ElementId` attribute is set
- Check spelling of ElementId
- Ensure element is under PlayerGui
- Use `:Wait()` if element might not exist yet

### Multiple pages active at once

- Check for duplicate PageIds within the same PageGroup
- Verify PageGroup attributes are consistent
- Ensure Inactive sequences properly hide elements

---

## Performance Considerations

### Memory

- Each Controller creates a Signal object
- Each Sequence stores parsed animation data
- TagService maintains instance registries

### CPU

- Animation sequences run on defer threads
- TweenService handles interpolation
- CollectionService tags are monitored continuously

### Optimization Tips

1. Clean up unused controllers
2. Disconnect hover elements when hidden
3. Use visibility toggles instead of destroying elements
4. Limit the number of simultaneous animations
5. Profile with Microprofiler if experiencing lag

---

## Migration Guide

### From Manual Tab Systems

Before:
```lua
homeButton.MouseButton1Click:Connect(function()
    homePage.Visible = true
    settingsPage.Visible = false
end)

settingsButton.MouseButton1Click:Connect(function()
    homePage.Visible = false
    settingsPage.Visible = true
end)
```

After:
```
-- Add tags and attributes in Studio, no code needed!
```

### From Other UI Frameworks

Xenterface's declarative approach reduces code:

- **Roact/React**: No need for state management, use tags
- **Fusion**: Replace springs with sequence DSL
- **Custom systems**: Use TagService for similar flexibility

---

## Credits & License

**Xenterface** - Roblox UI Framework

This framework provides a declarative, tag-based approach to building animated user interfaces in Roblox.

**Key Technologies:**
- CollectionService for tag management
- TweenService for animations
- ReflectionService for property introspection

---

## Version History

**Current Version**: 1.0

Initial release with:
- Tab/Page system
- Hover interactions
- Element registry
- Animation sequence DSL
- Tag-based architecture
- Preset system

---

## Support

For issues, questions, or contributions:

1. Check this documentation thoroughly
2. Review the Examples section
3. Check the Troubleshooting guide
4. Examine the source code comments

---

## Appendix

### Complete Animation DSL Reference

```
Timing:
  t-<number>          Duration in seconds
  <number>            Delay in seconds

Easing Styles:
  linear, sine, quad, cubic, quart, quint
  exp, exponential, circ, circular
  back, bounce, elastic

Easing Directions:
  in, out, inout

Dynamic Properties:
  ap, bgc, bgt, bc, bsp
  pos, p, rot, r, size, s
  tc, ts, tsc, tst, tt
  ic, iro, irs, it

Static Properties:
  lo, v, z

Special:
  i, initial          Use initial/current value
  p, present          Use value at play time
  c                   Center (for UDim2)

Operations:
  add, a              Addition
  sub, s              Subtraction
  mult, m             Multiplication
  div, d              Division

Value Formats:
  UDim2: <scale> | <x> <y> | <xs> <xo> <ys> <yo> | c
  Color3: rgb-<r>-<g>-<b> | hsv-<h>-<s>-<v> | hex-<hex> | new-<r>-<g>-<b>
  Vector2: <x> <y> | <both>
  Number: <value>
  Boolean: t | f
```

### File Structure Reference

```
init.luau
├── Requires: ControllerService, ElementService, Tagger
└── Exports: Controller(), Get(), Wait()

Classes/
├── Signal.luau (Custom events)
├── Controller.luau (Page management)
├── Page.luau (Page wrapper)
├── Tab.luau (Tab wrapper)
├── Toggle.luau (Base toggle behavior)
├── Hover.luau (Hover interactions)
└── Sequence.luau (Animation parser/player)

Services/
├── ControllerService.luau (Controller registry)
├── ElementService.luau (Element registry)
└── TagService.luau (Tag listening system)

Modules/
├── extender.luau (Metatable utility)
└── Tagger.luau (Tag setup)

Config/
├── ParameterConfig.luau (DSL definitions)
└── PresetConfig.luau (Animation presets)
```

---

**End of Documentation**
