import ExpoModulesCore
import SwiftUI


struct ContextMenuView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuProps

  func renderItems(actions: [MenuElement]) -> some View {
    AnyView(
      ForEach(Array(actions.enumerated()), id: \.offset) { _, element in
        switch element {
        case .separator:
          Divider()
        case .item(let menuItem):
          Button(role: menuItem.destructive == true ? .destructive : nil, action: {}) {
            ButtonLabelView(
              text: menuItem.text,
              subtitle: menuItem.subtitle,
              image: menuItem.image,
              icon: menuItem.icon
            )
          }
        case .group(let group):
          if group.horizontal {
            ControlGroup {
              renderItems(actions: group.children)
            }
          } else {
            Section(header: Text(group.label ?? "").foregroundColor(.secondary)) {
              renderItems(actions: group.children)
            }
          }
        case .checkboxItem(let checkboxItem):
          ToggleView(checkboxItem: checkboxItem)
        case .label(let label):
            Text(label.text)
                .foregroundColor(.secondary)
                .font(.footnote)
        case .submenu(let submenu):
          Menu {
            renderItems(actions: submenu.children)
          } label: {
            ButtonLabelView(
              text: submenu.text,
              subtitle: submenu.subtitle,
              image: submenu.image,
              icon: submenu.icon
            )
          } primaryAction: {
            if let onSelect = submenu.onSelect {
              onSelect([:])
            }
          }
        }
      })
  }

  func mapItemsChildren(children: [UIView]) -> [MenuElement] {
    return (children).compactMap { child in
      if let checkboxView = child as? ContextMenuCheckboxItemView {
        guard let item = getItemFromChildren(view: checkboxView) else { return nil }
        return .checkboxItem(
          MenuCheckboxItem(
            text: checkboxView.textValue ?? item.text,
            subtitle: item.subtitle,
            destructive: checkboxView.destructive,
            checked: checkboxView.value == "on",
            onValueChange: checkboxView.onValueChange
          ))
      }
      if child is ContextMenuSeparatorView {
        return .separator
      }
    if let subView = child as? ContextMenuSubView {
      guard
        let subTrigger = subView.subviews.first(where: { $0 is ContextMenuSubTriggerView }) as? ContextMenuSubTriggerView,
        let item = getItemFromChildren(view: subTrigger)
      else {
        return nil
      }

      return .submenu(
        SubMenuItem(
          text: item.text,
          subtitle: item.subtitle,
          image: item.image,
          destructive: subView.destructive,
          onSelect: subTrigger.onSelect,
          children: mapItemsChildren(children: subView.subviews),
          icon: item.icon
        ))
    }
      if let label = child as? ContextMenuLabelView {
        return .label(MenuLabel(text: label.text))
      }
      if let itemView = child as? ContextMenuItemView {
        guard let item = getItemFromChildren(view: itemView) else { return nil }
        return .item(
          MenuItem(
            text: itemView.textValue ?? item.text, subtitle: item.subtitle, image: item.image,
            destructive: itemView.destructive,
            onSelect: itemView.onSelect, icon: item.icon))
      }
      if let group = child as? ContextMenuGroupView {
        return .group(
          MenuGroup(
            label: group.label, 
            horizontal: group.horizontal,
            children: mapItemsChildren(children: group.subviews)
          )
        )
      }
      return nil
    }
  }

  func getItemFromChildren(view: UIView) -> MenuItemShared? {
    var title: String?
    var subtitle: String?
    var icon: MenuItemIcon?
    // TODO does this support nested subviews? should we go recursive / build a queue?
    for subview in view.subviews {
      if let titleView = subview as? ContextMenuItemTitleView {
        title = titleView.text
      } else if let subtitleView = subview as? ContextMenuItemSubtitleView {
        subtitle = subtitleView.text
      } else if let iconItem = subview as? ContextMenuItemIconView {
        icon = MenuItemIcon(name: iconItem.name)
      }
    }
    guard let title: String = title else { return nil }

    return MenuItemShared(text: title, subtitle: subtitle, icon: icon)
  }
  
  func extractMenuComponents(from children: [ExpoSwiftUI.Child]?) -> (
    trigger: ExpoSwiftUI.Child?,
    preview: ExpoSwiftUI.Child?,
    accessory: ExpoSwiftUI.Child?
  ) {
    var trigger: ExpoSwiftUI.Child?
    var preview: ExpoSwiftUI.Child?
    var accessory: ExpoSwiftUI.Child?
    
    guard let children = children else {
      return (trigger, preview, accessory)
    }
    
    for child in children {
      let view = child.view
      if view is ContextMenuTriggerView {
        trigger = child
      } else if view is ExpoSwiftUI.HostingView<ContextMenuPreviewProps, ContextMenuPreviewView> {
        preview = child
      } else if view is ExpoSwiftUI.HostingView<ContextMenuAccessoryProps, ContextMenuAccessoryView> {
        accessory = child
      }
    }
    
    return (trigger, preview, accessory)
  }

  var body: some View {
    let (trigger, preview, accessory) = extractMenuComponents(from: props.children)
      
      let _ = print("[body][render]\(String(describing: props.children?.count))")
    
    
    let actions = mapItemsChildren(
      children: props.children?.compactMap({ child in
        child.view
      }) ?? [])

    if let trigger {
      if props.isDropdown == true {
        Menu {
            renderItems(actions: actions)
        } label: {
            trigger.frame(alignment: .topLeading)
        }
      } else if #unavailable(iOS 16.0) {
        trigger
      } else if let preview {
        trigger
          .contextMenu {
            renderItems(actions: actions)
          } preview: {
              preview.ignoresSafeArea(.all)
          }
          .onAppear(perform: {
              props.onOpenChange(["open": true])
          })
          .onDisappear(perform: {
              props.onOpenChange(["open": false])
          })
      } else {
        trigger
          .contextMenu {
            renderItems(actions: actions)
          }
          .onAppear(perform: {
              props.onOpenChange(["open": true])
          })
          .onDisappear(perform: {
              props.onOpenChange(["open": false])
          })
      }
    } else {
      Children()
    }
  }
}

class ContextMenuProps: ExpoSwiftUI.ViewProps {
  var onOpenChange = EventDispatcher()
    @Field var isDropdown: Bool? = false
}
// ICON
class ContextMenuItemIconView: ExpoView {
  var name: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}
// CHECKBOX
class ContextMenuCheckboxItemView: ContextMenuItemView {
  var value: String = "off"
  var onValueChange = EventDispatcher()

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// SEPARATOR
class ContextMenuSeparatorView: ExpoView {
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// ITEM
class ContextMenuItemView: ExpoView {
  var textValue: String?
  var destructive: Bool? = false
  var onSelect = EventDispatcher()
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// SUB
class ContextMenuSubViewProps: ExpoSwiftUI.ViewProps {
  @Field var textValue: String?
  @Field var destructive: Bool? = false
  var onSelect = EventDispatcher()
}

class ContextMenuSubView: ExpoView {
  var textValue: String?
  var destructive: Bool? = false
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// SUBTRIGGER
class ContextMenuSubTriggerView: ExpoView {
  var onSelect = EventDispatcher()
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// TITLE

class ContextMenuItemTitleView: ExpoView {
  var text: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// SUBTITLE
class ContextMenuItemSubtitleView: ExpoView {
  var text: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// LABEL
class ContextMenuLabelView: ExpoView {
  var text: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// TRIGGER
class ContextMenuTriggerView: ExpoView {
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

// ACCESSORY
class ContextMenuAccessoryProps: ExpoSwiftUI.ViewProps {

}

struct ContextMenuAccessoryView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuAccessoryProps
  var body: some View {
    Children()
  }
}

// PREVIEW
class ContextMenuPreviewProps: ExpoSwiftUI.ViewProps {

}

struct ContextMenuPreviewView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuPreviewProps
  var body: some View {
    Children()
  }
}

// GROUP
class ContextMenuGroupView: ExpoView {
  var horizontal: Bool = false
  var label: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}
