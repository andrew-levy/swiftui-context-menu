import SwiftUI
import ExpoModulesCore


struct MenuItem {
    var text: String
    var subtitle: String?
    var image: UIImage?
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
              return MenuItem(text: title, subtitle: subtitle)
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
                ForEach(menuItems ?? []) { item in
                  if let item = item.view as? ContextMenuItemView {
                    Button(item.text) {}
                  }
                }
              } preview: { preview }
          } else {
            trigger
              .contextMenu {
                ForEach(menuItems ?? []) { item in
                  if let item = item.view as? ContextMenuItemView {
                    Button(item.text) {}
                  }
                }
              }
          }
        }
      }
    } else {
      Children()
    }
  }
}



class ContextMenuProps: ExpoSwiftUI.ViewProps {
  
}

class ContextMenuItemView: ExpoView {
  var text: String = ""
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
