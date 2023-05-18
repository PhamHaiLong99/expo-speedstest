import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoSpeedstestViewProps } from './ExpoSpeedstest.types';

const NativeView: React.ComponentType<ExpoSpeedstestViewProps> =
  requireNativeViewManager('ExpoSpeedstest');

export default function ExpoSpeedstestView(props: ExpoSpeedstestViewProps) {
  return <NativeView {...props} />;
}
