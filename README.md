# 🛠️ System Taiyaar 🚀

**System Taiyaar** is a complete setup toolkit for automating the configuration of development environments on **Ubuntu** 🐧 and **macOS** .

Whether you're setting up a new system, reinstalling an OS, or configuring multiple machines for robotics or development work, **System Taiyaar** gets you productive — fast and clean.

---

## ⚙️ Features & Project Structure

This project is logically divided into modules, each designed to configure a specific aspect of your system:

- ⚡ **Bootup**: Essential system bootup scripts. Includes install scripts tailored for basic tools, system updates, and cleanup.
- 🐍 **conda_env**: Standardized environment definition files (`ros.yml`, `ros2.yml`) for setting up legacy Conda environments.
- 🐳 **Docker**: Pre-configured Dockerfiles and environments layout to get containerized development environments up and running quickly.
- 🐍 **py**: Python utility scripts designed to assist with system configurations and routine automated tasks.
- 💻 **rc files**: Ready-to-use configuration dotfiles for your terminal (`.bashrc`, `.zshrc`, `aliases`) for maximum productivity.
- 🤖 **robostack**: Setup guides and configurations for installing ROS distributions cleanly via Robostack.
- 📦 **Pixi**: Integrating support for `pixi` configurations to replace or complement traditional Conda environments.

---

## ⚡ Bootup Scripts
```bash
Bootup/install.sh # Installs essential tools
Bootup/update.sh  # Updates packages and system
Bootup/clean.sh   # Removes unnecessary clutter
```

---

## 📦 Pixi Configuration

For detailed documentation, please refer to the official [RoboStack Getting Started Guide](https://robostack.github.io/GettingStarted.html).

### How to use Pixi:

1. **Install Pixi**:
   ```bash
   curl -fsSL https://pixi.sh/install.sh | bash
   ```
2. **Initialize a new Pixi project**:
   ```bash
   pixi init robostack
   cd robostack
   ```
3. **Add Dependencies** (Optional):
   ```bash
   pixi add python
   pixi add ros-humble-desktop
   ```
4. **Install the Environment**:
   ```bash
   pixi install
   ```
5. **Run a Command Directly** (without entering shell):
   ```bash
   pixi shell -e humble
   ```

---

You can refer to the alias to initialize ros2 [here](rc%20files/.zsh_aliases#L8)

## 🐍 Conda Setup (Alternative)
```bash
conda env create -f conda_env/ros.yml
conda env create -f conda_env/ros2.yml
```

---

## 🙋‍♂️ About the Author

[Shrikar Nakhye](https://www.linkedin.com/in/shrikar-n-053262188/)

🎓 M.Sc. Autonomous Systems | Robotics & Automation Enthusiast

📍 Bonn, Germany

📧 [nakhyeshrikar@icloud.com](mailto:nakhyeshrikar@icloud.com)

---

## 🤝 Contributing

Contributions, suggestions, or new install ideas are welcome!
Feel free to fork the repo and open a pull request.
