import { requireNativeView } from "expo";
import { Fragment } from "react";
import { NativeSyntheticEvent } from "react-native";

const name = "ContextMenu";

const ContextMenuTrigger = requireNativeView(name, "ContextMenuTrigger");
const _ContextMenu = requireNativeView(name, "ContextMenu");
const ContextMenuPreview = requireNativeView(name, "ContextMenuPreview");
const ContextMenuItem = requireNativeView(name, "ContextMenuItem");
const ContextMenuAccessory = requireNativeView(name, "ContextMenuAccessory");
const ContextMenuSeparator = requireNativeView(name, "ContextMenuSeparator");
const ContextMenuItemIcon = requireNativeView(name, "ContextMenuItemIcon");
const _ContextMenuCheckboxItem = requireNativeView(
  name,
  "ContextMenuCheckboxItem"
);
const _ContextMenuItemTitle = requireNativeView(name, "ContextMenuItemTitle");
const _ContextMenuItemSubtitle = requireNativeView(
  name,
  "ContextMenuItemSubtitle"
);
const ContextMenuSub = requireNativeView(name, "ContextMenuSub");
const ContextMenuSubTrigger = requireNativeView(name, "ContextMenuSubTrigger");
const _ContextMenuLabel = requireNativeView(name, "ContextMenuLabel");
const ContextMenuGroup = requireNativeView(name, "ContextMenuGroup");

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

const ContextMenuContent = (props: { children: React.ReactNode }) => {
  return <Fragment>{props.children}</Fragment>;
};

const ContextMenuSubContent = (props: { children: React.ReactNode }) => {
  return <Fragment>{props.children}</Fragment>;
};

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
