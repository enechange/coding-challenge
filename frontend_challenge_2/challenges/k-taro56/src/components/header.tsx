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
  font-size: 1.5rem;
  margin-top: 1.5rem;
  margin-bottom: 1rem;
`;

const SubTitle = styled.div`
  margin-bottom: 1.5rem;
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
