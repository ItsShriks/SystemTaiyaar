// Checkbox menu for the Brewfile, using the same library as mac-cleaner-cli.
// Usage: node pick-apps.mjs <Brewfile> <output Brewfile>
import { readFileSync, writeFileSync } from "node:fs";
import checkbox from "@inquirer/checkbox";

const [brewfile, output] = process.argv.slice(2);
const entries = readFileSync(brewfile, "utf8")
  .split("\n")
  .map((line) => line.match(/^(brew|cask|mas) "([^"]+)"/))
  .filter(Boolean)
  .map(([line, kind, name]) => ({ line, kind, name }));

let picked;
try {
  picked = await checkbox({
    message: "Apps to install (everything starts ticked)",
    pageSize: 20,
    loop: false,
    choices: entries.map((entry) => ({
      name: `${entry.name} (${entry.kind})`,
      value: entry,
      checked: true,
    })),
  });
} catch (error) {
  if (error.name === "ExitPromptError") process.exit(130);
  throw error;
}

// App Store entries can't install without the mas formula
const mas = entries.find((entry) => entry.kind === "brew" && entry.name === "mas");
if (mas && picked.some((entry) => entry.kind === "mas") && !picked.includes(mas)) {
  picked.unshift(mas);
}

writeFileSync(output, picked.map((entry) => entry.line + "\n").join(""));
