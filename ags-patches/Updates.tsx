import { execAsync } from "ags/process";
import options from "options";
import { updateCounts } from "utils/updates";

export default function Updates() {
  const visible = updateCounts((c) => c.total > 0);

  const tooltip = updateCounts(
    (c) =>
      `Oficiales: ${c.official}  ·  AUR: ${c.aur}  ·  Flatpak: ${c.flatpak}`,
  );

  return (
    <button
      cssClasses={["updates", "module"]}
      visible={visible}
      tooltipText={tooltip}
      onClicked={async () => {
        try {
          const terminal = options["app.terminal"].get();
          await execAsync([
            terminal,
            "-e",
            "bash",
            "-c",
            "yay -Syu; echo; flatpak update -y; echo; read -p 'Presiona Enter para cerrar...'",
          ]);
        } catch (error) {
          console.error("Failed to open update terminal:", error);
        }
      }}
    >
      <box spacing={4}>
        <image iconName="software-update-available-symbolic" />
        <label label={updateCounts((c) => `${c.total}`)} />
      </box>
    </button>
  );
}
