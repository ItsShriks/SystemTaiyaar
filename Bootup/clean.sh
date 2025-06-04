echo -e "\n>>> Running: Homebrew Clean "
brew cleanup -s
brew cleanup
echo "Brew Cleanup completed"

echo -e "\n>>> Autoremoving brew"
brew autoremove
echo "Brew Autoremove completed"

echo -e "\n>>> Running: conda clean --all -y"
conda clean --all -y
