import SwiftUI
import ExpoModulesCore


struct MenuItem {
  var text: String
}

struct ContextMenuView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuProps
  
  var body: some View {
    
    if #available(iOS 16.0, *) {
      let trigger = props.children?.filter { $0.view is ContextMenuTriggerView }.first
      let menuItems = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuItemProps, ContextMenuItemView>
      }
      let preview = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuPreviewProps, ContextMenuPreviewView>
      }.first
      let accessory = props.children?.filter {
        $0.view is ExpoSwiftUI.HostingView<ContextMenuAccessoryProps, ContextMenuAccessoryView>
      }.first
      
      let actions: [MenuItem] = (menuItems ?? []).compactMap { child in
        if let child = child.view as? ExpoSwiftUI.HostingView<ContextMenuItemProps, ContextMenuItemView> {
          return MenuItem(text: child.getProps().text) // Ensure `text` is a String
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
                  if let item = item.view as? ExpoSwiftUI.HostingView<ContextMenuItemProps, ContextMenuItemView> {
                    Button(item.getProps().text) {}
                  }
                }
              } preview: { preview }
          } else {
            trigger
              .contextMenu {
                ForEach(menuItems ?? []) { item in
                  if let item = item.view as? ExpoSwiftUI.HostingView<ContextMenuItemProps, ContextMenuItemView> {
                    Button(item.getProps().text) {}
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

class ContextMenuItemProps: ExpoSwiftUI.ViewProps {
  @Field var text: String
}

struct ContextMenuItemView: ExpoSwiftUI.View {
  @EnvironmentObject var props: ContextMenuItemProps
  var body: some View {
    Children()
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
