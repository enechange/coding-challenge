import React, { FC } from 'react';
import { IconProps, XML_NAME_SPACE } from '@/js/types/Icon';

const d = 'M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z';

const Warning: FC<IconProps> = ({
  color = '#000',
  height = 24,
  width = 24,
}) => (
  <svg
    xmlns={XML_NAME_SPACE}
    height={height}
    viewBox="0 0 24 24"
    width={width}
    fill={color}
  >
    <path d={d} />
  </svg>
);

export default Warning;
