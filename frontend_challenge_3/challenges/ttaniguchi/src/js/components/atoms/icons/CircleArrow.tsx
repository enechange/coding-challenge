import React, { FC } from 'react';
import { IconProps, XML_NAME_SPACE } from '@/js/types/Icon';

const d =
  'M15.08,9.59L12,12.67L8.92,9.59L7.5,11l4.5,4.5l4.5-4.5L15.08,9.59z M12,2C6.48,2,2,6.48,2,12c0,5.52,4.48,10,10,10 s10-4.48,10-10C22,6.48,17.52,2,12,2z M12,20c-4.42,0-8-3.58-8-8s3.58-8,8-8s8,3.58,8,8S16.42,20,12,20z';

const CircleArrow: FC<IconProps> = ({
  color = '#000',
  height = 24,
  width = 24,
}) => (
  <svg
    xmlns={XML_NAME_SPACE}
    enableBackground="new 0 0 24 24"
    height={height}
    viewBox="0 0 24 24"
    width={width}
    fill={color}
  >
    <rect fill="none" height="24" width="24" />
    <path d={d} />
  </svg>
);

export default CircleArrow;
