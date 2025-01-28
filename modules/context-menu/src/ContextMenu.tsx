import { requireNativeView } from "expo";

const ContextMenuTrigger = requireNativeView("ContextMenuTrigger");
const ContextMenu = requireNativeView("ContextMenu");
const ContextMenuPreview = requireNativeView("ContextMenuPreview");
const ContextMenuItem = requireNativeView("ContextMenuItem");
const ContextMenuAccessory = requireNativeView("ContextMenuAccessory");
const _ContextMenuItemTitle = requireNativeView("ContextMenuItemTitle");
const _ContextMenuItemSubtitle = requireNativeView("ContextMenuItemSubtitle");

function ContextMenuItemTitle(props: { children: string | React.ReactNode }) {
  return (
    <_ContextMenuItemTitle
      text={typeof props.children === "string" ? props.children : undefined}
    />
  );
}

function ContextMenuItemSubtitle(props: {
  children: string | React.ReactNode;
}) {
  return (
    <_ContextMenuItemSubtitle
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
  ContextMenuItemSubtitle,
};
