import ExpoModulesCore
import SwiftUI

// anything that could be a menu item
enum MenuElement {
  case item(MenuItem)
  case separator
  case label(MenuLabel)
  case group(MenuGroup)
  case checkboxItem(MenuCheckboxItem)
  case submenu(SubMenuItem)
}

struct MenuGroup {
  var label: String? = ""
  var children: [MenuElement]
}

struct MenuItemShared {
  var text: String = ""
  var subtitle: String?
  var image: UIImage?
  var icon: MenuItemIcon?
}

struct MenuItemIcon {
  var name: String
  // add more properties like colors, ...
}

struct MenuItem {
  var text: String = ""
  var subtitle: String?
  var image: UIImage?
  var destructive: Bool? = false
  var onSelect: EventDispatcher
  var icon: MenuItemIcon?
}

class MenuCheckboxItem: ObservableObject {
  var text: String
  var subtitle: String?
  var image: UIImage?
  var destructive: Bool? = false
  @Published var checked: Bool = false
  var onValueChange: EventDispatcher
  init(
    text: String, subtitle: String? = nil, image: UIImage? = nil, destructive: Bool? = nil,
    checked: Bool = false, onValueChange: EventDispatcher
  ) {
    self.text = text
    self.subtitle = subtitle
    self.image = image
    self.destructive = destructive
    self.checked = checked
    self.onValueChange = onValueChange
  }
}

struct SubMenuItem {
  var text: String
  var subtitle: String?
  var image: UIImage?
  var destructive: Bool? = false
  var onSelect: EventDispatcher?
  var children: [MenuElement]
}

struct MenuLabel {
  var text: String
}

struct MenuSeparator {
}

struct ButtonLabelView: View {
  var text: String
  var subtitle: String?
  var image: UIImage?
  var icon: MenuItemIcon?

  var body: some View {
    if let image = image {
      Label(
        title: {
          Text(text)
          if let subtitle = subtitle {
            Text(subtitle)
          }
        },
        icon: { Image(uiImage: image) }
      )
    } else if let icon = icon {
      Label(
        title: {
          Text(text)
          if let subtitle = subtitle {
            Text(subtitle)
          }
        },
        icon: { Image(systemName: icon.name) }
      )
    } else {
      Text(text)
      if let subtitle = subtitle {
        Text(subtitle)
      }
    }
  }
}

struct ToggleView: View {
  @ObservedObject var checkboxItem: MenuCheckboxItem
  var body: some View {
    Toggle(checkboxItem.text, isOn: $checkboxItem.checked)
      .onChange(of: checkboxItem.checked) { newValue in
        checkboxItem.onValueChange(["value": newValue])
      }
  }
}

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
            Section(header: Text(group.label ?? "").foregroundColor(.secondary)) {
                renderItems(actions: group.children)
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
              icon: nil
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
      if let subView = child as? ContextMenuSubView {
        guard
          let subTrigger = subView.subviews.first(where: { $0 is ContextMenuSubTriggerView }) as? ContextMenuSubTriggerView,
          let item = getItemFromChildren(view: subTrigger)
        else {
          return nil
        }

        return .submenu(
          SubMenuItem(
            text: item.text, subtitle: item.subtitle, image: item.image,
            destructive: subView.destructive,
            onSelect: subTrigger.onSelect,
            children: mapItemsChildren(children: subView.subviews)
          ))
      }
      return nil
    }
  }

  func getItemFromChildren(view: UIView) -> MenuItemShared? {
    var title: String?
    var subtitle: String?
    var icon: MenuItemIcon?
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

  var body: some View {
    // TODO fewer loops
    let trigger = props.children?.first(where: { $0.view is ContextMenuTriggerView })
    let preview = props.children?.filter {
      $0.view is ExpoSwiftUI.HostingView<ContextMenuPreviewProps, ContextMenuPreviewView>
    }.first
    let accessory = props.children?.filter {
      $0.view is ExpoSwiftUI.HostingView<ContextMenuAccessoryProps, ContextMenuAccessoryView>
    }.first

    let actions = mapItemsChildren(
      children: props.children?.compactMap({ child in
        child.view
      }) ?? [])

    if let trigger {
      if #unavailable(iOS 16.0) {
        trigger
      } else if let preview {
        trigger
          .contextMenu {
            renderItems(actions: actions)
          } preview: {
            preview
          }
      } else {
        trigger
          .contextMenu {
            renderItems(actions: actions)
          }
      }
    } else {
      Children()
    }
  }
}

class ContextMenuProps: ExpoSwiftUI.ViewProps {
  var onOpenChange = EventDispatcher()
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
