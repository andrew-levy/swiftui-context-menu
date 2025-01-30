import { requireNativeView } from "expo";
import {
  cloneElement,
  createContext,
  Fragment,
  useContext,
  useEffect,
  useReducer,
  useRef,
} from "react";
import { NativeSyntheticEvent } from "react-native";

const WrapElementForDev = <E extends React.ComponentType>(E: E) => {
  if (__DEV__ && false) {
    // it doesn't work
    const Component = function Component(props: React.ComponentProps<E>) {
      const prevProps = useRef(props);
      const menuDevContext = useTriggerFastRefresh();
      useEffect(() => {
        let didChange = false;
        for (const key in props) {
          if (props[key] !== prevProps.current[key]) {
            didChange = true;
            break;
          }
        }
        if (didChange) {
          menuDevContext?.();
        }
        prevProps.current = props;
      }, Object.values(props));
      return (
        <MenuDevContext.Provider value={() => {}}>
          <E {...(props as any)} />
        </MenuDevContext.Provider>
      );
    };

    Component.displayName = `Zeego.${E.displayName || E.name}`;

    return Component as E;
  }

  return E;
};

const ContextMenuTrigger = WrapElementForDev(
  requireNativeView("ContextMenuTrigger")
);
const _ContextMenu = WrapElementForDev(requireNativeView("ContextMenu"));
const ContextMenuPreview = WrapElementForDev(
  requireNativeView("ContextMenuPreview")
);
const ContextMenuItem = WrapElementForDev(requireNativeView("ContextMenuItem"));
const ContextMenuAccessory = WrapElementForDev(
  requireNativeView("ContextMenuAccessory")
);
const ContextMenuSeparator = WrapElementForDev(
  requireNativeView("ContextMenuSeparator")
);
const ContextMenuItemIcon = WrapElementForDev(
  requireNativeView("ContextMenuItemIcon")
);
const _ContextMenuCheckboxItem = WrapElementForDev(
  requireNativeView("ContextMenuCheckboxItem")
);
const _ContextMenuItemTitle = WrapElementForDev(
  requireNativeView("ContextMenuItemTitle")
);
const _ContextMenuItemSubtitle = WrapElementForDev(
  requireNativeView("ContextMenuItemSubtitle")
);
const ContextMenuSub = WrapElementForDev(requireNativeView("ContextMenuSub"));
const ContextMenuSubTrigger = WrapElementForDev(
  requireNativeView("ContextMenuSubTrigger")
);
const _ContextMenuLabel = WrapElementForDev(
  requireNativeView("ContextMenuLabel")
);
const ContextMenuGroup = WrapElementForDev(
  requireNativeView("ContextMenuGroup")
);

const MenuDevContext = createContext(() => {});
const useTriggerFastRefresh = () =>
  __DEV__ ? null : useContext(MenuDevContext);

const FastRefreshProvider = (props: { children: React.ReactElement }) => {
  const [key, increment] = useReducer((x) => x + 1, 0);
  return (
    <MenuDevContext.Provider value={increment}>
      {cloneElement(props.children, { key })}
    </MenuDevContext.Provider>
  );
};

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

if (__DEV__) {
  ContextMenu = function ContextMenuForDev(props) {
    return (
      <FastRefreshProvider>
        <_ContextMenu {...props} />
      </FastRefreshProvider>
    );
  };
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
