import { Image, StyleSheet } from "react-native";
import ParallaxScrollView from "@/components/ParallaxScrollView";
import { ThemedText } from "@/components/ThemedText";
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
} from "@/modules/context-menu";
import { useState } from "react";

export default function HomeScreen() {
  const [checked, setChecked] = useState<"on" | "off">("on");
  const [darkMode, setDarkMode] = useState("off");
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: "#A1CEDC", dark: "#1D3D47" }}
      headerImage={
        <Image
          source={require("@/assets/images/partial-react-logo.png")}
          style={styles.reactLogo}
        />
      }
    >
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
          <ContextMenuItemTitle>Basic Item 1</ContextMenuItemTitle>
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
          <ContextMenuItemTitle>Basic Item 2</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
        </ContextMenuItem>
      </ContextMenu>

      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>With Preview</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuItem>
          <ContextMenuItemTitle>With Preview Item 1</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
        </ContextMenuItem>
        <ContextMenuSeparator />
        <ContextMenuCheckboxItem
          value={darkMode}
          text={"Dark Mode"}
          onValueChange={(v) => {
            console.log("onValueChange", v);
            setDarkMode(v ? `on` : `off`);
          }}
        />
        <ContextMenuItem>
          <ContextMenuItemTitle>With Preview Item 2</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle there...</ContextMenuItemSubtitle>
        </ContextMenuItem>
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
