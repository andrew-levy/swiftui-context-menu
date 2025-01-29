import { requireNativeView } from "expo";
import { Fragment } from "react";
import { NativeSyntheticEvent } from "react-native";

const ContextMenuTrigger = requireNativeView("ContextMenuTrigger");
const ContextMenu = requireNativeView("ContextMenu");
const ContextMenuPreview = requireNativeView("ContextMenuPreview");
const ContextMenuItem = requireNativeView("ContextMenuItem");
const ContextMenuAccessory = requireNativeView("ContextMenuAccessory");
const ContextMenuSeparator = requireNativeView("ContextMenuSeparator");
const ContextMenuItemIcon = requireNativeView("ContextMenuItemIcon");
const _ContextMenuCheckboxItem = requireNativeView("ContextMenuCheckboxItem");
const _ContextMenuItemTitle = requireNativeView("ContextMenuItemTitle");
const _ContextMenuItemSubtitle = requireNativeView("ContextMenuItemSubtitle");
const ContextMenuSub = requireNativeView("ContextMenuSub");
const ContextMenuSubTrigger = requireNativeView("ContextMenuSubTrigger");
const _ContextMenuLabel = requireNativeView("ContextMenuLabel");

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
};
