import type { NextConfig } from "next";

const isProduction = process.env.NODE_ENV === "production";
const isGitHubPages = process.env.GITHUB_PAGES === "true";

const nextConfig: NextConfig = {
  // GitHub Pages deployment settings
  output: "export",
  trailingSlash: true,
  images: {
    unoptimized: true, // For static export
  },
  // GitHub Pages subdirectory deployment (only in production for GitHub Pages)
  ...(isProduction &&
    isGitHubPages && {
      basePath: "/e-coding-challenge",
      assetPrefix: "/e-coding-challenge/",
    }),
};

export default nextConfig;
