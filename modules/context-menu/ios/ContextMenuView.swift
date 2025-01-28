import SwiftUI
import ExpoModulesCore


struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    var text: String
    var subtitle: String?
    var image: UIImage?
    var actionKey: String?
    var destructive: Bool? = false
    
    // UIImage isn't Hashable, so we'll exclude it from hash calculation
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(subtitle)
        hasher.combine(actionKey)
    }
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct ContextMenuContent: View {
    let actions: [MenuItem]
    
    var body: some View {
        ForEach(actions, id: \.self) { item in
            Button(role: item.destructive == true ? .destructive : nil, action: {}) {
                if let image = item.image {
                    Label(
                        title: {
                            Text(item.text)
                            if let subtitle = item.subtitle {
                                Text(subtitle)
                            }
                        },
                        icon: { Image(uiImage: image) }
                    )
                } else {
                    Text(item.text)
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                    }
                }
            }
        }
    }
}

struct ContextMenuView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuProps
  
  var body: some View {
    
    if #available(iOS 16.0, *) {
      let trigger = props.children?.filter { $0.view is ContextMenuTriggerView }.first
      let menuItems = props.children?.filter {
        $0.view is ContextMenuItemView
      }
      let preview = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuPreviewProps, ContextMenuPreviewView>
      }.first
      let accessory = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuAccessoryProps, ContextMenuAccessoryView>
      }.first
      
      let actions: [MenuItem] = (menuItems ?? []).compactMap { child in
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
              return MenuItem(text: title, subtitle: subtitle, destructive: itemView.destructive)
          }
          return nil
      }
      
      if let accessory {
        ContextMenuWithAccessory(trigger: {
          trigger
        }, overlay: {
          accessory
        }, menuItems: actions)
        .frame(height: trigger?.view.frame.height)
      } else {
        if let trigger {
          if let preview {
             trigger
              .contextMenu {
                  ContextMenuContent(actions: actions)
              } preview: { preview }
          } else {
            trigger
              .contextMenu {
                  ContextMenuContent(actions: actions)
              }
          }
        }
      }
    } else {
      Children()
    }
  }
}

// Get the correct view to render based on the item's `type`.
// Avoids creating a native view for each option.
func getMenuItem(item: ContextMenuItemView) -> AnyView {
  switch(item.type) {
  case "button":
    return AnyView(Button(item.title) {})
  case "text":
    return AnyView(Text(item.title))
  case "divider":
    return AnyView(Divider())
  case "toggle":
    return AnyView(Toggle(isOn: .constant(true), label: {
      Text(item.title)
    }))
  default:
    return AnyView(Text(item.title))
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
