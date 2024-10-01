# xenterface
Simplify your UI navigation with xenterface.

## Why xenterface?
Arguably the most gross and unorganized aspect of programming on ROBLOX is UI scripting. Unless you're using some other existing UI framework (such as Roact), you'll probably either end up (1) making your own lower-quality UI framework tailored specifically for that game or (2) creating a ton of disorganized MouseButton1Click connections all across your UI. 

**xenterface is concise**. Leveraging CollectionService's tags, Instance's attributes, and an extremely declarative paradigm, xenterface eliminates almost all UI boilerplate, allowing you to focus solely on the functionality of your UI. Less code is clean code, and xenterface is as concise as it gets.

**xenterface is simple**. Unlike many other UI frameworks, xenterface is incredibly easy to pick up, with an API that's simple, intuitive, and yet powerful. The core functionalities of xenterface take minutes to learn. Check out the YT video in the Basic Usage section for a run-down.

**xenterface is non-intrusive**. Even though it's a framework, you'll never have to worry about xenterface messing up other parts of your project. It's packaged neatly in its own unit, and it minds its own business. Use it or don't, xenterface doesn't care, and nor will your project.

## Use Cases
- [x] Tackle complex UI navigation
- [x] Create menu systems with ease
- [x] Power complicated inventory UI
- [x] Eliminate messy UI code

## Basic Usage
i will probably make a yt video or something at some point.

## API
### xenterface
Simply start xenterface by requiring the xenterface ModuleScript!

`require(ReplicatedStorage.xenterfaceFolder.xenterface) --your path to xenterface`
| Method | Description |
| ------ | ------- |
| `xenterface:CreateFunction(pageGroup: string, f: (functionObject: FunctionObject) -> nil)` | Links the passed in function to the specified PageGroup. |
| `xenterface:FireFunction(pageGroup: string, pageId: string \| number, rawTab: GuiButton?)` | Fires the function associated with the specified PageGroup and PageId. An additional trigger tab can be provided. |
| `xenterface:DeleteFunction(pageGroup: string)` | Deletes the function associated with the specified PageGroup, if it exists. |
| `xenterface:GetElementById(elementId: string): GuiObject` | Returns an element with the specified id. Ids should be unique. |
| `xenterface:GetElementByClass(elementClass: string): {GuiObject}` | Returns all elements of the given class name in a table. |

### Tab
Tag: `Tab`
| Attribute | Description |
| ------ | ------- |
| *`Page_Group: string` | The PageGroup that the attributed GuiButton should be a part of. |
| *`Page_Id: string \| number` | The PageId that the attributed GuiObject should identify under to manipulate corresponding pages. |
| `Tab_InputType: string` | String of UserInputType used to activate tab. |

Attributes marked with * are required to specify.

### Page
Tag: `Page`
| Attribute | Description |
| ------ | ------- |
| *`Page_Group: string` | The PageGroup that the attributed GuiObject should be a part of. |
| *`Page_Id: string \| number` | The PageId that the attributed GuiObject should identify under to be manipulated by corresponding tabs. |

Attributes marked with * are required to specify.

### Element
Tag: `Element`
| Attribute | Description |
| ------ | ------- |
| `Element_Id: string` | A unique id of an element.  |
| `Element_Class: string` | A class for the element. |

### FunctionObject
Received as a parameter in the function passed into `xenterface:CreateFunction()`.
| Field | Description |
| ------ | ------- |
| `PageId: string` | The PageId of the fired function. |
| `RawTab: GuiButton?` | The literal tab that fired the function. If fired manually through `xenterface` without argument `rawTab` specified, this field will be `nil`. |
| `SelectedTabs: {GuiButton}` | An array of tabs with PageIds matching that of the clicked tab. |
| `SelectedPages: {GuiObject}` | An array of pages with PageIds matching that of the clicked tab. |
| `UnselectedTabs: {GuiButton}` | An array of tabs with PageIds not matching that of the clicked tab. |
| `UnselectedPages: {GuiObject}` | An array of pages with PageIds not matching that of the clicked tab. |