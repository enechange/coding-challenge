import React, { FC } from 'react';
import { IconProps, XML_NAME_SPACE } from '@/js/types/Icon';

const d1 = 'M24 24H0V0h24v24z';
const d2 = 'M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6-1.41-1.41z';

const More: FC<IconProps> = ({ color = '#000', height = 24, width = 24 }) => (
  <svg
    xmlns={XML_NAME_SPACE}
    height={height}
    viewBox="0 0 24 24"
    width={width}
    fill={color}
  >
    <path d={d1} fill="none" />
    <path d={d2} />
  </svg>
);

export default More;
