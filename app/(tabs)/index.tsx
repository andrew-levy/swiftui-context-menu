import {
  Image,
  StyleSheet,
  ScrollView as ParallaxScrollView,
  Text as ThemedText,
} from "react-native";
import Reactions from "@/components/Reactions";
import {
  ContextMenu,
  ContextMenuTrigger,
  ContextMenuItem,
  ContextMenuAccessory,
  ContextMenuPreview,
  ContextMenuItemTitle,
  ContextMenuItemSubtitle,
  ContextMenuSeparator,
  ContextMenuCheckboxItem,
  ContextMenuSub,
  ContextMenuSubTrigger,
  ContextMenuItemIcon,
  ContextMenuLabel,
  ContextMenuGroup,
  ContextMenuContent,
} from "@/modules/context-menu";
import { useState } from "react";

export default function HomeScreen() {
  const [checked, setChecked] = useState<"on" | "off">("on");
  const [darkMode, setDarkMode] = useState<"on" | "off">("off");
  return (
    <ParallaxScrollView style={{ paddingVertical: 100 }}>
      <ThemedText style={{ padding: 10 }}>is on : {checked}</ThemedText>
      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>With Accessory</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuItem>
          <ContextMenuItemTitle>Hello from children</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
        </ContextMenuItem>
        <ContextMenuSeparator />
        <ContextMenuItem>
          <ContextMenuItemTitle>Hello from children 2</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
        </ContextMenuItem>
        <ContextMenuAccessory>
          <Reactions />
        </ContextMenuAccessory>
      </ContextMenu>

      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>
            Basic (isOn: {checked})
          </ThemedText>
        </ContextMenuTrigger>
        <ContextMenuItem destructive={true}>
          <ContextMenuItemTitle>Basic Item 2</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
        </ContextMenuItem>
        <ContextMenuSeparator />
        <ContextMenuCheckboxItem
          value={checked}
          onValueChange={(v) => {
            console.log("onValueChange", v);
            setChecked(v);
          }}
        >
          <ContextMenuItemTitle>Checkbox Item</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
        </ContextMenuCheckboxItem>
        <ContextMenuItem>
          <ContextMenuItemIcon name='person.fill' />
          <ContextMenuItemTitle>Basic Item 2</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
        </ContextMenuItem>
      </ContextMenu>

      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>Groups!!</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuGroup label='Group hi!'>
          <ContextMenuItem>
            <ContextMenuItemTitle>Group Item 1</ContextMenuItemTitle>
            <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
          </ContextMenuItem>
          <ContextMenuItem>
            <ContextMenuItemTitle>Group Item 2</ContextMenuItemTitle>
            <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
          </ContextMenuItem>
        </ContextMenuGroup>
        <ContextMenuGroup label='Group 2' horizontal>
          <ContextMenuItem>
            <ContextMenuItemTitle>Group Item 3</ContextMenuItemTitle>
            <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
          </ContextMenuItem>
          <ContextMenuItem>
            <ContextMenuItemTitle>Group Item 4</ContextMenuItemTitle>
            <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
          </ContextMenuItem>
        </ContextMenuGroup>
      </ContextMenu>

      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>
            Complex Submenu Example!
          </ThemedText>
        </ContextMenuTrigger>

        <ContextMenuContent>
          <ContextMenuLabel>Label here!!!</ContextMenuLabel>

          <ContextMenuItem onSelect={() => console.log("main item")}>
            <ContextMenuItemTitle>Main Menu Item</ContextMenuItemTitle>
            <ContextMenuItemSubtitle>With a subtitle</ContextMenuItemSubtitle>
          </ContextMenuItem>

          <ContextMenuSeparator />

          <ContextMenuSub>
            <ContextMenuSubTrigger onSelect={() => console.log("hi")}>
              <ContextMenuItemTitle>Advanced Options</ContextMenuItemTitle>
              <ContextMenuItemSubtitle>
                Click for more...
              </ContextMenuItemSubtitle>
            </ContextMenuSubTrigger>

            <ContextMenuItem onSelect={() => console.log("sub item 1")}>
              <ContextMenuItemTitle>Submenu Item 1</ContextMenuItemTitle>
            </ContextMenuItem>

            <ContextMenuCheckboxItem
              value={checked}
              onValueChange={(v) => {
                console.log("submenu checkbox changed:", v);
                setChecked(v);
              }}
            >
              <ContextMenuItemTitle>Submenu Checkbox</ContextMenuItemTitle>
              <ContextMenuItemSubtitle>Uses main state</ContextMenuItemSubtitle>
            </ContextMenuCheckboxItem>

            <ContextMenuItem destructive onSelect={() => console.log("delete")}>
              <ContextMenuItemTitle>Delete Something</ContextMenuItemTitle>
            </ContextMenuItem>
          </ContextMenuSub>
        </ContextMenuContent>
      </ContextMenu>

      <ContextMenu isDropdown>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>Dropdown Menu</ThemedText>
        </ContextMenuTrigger>

        <ContextMenuContent>
          <ContextMenuItem>
            <ContextMenuItemTitle>!!</ContextMenuItemTitle>
          </ContextMenuItem>
        </ContextMenuContent>
      </ContextMenu>

      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>With Preview</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuPreview
          style={{
            width: 400,
            height: 400,
            alignItems: "flex-start",
            justifyContent: "flex-start",
            backgroundColor: "red",
          }}
        >
          <ThemedText style={{ padding: 10 }}>
            This is the preview content
          </ThemedText>
        </ContextMenuPreview>
        <ContextMenuItem>
          <ContextMenuItemTitle>With Preview Item 1</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
        </ContextMenuItem>
        <ContextMenuSeparator />
        <ContextMenuCheckboxItem
          value={darkMode}
          onValueChange={(v) => {
            console.log("onValueChange", v);
            setDarkMode(v);
          }}
        >
          <ContextMenuItemTitle>Dark Mode: {darkMode}</ContextMenuItemTitle>
        </ContextMenuCheckboxItem>
        <ContextMenuItem>
          <ContextMenuItemTitle>With Preview Item 2</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
        </ContextMenuItem>
        <ContextMenuSub>
          <ContextMenuSubTrigger>
            <ContextMenuItemTitle>Sub Menu</ContextMenuItemTitle>
          </ContextMenuSubTrigger>

          <ContextMenuItem>
            <ContextMenuItemTitle>
              Hey look i'm a sub menu item
            </ContextMenuItemTitle>
          </ContextMenuItem>
        </ContextMenuSub>
      </ContextMenu>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },
  stepContainer: {
    gap: 8,
    marginBottom: 8,
  },
  reactLogo: {
    height: 178,
    width: 290,
    bottom: 0,
    left: 0,
    position: "absolute",
  },
});
