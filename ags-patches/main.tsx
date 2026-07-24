import app from "ags/gtk4/app";
import Net from "./modules/Net.tsx";
import Blue from "./modules/Bluetooth.tsx";
import Batt from "./modules/Battery.tsx";
import IdleInhibitor from "./modules/IdleInhibitor.tsx";
export default function SystemInfo() {
  return (
    <box>
      <IdleInhibitor />
      <button
        cssClasses={["system-menu-toggler"]}
        onClicked={() => app.toggle_window("system-menu")}
      >
        <box>
          <Net />
          <Blue />
          <Batt />
        </box>
      </button>
    </box>
  );
}
