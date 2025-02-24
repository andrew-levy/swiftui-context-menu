import { requireNativeView } from "expo";
import { NativeSyntheticEvent } from "react-native";

const name = "Zeego";

const ContextMenuTrigger = requireNativeView(name, "ContextMenuTriggerView");
const ContextMenu = requireNativeView(name, "ContextMenuView");
const _ContextMenuPreview = requireNativeView(name, "ContextMenuPreviewView");
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
  let text = typeof props.children === "string" ? props.children : "";

  if (Array.isArray(props.children)) {
    /**
     * Support: <ContextMenuItemTitle>Some text: {someVariable}</ContextMenuItemTitle>
     *
     * React turns the above into ["Some text: ", someVariable]
     */
    for (let i = 0; i < props.children.length; i++) {
      const child = props.children[i];
      if (typeof child === "string" || typeof child === "number") {
        text += child;
      }
    }
  }

  if (!text) return null;

  return <_ContextMenuItemTitle text={text || undefined} />;
}

function ContextMenuItemSubtitle(props: {
  children: string | React.ReactNode;
}) {
  let text = typeof props.children === "string" ? props.children : "";

  if (Array.isArray(props.children)) {
    /**
     * Support: <ContextMenuItemTitle>Some text: {someVariable}</ContextMenuItemTitle>
     *
     * React turns the above into ["Some text: ", someVariable]
     */
    for (let i = 0; i < props.children.length; i++) {
      const child = props.children[i];
      if (typeof child === "string" || typeof child === "number") {
        text += child;
      }
    }
  }

  if (!text) {
    console.warn(
      "[zeego][ContextMenuItemSubtitle] You did not pass any text children to the subtitle component. Was this intentional? It will be hidden on iOS."
    );
    return null;
  }

  return <_ContextMenuItemSubtitle text={text} />;
}

function ContextMenuPreview(props: { children: React.ReactNode }) {
  return (
    <_ContextMenuPreview
      style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        zIndex: -1,
        height: 0,
        width: 0,
      }}
    >
      {props.children}
    </_ContextMenuPreview>
  );
}

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
