import ExpoModulesCore
import SwiftUI

// anything that could be a menu item
enum MenuElement {
  case item(MenuItem)
  case separator
  case label(MenuLabel)
  case group
  case checkboxItem(MenuCheckboxItem)
  //  case submenu(SubMenuItem)
}

struct MenuItemShared {
  var text: String = ""
  var subtitle: String?
  var image: UIImage?
  var destructive: Bool? = false

}

struct MenuItem {
  var text: String = ""
  var subtitle: String?
  var image: UIImage?
  var destructive: Bool? = false
  var onSelect: EventDispatcher
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
  var text: String?
  var subtitle: String?
  var image: UIImage?
  var destructive: Bool? = false
  var children: [MenuElement]
}

struct MenuLabel {
  var text: String
}

struct MenuSeparator {
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

struct ContextMenuContent: View {
  let actions: [MenuElement]

  var body: some View {
    ForEach(Array(actions.enumerated()), id: \.offset) { _, element in
      switch element {
      case .separator:
        Divider()
      case .item(let menuItem):
        Button(role: menuItem.destructive == true ? .destructive : nil, action: {}) {
          if let image = menuItem.image {
            Label(
              title: {
                Text(menuItem.text)
                if let subtitle = menuItem.subtitle {
                  Text(subtitle)
                }
              },
              icon: { Image(uiImage: image) }
            )
          } else {
            Text(menuItem.text)
            if let subtitle = menuItem.subtitle {
              Text(subtitle)
            }
          }
        }
      case .group:
        AnyView(EmptyView())  // TODO implement
      case .checkboxItem(let checkboxItem):
        ToggleView(checkboxItem: checkboxItem)
      case .label(let label):
        AnyView(EmptyView())  // TODO implement
      //          ‼️‼️‼️
      //          swiftui can't recursively render, will need to do something special for submenu.
      //          rather than ContextMenuContent existing, we should just do:
      //          renderItems(items) and call that recursively
      //      case .submenu(let submenu):
      //          ContextMenuContent(submenu.children)
      }
    }
  }
}

struct ContextMenuView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuProps

  func getItemFromChildren(view: ContextMenuItemView) -> MenuItemShared? {
    var title: String?
    var subtitle: String?
    for subview in view.subviews {
      if let titleView = subview as? ContextMenuItemTitleView {
        title = titleView.text
      } else if let subtitleView = subview as? ContextMenuItemSubtitleView {
        subtitle = subtitleView.text
      }
    }
    title = view.textContent ?? title  // textContent can override the title node child
    guard let title: String = title else { return nil }

    return MenuItemShared(text: title, subtitle: subtitle, destructive: view.destructive)
  }

  var body: some View {

    if #available(iOS 16.0, *) {
      var trigger: ExpoSwiftUI.Child?

      let preview = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuPreviewProps, ContextMenuPreviewView>
      }.first
      let accessory = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuAccessoryProps, ContextMenuAccessoryView>
      }.first

      let actions: [MenuElement] = (props.children ?? []).compactMap { child in
        if let triggerChild = child.view is ContextMenuTriggerView ? child : nil {
          trigger = triggerChild
          return nil
        }
        if let checkboxView = child.view as? ContextMenuCheckboxItemView {
          guard let item = getItemFromChildren(view: checkboxView) else { return nil }
          return .checkboxItem(
            MenuCheckboxItem(
              text: item.text,
              subtitle: item.subtitle,
              destructive: item.destructive,
              checked: checkboxView.value == "on",
              onValueChange: checkboxView.onValueChange
            ))
        }
        if child.view is ContextMenuSeparatorView {
          return .separator
        }
        if let label = child.view as? ContextMenuLabelView {
          return .label(MenuLabel(text: label.text))
        }
        if let itemView = child.view as? ContextMenuItemView {
          guard let item = getItemFromChildren(view: itemView) else { return nil }
          return .item(
            MenuItem(
              text: item.text, subtitle: item.subtitle, destructive: item.destructive,
              onSelect: itemView.onSelect))
        }
        return nil
      }

      if let trigger {
        if let accessory {
          // TODO deal with this later
          AnyView(EmptyView())
          //          ContextMenuWithAccessory(
          //            trigger: {
          //              trigger
          //            },
          //            overlay: {
          //              accessory
          //            }, menuItems: actions
          //          )
          //          .frame(height: trigger.view.frame.height)
        } else {
          if let preview {
            trigger
              .contextMenu {
                ContextMenuContent(actions: actions)
              } preview: {
                preview
              }
          } else {
            trigger
              .contextMenu {
                ContextMenuContent(actions: actions)
              }
          }
        }
      } else {
        Children()
      }
    } else {
      Children()
    }
  }
}

class ContextMenuCheckboxItemView: ContextMenuItemView {
  var value: String = "off"
  var onValueChange = EventDispatcher()

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuSeparatorView: ExpoView {
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuProps: ExpoSwiftUI.ViewProps {

}

class ContextMenuItemView: ExpoView {
  var textContent: String?
  var image: UIImage?
  var destructive: Bool? = false
  var onSelect = EventDispatcher()
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuItemTitleView: ExpoView {
  var text: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuItemSubtitleView: ExpoView {
  var text: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuLabelView: ExpoView {
  var text: String = ""
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuTriggerView: ExpoView {
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuAccessoryProps: ExpoSwiftUI.ViewProps {

}

struct ContextMenuAccessoryView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuAccessoryProps
  var body: some View {
    Children()
  }
}

class ContextMenuPreviewProps: ExpoSwiftUI.ViewProps {

}

struct ContextMenuPreviewView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuPreviewProps
  var body: some View {
    Children()
  }
}
