import styled, { css } from 'styled-components';
import { Colors } from '../../assets/Colors';

const CommonCss = css`
  margin: 0;
  color: ${Colors.black};
`;

export const TextL = styled.p`
  font-size: 37px;
  line-height: 50px;
  font-weight: bold;
  letter-spacing: 2px;
  ${CommonCss}
`;

export const TextM = styled.p`
  font-size: 25px;
  line-height: 30px;
  ${CommonCss}
`;

export const TextS = styled.p`
  font-size: 18px;
  line-height: 20px;
  ${CommonCss}
`;
