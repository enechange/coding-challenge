import React, { FC } from 'react';

export type Props = {
  label: string;
};
const Label: FC<Props> = ({ label }) => (
  <h1>
    {label}
  </h1>
);

export default Label;
