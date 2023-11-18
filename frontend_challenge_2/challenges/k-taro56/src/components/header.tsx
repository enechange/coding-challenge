import styled from '@emotion/styled';
import React from 'react';

type HeaderProps = {
  title: string;
  subTitle: string;
};

const HeaderStyle = styled.header`
  text-align: center;
`;

const MultiLineText = ({ text }: { text: string }) =>
  text.split('\\n').map((line, i) => (
    <span key={i}>
      {line}
      <br />
    </span>
  ));

const Header = ({ title, subTitle }: HeaderProps) => (
  <HeaderStyle>
    <h1>
      <MultiLineText text={title} />
    </h1>
    <p>
      <MultiLineText text={subTitle} />
    </p>
  </HeaderStyle>
);

export default Header;
