import { createBinding } from "ags";
import { Gdk, Gtk } from "ags/gtk4";
import Wp from "gi://AstalWp";
import { execAsync } from "ags/process";
import options from "options";

export default function AudioStatus() {
  const wp = Wp.get_default()!;
  const speaker = wp.audio.defaultSpeaker;
  const microphone = wp.get_default_microphone();

  const openAudioApp = () => execAsync(options["app.audio"].get());

  const addRightClick = (self: Gtk.Widget) => {
    const gesture = new Gtk.GestureClick();
    gesture.set_button(Gdk.BUTTON_SECONDARY);
    gesture.connect("pressed", () => openAudioApp());
    self.add_controller(gesture);
  };

  return (
    <box>
      <button
        cssClasses={["audio-status", "module"]}
        $={(self) => addRightClick(self)}
        tooltipText={createBinding(speaker, "volume")(
          (v) => `Volumen: ${Math.round(v * 100)}%`,
        )}
        onClicked={() => {
          speaker.mute = !speaker.mute;
        }}
      >
        <image
          cssClasses={["audio-icon"]}
          iconName={createBinding(speaker, "volumeIcon")}
        />
      </button>
      <button
        cssClasses={["audio-status", "module"]}
        $={(self) => addRightClick(self)}
        visible={createBinding(microphone, "path")((mic) => mic !== null)}
        tooltipText={createBinding(microphone, "mute")((m) =>
          m ? "Micrófono silenciado" : "Micrófono activo",
        )}
        onClicked={() => {
          microphone.mute = !microphone.mute;
        }}
      >
        <image
          cssClasses={["audio-icon"]}
          iconName={createBinding(microphone, "volumeIcon")}
        />
      </button>
    </box>
  );
}
