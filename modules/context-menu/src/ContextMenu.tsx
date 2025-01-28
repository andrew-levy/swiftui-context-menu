import { requireNativeView } from "expo";

const ContextMenuTrigger = requireNativeView("ContextMenuTrigger");
const ContextMenu = requireNativeView("ContextMenu");
const ContextMenuPreview = requireNativeView("ContextMenuPreview");
const ContextMenuItem = requireNativeView("ContextMenuItem");
const ContextMenuAccessory = requireNativeView("ContextMenuAccessory");

export {
  ContextMenuTrigger,
  ContextMenu,
  ContextMenuPreview,
  ContextMenuItem,
  ContextMenuAccessory,
};
