import React, { useState, useEffect } from "react";
import {
  ScrollView,
  Text,
  StyleSheet,
  TouchableWithoutFeedback,
  View,
} from "react-native";

const ReactionsView = () => {
  const reactions = ["👍", "❤️", "😂", "😮", "😢", "👎"];

  return (
    <View style={[styles.container]}>
      <ScrollView horizontal showsHorizontalScrollIndicator={false}>
        {reactions.map((reaction) => {
          return (
            <TouchableWithoutFeedback
              key={reaction}
              onPress={() => {
                console.log(`You reacted with ${reaction}`);
              }}
            >
              <View style={[styles.reactionContainer]}>
                <Text style={styles.reactionText}>{reaction}</Text>
              </View>
            </TouchableWithoutFeedback>
          );
        })}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: "rgba(128, 128, 128, 0.9)", // Gray background
    borderRadius: 40,
    paddingVertical: 8,
    marginHorizontal: 16,
    height: 70,
    top: -50,
    left: -15,
  },
  scrollContainer: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 10,
  },
  reactionContainer: {
    marginHorizontal: 7.5,
    padding: 10,
    borderRadius: 50,
    shadowColor: "black",
    shadowOpacity: 0.2,
    shadowRadius: 4,
    shadowOffset: { width: 0, height: 2 },
  },
  reactionText: {
    fontSize: 24,
    textAlign: "center",
  },
});

export default ReactionsView;
