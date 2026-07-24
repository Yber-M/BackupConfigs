import { isInhibited, toggleIdleInhibit } from "utils/idleInhibitor";

export default function IdleInhibitor() {
  return (
    <button
      cssClasses={isInhibited((active) =>
        active
          ? ["idle-inhibitor", "module", "active"]
          : ["idle-inhibitor", "module"],
      )}
      tooltipText={isInhibited((active) =>
        active ? "Desactivar Modo Cafeína" : "Activar Modo Cafeína",
      )}
      onClicked={() => toggleIdleInhibit()}
    >
      <label label="coffee" cssClasses={["idle-icon"]} />
    </button>
  );
}
