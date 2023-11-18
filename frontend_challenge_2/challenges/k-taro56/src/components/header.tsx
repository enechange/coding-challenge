import styled from '@emotion/styled';
import React from 'react';

type HeaderProps = {
  title: string;
  subTitle: string;
};

const HeaderStyle = styled.header`
  text-align: center;
`;

const Title = styled.h1`
  color: #333;
`;

const SubTitle = styled.p`
  color: #666;
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
    <SubTitle>
      <MultiLineText text={subTitle} />
    </SubTitle>
  </HeaderStyle>
);

export default Header;
