import { requireNativeView } from "expo";

const ContextMenuTrigger = requireNativeView("ContextMenuTrigger");
const ContextMenu = requireNativeView("ContextMenu");
const ContextMenuPreview = requireNativeView("ContextMenuPreview");
const ContextMenuItem = requireNativeView("ContextMenuItem");
const ContextMenuAccessory = requireNativeView("ContextMenuAccessory");
const _ContextMenuItemTitle = requireNativeView("ContextMenuItemTitle");

function ContextMenuItemTitle(props: { children: string | React.ReactNode }) {
  return (
    <_ContextMenuItemTitle
      text={typeof props.children === "string" ? props.children : undefined}
    />
  );
}

export {
  ContextMenuTrigger,
  ContextMenu,
  ContextMenuPreview,
  ContextMenuItem,
  ContextMenuAccessory,
  ContextMenuItemTitle,
};
