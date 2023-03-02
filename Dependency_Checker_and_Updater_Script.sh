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

# Check if packages are installed
if ! check_package_installed "react"; then
  printf "${RED}React is not installed!${NC}\n"
  remove_node_modules
  install_packages
fi

# Check if there are any high severity vulnerabilities
fix_vulnerabilities

# Check if there are any outdated packages
update_packages

# Check if there are any packages looking for funding
run_fund

# Run security audit
run_audit
