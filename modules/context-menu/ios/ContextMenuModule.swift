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
    View(ContextMenuItemView.self)
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
