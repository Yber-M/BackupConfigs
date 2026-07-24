import app from "ags/gtk4/app";
import { Gtk } from "ags/gtk4";
import Adw from "gi://Adw?version=1";
import Gio from "gi://Gio?version=2.0";
import { createBinding, With } from "ags";
import { firstActivePlayer } from "utils/mpris.ts";
import options from "options.ts";

function Cover({ player }) {
  return (
    <box>
      <Adw.Clamp maximumSize={40}>
        <Gtk.Picture
          cssClasses={["cover"]}
          contentFit={Gtk.ContentFit.COVER}
          file={createBinding(player, "coverArt").as((path) =>
            Gio.file_new_for_path(path),
          )}
        />
      </Adw.Clamp>
    </box>
  );
}

function Title({ player }) {
  return (
    <label
      cssClasses={["title", "module"]}
      label={createBinding(
        player,
        "metadata",
      )(() => player.title && `${player.artist} - ${player.title}`)}
    />
  );
}

function MusicBox({ player }) {
  return (
    <box>
      <box>
        <Cover player={player} />
      </box>
      <box>
        <Title player={player} />
      </box>
    </box>
  );
}

export default function Media() {
  return (
    <button
      cssClasses={["Media"]}
      onClicked={() => app.toggle_window("music-player")}
    >
      <With value={firstActivePlayer}>
        {(player) => (player ? <MusicBox player={player} /> : "")}
      </With>
    </button>
  );
}
