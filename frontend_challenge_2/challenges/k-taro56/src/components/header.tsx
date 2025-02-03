import styled from '@emotion/styled';
import React from 'react';

type HeaderProps = {
  title: string;
  subTitle: string;
};

const HeaderStyle = styled.header`
  text-align: center;
  margin: 1.5rem;
`;

const Title = styled.h1`
  font-size: 1.5rem;
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
    <Title>
      <MultiLineText text={title} />
    </Title>
    <div>
      <MultiLineText text={subTitle} />
    </div>
  </HeaderStyle>
);

export default Header;
