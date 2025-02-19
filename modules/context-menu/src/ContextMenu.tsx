import { requireNativeView } from "expo";
import { Fragment } from "react";
import { NativeSyntheticEvent } from "react-native";

const name = "Zeego";

const ContextMenuTrigger = requireNativeView(name, "ContextMenuTriggerView");
const _ContextMenu = requireNativeView(name, "ContextMenuView");
const ContextMenuPreview = requireNativeView(name, "ContextMenuPreviewView");
const ContextMenuItem = requireNativeView(name, "ContextMenuItemView");
const ContextMenuAccessory = requireNativeView(
  name,
  "ContextMenuAccessoryView"
);
const ContextMenuSeparator = requireNativeView(
  name,
  "ContextMenuSeparatorView"
);
const ContextMenuItemIcon = requireNativeView(name, "ContextMenuItemIconView");
const _ContextMenuCheckboxItem = requireNativeView(
  name,
  "ContextMenuCheckboxItemView"
);
const _ContextMenuItemTitle = requireNativeView(
  name,
  "ContextMenuItemTitleView"
);
const _ContextMenuItemSubtitle = requireNativeView(
  name,
  "ContextMenuItemSubtitleView"
);
const ContextMenuSub = requireNativeView(name, "ContextMenuSubView");
const ContextMenuSubTrigger = requireNativeView(
  name,
  "ContextMenuSubTriggerView"
);
const _ContextMenuLabel = requireNativeView(name, "ContextMenuLabelView");
const ContextMenuGroup = requireNativeView(name, "ContextMenuGroupView");
const ContextMenuContent = requireNativeView(name, "ContextMenuContentView");
const ContextMenuSubContent = requireNativeView(
  name,
  "ContextMenuSubContentView"
);

function ContextMenuLabel(props: { children: React.ReactNode }) {
  return (
    <_ContextMenuLabel
      text={typeof props.children === "string" ? props.children : undefined}
    />
  );
}

function ContextMenuCheckboxItem(props: {
  value: "on" | "off" | "mixed" | boolean;
  textValue?: string;
  onValueChange: (value: "on" | "off") => void;
  children: React.ReactNode;
}) {
  return (
    <_ContextMenuCheckboxItem
      value={
        typeof props.value === "boolean"
          ? props.value
            ? "on"
            : "off"
          : props.value
      }
      onValueChange={(e: NativeSyntheticEvent<{ value: "on" | "off" }>) => {
        props.onValueChange(e.nativeEvent.value);
      }}
      textValue={props.textValue}
    >
      {props.children}
    </_ContextMenuCheckboxItem>
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

let ContextMenu = _ContextMenu;

export {
  ContextMenuTrigger,
  ContextMenu,
  ContextMenuPreview,
  ContextMenuItem,
  ContextMenuAccessory,
  ContextMenuSeparator,
  ContextMenuItemIcon,
  ContextMenuCheckboxItem,
  ContextMenuItemTitle,
  ContextMenuItemSubtitle,
  ContextMenuSub,
  ContextMenuSubTrigger,
  ContextMenuContent,
  ContextMenuSubContent,
  ContextMenuLabel,
  ContextMenuGroup,
};
