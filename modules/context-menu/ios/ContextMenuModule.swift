import ExpoModulesCore
import SwiftUI

public class ContextMenuAccessoryModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuAccessory")
      View(ContextMenuAccessoryView.self)
  }
}

public class ContextMenuPreviewModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuPreview")
    View(ContextMenuPreviewView.self)
  }
}

public class ContextMenuItemModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuItem")
      View(ContextMenuItemView.self) {
          Events("onSelect")
          Prop("textContent") { (view, textContent: String) in
              view.textContent = textContent
          }
          Prop("destructive") { (view, destructive: Bool) in
              view.destructive = destructive
          }
      }
  }
}

public class ContextMenuTriggerModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuTrigger")
    View(ContextMenuTriggerView.self) {
      
    }
  }
}

public class ContextMenuModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenu")
    View(ContextMenuView.self)
  }
}

public class ContextMenuItemTitleModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuItemTitle")
    View(ContextMenuItemTitleView.self) {
      Prop("text") { (view, text: String) in
        view.text = text
      }
    }
  }
}

public class ContextMenuItemSubtitleModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuItemSubtitle")
    View(ContextMenuItemSubtitleView.self) {
      Prop("text") { (view, text: String) in
        view.text = text
      }
    }
  }
}

public class ContextMenuLabelModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuLabel")
    View(ContextMenuLabelView.self) {
      Prop("text") { (view, text: String) in
        view.text = text
      }
    }
  }
}

public class ContextMenuSeparatorModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuSeparator")
    View(ContextMenuSeparatorView.self) {
      
    }
  }
}

public class ContextMenuCheckboxItemModule: Module {
  public func definition() -> ModuleDefinition {
        Name("ContextMenuCheckboxItem")
        View(ContextMenuCheckboxItemView.self) {
            Events("onValueChange")
            Prop("textContent") { (view, textContent: String) in
                view.textContent = textContent
            }
            Prop("value") { (view, value: String) in
                view.value = value
            }
            Prop("destructive") { (view, destructive: Bool?) in
                view.destructive = destructive
            }
        }
  }
}


public class ContextMenuItemIconModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ContextMenuItemIcon")
    View(ContextMenuItemIconView.self) {
      Prop("name") { (view, name: String) in
        view.name = name
      }
    }
  }
}
