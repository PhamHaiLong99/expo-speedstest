import * as React from 'react';

import { ExpoSpeedstestViewProps } from './ExpoSpeedstest.types';

export default function ExpoSpeedstestView(props: ExpoSpeedstestViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
