import ExpoModulesCore
import SwiftUI

// anything that could be a menu item
enum MenuElement {
  case item(MenuItem)
  case separator
  case label(MenuLabel)
  case group
  case checkboxItem(MenuCheckboxItem)
}

struct MenuItem {
  var text: String?
  var subtitle: String?
  var image: UIImage?
  var actionKey: String?
  var destructive: Bool? = false
}

struct MenuCheckboxItem {
  var text: String?
  var subtitle: String?
  var image: UIImage?
  var actionKey: String?
  var destructive: Bool? = false
  var checked: Bool? = false
}

struct MenuLabel {
  var text: String
}

struct MenuSeparator {
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
                Text(menuItem.text ?? "")
                if let subtitle = menuItem.subtitle {
                  Text(subtitle)
                }
              },
              icon: { Image(uiImage: image) }
            )
          } else {
            Text(menuItem.text ?? "")
            if let subtitle = menuItem.subtitle {
              Text(subtitle)
            }
          }
        }
      case .group:
        AnyView(EmptyView())  // TODO implement
      case .checkboxItem(let checkboxItem):
        AnyView(EmptyView())  // TODO implement
      case .label(let label):
        AnyView(EmptyView())  // TODO implement
      }
    }
  }
}

struct ContextMenuView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuProps

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
        if child.view is ContextMenuSeparatorView {
          return .separator
        }
        if let label = child.view as? ContextMenuLabelView {
          return .label(MenuLabel(text: label.text))
        }
        if let itemView = child.view as? ContextMenuItemView {
          var title: String?
          var subtitle: String?
          for subview in itemView.subviews {
            if let titleView = subview as? ContextMenuItemTitleView {
              title = titleView.text
            } else if let subtitleView = subview as? ContextMenuItemSubtitleView {
              subtitle = subtitleView.text
            }
          }
          guard let title = title else { return nil }
          return .item(MenuItem(text: title, subtitle: subtitle, destructive: itemView.destructive))
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

class ContextMenuSeparatorView: ExpoView {
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }
}

class ContextMenuProps: ExpoSwiftUI.ViewProps {

}

class ContextMenuItemView: ExpoView {
  var title: String = ""
  var image: UIImage?
  var actionKey: String?
  var destructive: Bool? = false
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
