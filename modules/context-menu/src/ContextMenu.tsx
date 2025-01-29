import { requireNativeView } from "expo";
import { NativeSyntheticEvent } from "react-native";

const ContextMenuTrigger = requireNativeView("ContextMenuTrigger");
const ContextMenu = requireNativeView("ContextMenu");
const ContextMenuPreview = requireNativeView("ContextMenuPreview");
const ContextMenuItem = requireNativeView("ContextMenuItem");
const ContextMenuAccessory = requireNativeView("ContextMenuAccessory");
const ContextMenuSeparator = requireNativeView("ContextMenuSeparator");
const _ContextMenuCheckboxItem = requireNativeView("ContextMenuCheckboxItem");
const _ContextMenuItemTitle = requireNativeView("ContextMenuItemTitle");
const _ContextMenuItemSubtitle = requireNativeView("ContextMenuItemSubtitle");

function ContextMenuCheckboxItem(props: {
  value: string;
  text: string;
  onValueChange: (value: string) => void;
}) {
  return (
    <_ContextMenuCheckboxItem
      value={props.value}
      text={props.text}
      onValueChange={(e: NativeSyntheticEvent<{ value: string }>) => {
        props.onValueChange(e.nativeEvent.value);
      }}
    />
  );
}

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
  ContextMenuSeparator,
  ContextMenuCheckboxItem,
  ContextMenuItemTitle,
  ContextMenuItemSubtitle,
};
