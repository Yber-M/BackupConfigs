import { createState } from "ags";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib";

const [isInhibited, setIsInhibited] = createState(false);
export { isInhibited };

let inhibitProcess: Gio.Subprocess | null = null;

export function toggleIdleInhibit(): void {
  if (isInhibited.get()) {
    stopInhibit();
  } else {
    startInhibit();
  }
}

function notify(title: string, body: string): void {
  try {
    Gio.Subprocess.new(
      ["notify-send", "-a", "Modo Cafeína", "-i", "coffee", title, body],
      Gio.SubprocessFlags.NONE,
    );
  } catch (error) {
    console.error("Failed to send notification:", error);
  }
}

function startInhibit(): void {
  if (inhibitProcess) return;

  try {
    inhibitProcess = Gio.Subprocess.new(
      [
        "systemd-inhibit",
        "--what=idle",
        "--who=matshell",
        "--why=Idle inhibited by user",
        "sleep",
        "infinity",
      ],
      Gio.SubprocessFlags.NONE,
    );
    setIsInhibited(true);
    notify("Modo Cafeína activado", "La pantalla no se apagará ni bloqueará por inactividad.");
    console.log("Idle inhibit: activated");
  } catch (error) {
    console.error("Failed to start idle inhibitor:", error);
  }
}

function stopInhibit(): void {
  if (!inhibitProcess) return;

  try {
    inhibitProcess.force_exit();
  } catch (error) {
    console.error("Failed to stop idle inhibitor:", error);
  } finally {
    inhibitProcess = null;
    setIsInhibited(false);
    notify("Modo Cafeína desactivado", "Vuelve el comportamiento normal de suspensión.");
    console.log("Idle inhibit: deactivated");
  }
}
