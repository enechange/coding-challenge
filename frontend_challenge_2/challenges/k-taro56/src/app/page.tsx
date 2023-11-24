'use client';

import styled from '@emotion/styled';

import SimulationFormContainer from '@/containers/simulation-form';

const Container = styled.div`
  margin-left: auto;
  margin-right: auto;

  // The following media queries are inspired by the Container class in Tailwind CSS.
  // They set the maximum width of the container at different viewport sizes.
  @media (min-width: 640px) {
    /* sm */
    max-width: 640px;
  }

  @media (min-width: 768px) {
    /* md */
    max-width: 768px;
  }

  @media (min-width: 1024px) {
    /* lg */
    max-width: 1024px;
  }

  @media (min-width: 1280px) {
    /* xl */
    max-width: 1280px;
  }

  @media (min-width: 1536px) {
    /* 2xl */
    max-width: 1536px;
  }

  align-items: center;
  justify-content: center;

  @media (min-width: 640px) {
    padding-top: 0;
    padding-bottom: 1.5rem;
    padding-right: 1.5rem;
    padding-left: 1.5rem;
  }
  @media (min-width: 1024px) {
    padding-top: 0;
    padding-bottom: 2rem;
    padding-right: 2rem;
    padding-left: 2rem;
  }
`;

const Home = () => {
  return (
    <Container>
      <SimulationFormContainer />
    </Container>
  );
};

export default Home;
