#!/bin/bash

set -e

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No color

# Function to check if a package is installed
function check_package_installed {
  if [ ! -d "node_modules/$1" ]; then
    return 1
  fi
  return 0
}

# Function to update outdated packages
function update_packages {
  printf "${YELLOW}Updating packages...${NC}\n"
  outdated_packages=$(npm outdated --json)
  if [ "$outdated_packages" != "null" ]; then
    npm update
    printf "${GREEN}Packages updated successfully!${NC}\n"
  else
    printf "${GREEN}All packages are up to date.${NC}\n"
  fi
}

# Function to install missing packages
function install_packages {
  printf "${YELLOW}Installing packages...${NC}\n"
  npm ci
  printf "${GREEN}Packages installed successfully!${NC}\n"
}

# Function to fix vulnerabilities
function fix_vulnerabilities {
  printf "${YELLOW}Fixing vulnerabilities...${NC}\n"
  vulnerabilities=$(npm audit --json | jq '.metadata.vulnerabilities."high"')
  if [ "$vulnerabilities" -gt 0 ]; then
    npm audit fix --force
    printf "${GREEN}Vulnerabilities fixed successfully!${NC}\n"
  else
    printf "${GREEN}No vulnerabilities found.${NC}\n"
  fi
}

# Function to run security audit
function run_audit {
  printf "${YELLOW}Running security audit...${NC}\n"
  npm audit
}

# Function to remove node_modules directory
function remove_node_modules {
  printf "${YELLOW}Removing node_modules directory...${NC}\n"
  rm -rf node_modules
  printf "${GREEN}node_modules directory removed successfully!${NC}\n"
}

# Function to run npm fund
function run_fund {
  printf "${YELLOW}Running npm fund...${NC}\n"
  funding=$(npm fund --json | jq '.length')
  if [ "$funding" -gt 0 ]; then
    npm fund
    printf "${GREEN}npm fund executed successfully!${NC}\n"
  else
    printf "${GREEN}No packages looking for funding.${NC}\n"
  fi
}

# Function to clean up unused dependencies
function cleanup_dependencies {
  printf "${YELLOW}Cleaning up unused dependencies...${NC}\n"
  npm prune
  printf "${GREEN}Unused dependencies removed successfully!${NC}\n"
}

# Function to remove unused code using ESLint
function remove_unused_code {
  printf "${YELLOW}Removing unused code using ESLint...${NC}\n"
  npx eslint --fix src/
  printf "${GREEN}Unused code removed successfully!${NC}\n"
}

# Function to remove unnecessary files and folders
function remove_unnecessary_files {
  printf "${YELLOW}Removing unnecessary files and folders...${NC}\n"
  rm -rf public/
  rm -rf coverage/
  rm -rf .vscode/
  rm -rf .github/
  rm -rf .eslintcache
  printf "${GREEN}Unnecessary files and folders removed successfully!${NC}\n"
}

# Function to optimize images
function optimize
