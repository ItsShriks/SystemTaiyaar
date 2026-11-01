# 🛠️ System Taiyaar 🚀 (Ubuntu)

Sets up a fresh Ubuntu machine and keeps its rc files. This is the **Ubuntu** branch; Macs use the [macOS](https://github.com/ItsShriks/SystemTaiyaar/tree/macOS) branch.

---

## ⚡ Quick Start

This detects the OS, clones only the matching branch to `~/SystemTaiyaar`, and opens the menu:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/ItsShriks/SystemTaiyaar/main/bootstrap.sh)"
```

Or clone it yourself:

```bash
git clone --single-branch --branch Ubuntu https://github.com/ItsShriks/SystemTaiyaar.git ~/SystemTaiyaar
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
| `essentials` | `Bootup/essentials.sh` | git, build tools, gh, glab, git identity |
| `ssh` | `Bootup/ssh-keygen.sh` | Ed25519 key, added to GitHub and GitLab through `gh` and `glab`, then tested |
| `ros` | `Bootup/ROS.sh` | ROS2 Humble from the official apt repository (Ubuntu 22.04 only) |
| `clean` | `Bootup/clean.sh` | Conda and apt cleanup |
| `apps` | `Bootup/install.sh` | terminator, VS Code, NVIDIA drivers if there is a GPU, Miniconda, `requirements.txt` if present |
| `docker` | `Bootup/docker.sh` | Docker Engine and Compose from Docker's apt repository, optional image build |
| `rc` | `Bootup/rc.sh` | Links `rc files/` into `$HOME`, backing up what was there to `~/.system-taiyaar-backup` |
| `update` | `Bootup/update.sh` | Updates apt, snap and Conda packages |

Every step can be re-run safely. `clean` and `update` are not part of `all`.

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
