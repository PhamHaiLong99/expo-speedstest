import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoSpeedstest.web.ts
// and on native platforms to ExpoSpeedstest.ts
import ExpoSpeedstestModule from './ExpoSpeedstestModule';
import ExpoSpeedstestView from './ExpoSpeedstestView';
import { ChangeEventPayload, ExpoSpeedstestViewProps } from './ExpoSpeedstest.types';

// Get the native constant value.
export const PI = ExpoSpeedstestModule.PI;

export function hello(): string {
  return ExpoSpeedstestModule.hello();
}

export async function setValueAsync(value: string) {
  return await ExpoSpeedstestModule.setValueAsync(value);
}

const emitter = new EventEmitter(ExpoSpeedstestModule ?? NativeModulesProxy.ExpoSpeedstest);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ExpoSpeedstestView, ExpoSpeedstestViewProps, ChangeEventPayload };
