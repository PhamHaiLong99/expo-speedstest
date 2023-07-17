import { StyleSheet, Text, View } from 'react-native';
import * as React from 'react';
import * as ExpoSpeedstest from 'expo-speedstest';

export default function App() {
  const [downloadSpeed, setDownloadSpeed] = React.useState(0)
  React.useEffect(() => {
    (async () => {
      try {
        console.log("checkInternet here")
        const checkInternet = await ExpoSpeedstest.checkInternet();
        if (checkInternet === "Success") {
          const speed = await ExpoSpeedstest.downloadSpeedTest();
          console.log("downloadSpeedTest is", speed)
          setDownloadSpeed(speed)
        }
      }catch (e) {
        console.log("e.message", e?.message)
        console.log("e.code", e?.code)
        console.error(e)
      }
    })()
  }, []);
  return (
    <View style={styles.container}>
      <Text>Hehe</Text>
      <Text>Download speed is: {downloadSpeed}</Text>
      {/* <Text>{ExpoSpeedstest.hello()}</Text> */}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    rowGap: 20
  },
});
