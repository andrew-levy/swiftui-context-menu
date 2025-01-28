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
} from "@/modules/context-menu";

export default function HomeScreen() {
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
      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>With Accessory</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuItem>
          <ContextMenuItemTitle>Hello from children</ContextMenuItemTitle>
          <ContextMenuItemSubtitle>Subtitle here!</ContextMenuItemSubtitle>
        </ContextMenuItem>
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
          <ThemedText style={{ padding: 10 }}>Basic</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuItem text='item 3' />
        <ContextMenuItem text='item 4' />
      </ContextMenu>

      <ContextMenu>
        <ContextMenuTrigger>
          <ThemedText style={{ padding: 10 }}>With Preview</ThemedText>
        </ContextMenuTrigger>
        <ContextMenuItem text='item 5' />
        <ContextMenuItem text='item 6' />
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
