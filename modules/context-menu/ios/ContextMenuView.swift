import ExpoModulesCore
import SwiftUI

// MARK: - Root Context Menu View
struct ContextMenuView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuProps
    
    func extractMenuComponents(from children: [ExpoSwiftUI.Child]?) -> (
        trigger: ExpoSwiftUI.Child?,
        preview: ExpoSwiftUI.Child?,
        content: ExpoSwiftUI.Child?
    ) {
        var trigger: ExpoSwiftUI.Child?
        var preview: ExpoSwiftUI.Child?
        var content: ExpoSwiftUI.Child?
        
        guard let children = children else {
            return (trigger, preview, content)
        }
        
        for child in children {
            let view = child.view
            if view is ExpoSwiftUI.HostingView<ContextMenuTriggerProps, ContextMenuTriggerView> {
                trigger = child
            } else if view is ExpoSwiftUI.HostingView<ContextMenuPreviewProps, ContextMenuPreviewView> {
                preview = child
            } else if view is ExpoSwiftUI.HostingView<ContextMenuContentProps, ContextMenuContentView> {
                content = child
            }
        }
        
        return (trigger, preview, content)
    }
    
    var body: some View {
        let (trigger, preview, content) = extractMenuComponents(from: props.children)
        
        let _ = print("ContextMenuView debug - Content: \(String(describing: content)), Preview: \(String(describing: preview)), Trigger: \(String(describing: trigger))")
        
        if let trigger {
            if props.isDropdown == true {
                Menu {
                    if let content {
                        content
                    }
                } label: {
                    trigger.frame(alignment: .topLeading)
                }
            } else if #unavailable(iOS 16.0) {
                trigger
            } else if let preview {
                trigger
                    .contextMenu {
                        if let content {
                            content
                        }
                    } preview: {
                        preview.ignoresSafeArea(.all)
                    }
                    .onAppear { props.onOpenChange(["open": true]) }
                    .onDisappear { props.onOpenChange(["open": false]) }
            } else {
                trigger
                    .contextMenu {
                        if let content {
                            content
                        }
                    }
                    .onAppear { props.onOpenChange(["open": true]) }
                    .onDisappear { props.onOpenChange(["open": false]) }
            }
        } else {
            Children()
        }
    }
}

// MARK: - Content Views
struct ContextMenuContentView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuContentProps
    var body: some View {
        UnwrappedChildren()
    }
}

struct ContextMenuSubContentView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuSubContentProps
    var body: some View {
        UnwrappedChildren()
    }
}

// MARK: - Item View (Just renders children)
struct ContextMenuItemView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuItemProps
    
    var body: some View {
        Button(role: props.destructive == true ? .destructive : nil, action: {
            props.onSelect([:])
        }) {
            UnwrappedChildren()
        }
    }
}

// MARK: - Item Title View (Maps to SwiftUI Text)
struct ContextMenuItemTitleView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuItemTitleProps
    
    var body: some View {
        Text(props.text)
    }
}

// MARK: - Item Subtitle View (Maps to SwiftUI Text)
struct ContextMenuItemSubtitleView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuItemSubtitleProps
    
    var body: some View {
        Text(props.text)
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

// MARK: - Label View (Maps to SwiftUI Text)
struct ContextMenuLabelView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuLabelProps
    
    var body: some View {
        Text(props.text)
            .foregroundColor(.secondary)
            .font(.footnote)
    }
}

// MARK: - Separator View (Maps to SwiftUI Divider)
class ContextMenuSeparatorProps: ExpoSwiftUI.ViewProps {
}
struct ContextMenuSeparatorView: ExpoSwiftUI.View
{
    @EnvironmentObject var props: ContextMenuSeparatorProps
    var body: some View {
        Divider()
    }
}

// MARK: - Checkbox Item View (Just renders children)
struct ContextMenuCheckboxItemView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuCheckboxItemProps
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { props.value == "on" },
            set: { newValue in
                props.onValueChange(["value": newValue ? "on" : "off"])
            }
        )) {
            UnwrappedChildren()
        }
    }
}

// MARK: - Sub View (Handles nested menu structure)
struct ContextMenuSubView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuSubProps
    
    func extractSubComponents(from children: [ExpoSwiftUI.Child]?) -> (
        trigger: ExpoSwiftUI.Child?,
        content: ExpoSwiftUI.Child?
    ) {
        var trigger: ExpoSwiftUI.Child?
        var content: ExpoSwiftUI.Child?
        
        guard let children = children else {
            return (trigger, content)
        }
        
        for child in children {
            let view = child.view
            if view is ExpoSwiftUI.HostingView<ContextMenuSubTriggerProps, ContextMenuSubTriggerView> {
                trigger = child
            } else if view is ExpoSwiftUI.HostingView<ContextMenuSubContentProps, ContextMenuSubContentView> {
                content = child
            }
        }
        
        return (trigger, content)
    }
    
    var body: some View {
        let (trigger, content) = extractSubComponents(from: props.children)
        
        if let trigger {
            Menu {
                if let content {
                    content
                }
            } label: {
                trigger
            }
        } else {
            UnwrappedChildren()
        }
    }
}

// MARK: - Sub Trigger View (Just renders children)
struct ContextMenuSubTriggerView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuSubTriggerProps
    
    var body: some View {
        UnwrappedChildren()
    }
}

// MARK: - Preview View (Just renders children)
struct ContextMenuPreviewView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuPreviewProps
    
    var body: some View {
        UnwrappedChildren()
    }
}

// MARK: - Props
class ContextMenuProps: ExpoSwiftUI.ViewProps {
    var onOpenChange = EventDispatcher()
    @Field var isDropdown: Bool? = false
}

class ContextMenuItemProps: ExpoSwiftUI.ViewProps {
    var onSelect = EventDispatcher()
    @Field var destructive: Bool? = false
}

class ContextMenuItemTitleProps: ExpoSwiftUI.ViewProps {
    @Field var text: String = ""
}

class ContextMenuItemSubtitleProps: ExpoSwiftUI.ViewProps {
    @Field var text: String = ""
}

class ContextMenuLabelProps: ExpoSwiftUI.ViewProps {
    @Field var text: String = ""
}

class ContextMenuCheckboxItemProps: ExpoSwiftUI.ViewProps {
    var onValueChange = EventDispatcher()
    @Field var value: String = "off"
}

class ContextMenuSubProps: ExpoSwiftUI.ViewProps {}

class ContextMenuSubTriggerProps: ExpoSwiftUI.ViewProps {
    var onSelect = EventDispatcher()
}

class ContextMenuPreviewProps: ExpoSwiftUI.ViewProps {}

class ContextMenuContentProps: ExpoSwiftUI.ViewProps {}

class ContextMenuSubContentProps: ExpoSwiftUI.ViewProps {}

// MARK: - Trigger View
struct ContextMenuTriggerView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuTriggerProps
    
    var body: some View {
        Children()
    }
}

class ContextMenuTriggerProps: ExpoSwiftUI.ViewProps {}

// MARK - group view
struct ContextMenuGroupView: ExpoSwiftUI.View {
    @EnvironmentObject var props: ContextMenuTriggerProps
    
    var body: some View {
        UnwrappedChildren()
    }
}

class ContextMenuGroupProps: ExpoSwiftUI.ViewProps {}

