const repoName = process.env.REPO_NAME || '';

/** @type {import('next').NextConfig} */
const nextConfig = {
  basePath: `/${repoName}`,
  assetPrefix: `/${repoName}/`,
  output: 'export',
};

module.exports = nextConfig;
