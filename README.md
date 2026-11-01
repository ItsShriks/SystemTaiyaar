# 🛠️ System Taiyaar 🚀 (macOS)

Sets up a fresh Mac and keeps its rc files. This is the **macOS** branch; Linux machines use the [Ubuntu](https://github.com/ItsShriks/SystemTaiyaar/tree/Ubuntu) branch.

---

## ⚡ Quick Start

This detects the OS, clones only the matching branch to `~/SystemTaiyaar`, and opens the menu:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ItsShriks/SystemTaiyaar/macOS/bootstrap.sh)"
```

Or clone it yourself:

```bash
git clone --single-branch --branch macOS https://github.com/ItsShriks/SystemTaiyaar.git ~/SystemTaiyaar
```

---

## ⚙️ Steps

```bash
./setup.sh              # Menu
./setup.sh all          # essentials rc ssh apps docker ros
./setup.sh ssh docker   # Just these steps
```

| Step | Script | What it does |
|---|---|---|
| `essentials` | `Bootup/essentials.sh` | Homebrew (with Xcode tools), git, node, git identity |
| `ssh` | `Bootup/ssh-keygen.sh` | Ed25519 key, shown and copied to the clipboard for you to add to GitHub or GitLab |
| `ros` | `Bootup/ROS.sh` | Pixi and the RoboStack environments in `~/robostack` |
| `clean` | `Bootup/clean.sh` | Homebrew and Conda cleanup, then `npx mac-cleaner-cli` |
| `apps` | `Bootup/install.sh` | Everything in the [Brewfile](Brewfile) |
| `docker` | `Bootup/docker.sh` | Docker Desktop and XQuartz, optional image build |
| `rc` | `Bootup/rc.sh` | Links `rc files/` into `$HOME`, backing up what was there to `~/.system-taiyaar-backup` |
| `update` | `Bootup/update.sh` | Updates Homebrew and Conda packages |

Every step can be re-run safely. `clean` and `update` are not part of `all`.

---

## 📦 Pixi and RoboStack

See the [RoboStack Getting Started Guide](https://robostack.github.io/GettingStarted.html). `./setup.sh ros` asks which environments to install from [pixi.toml](robostack/pixi.toml), then you activate them with the aliases in [.zsh_aliases](rc%20files/.zsh_aliases):

```bash
rosex2 # ROS2 Humble
rosex  # ROS Noetic
```

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
