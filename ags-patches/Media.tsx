import app from "ags/gtk4/app";
import { Gtk } from "ags/gtk4";
import Adw from "gi://Adw?version=1";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib";
import { createBinding, With, onCleanup } from "ags";
import { CavaDraw } from "widgets/music/modules/cava";
import { firstActivePlayer } from "utils/mpris.ts";
import options from "options.ts";

function Cover({ player }) {
  let measureBox: Gtk.Widget | null = null;
  return (
    <overlay
      $={(self) => {
        if (measureBox) {
          self.set_measure_overlay(measureBox, true);
        }
      }}
    >
      <box
        cssClasses={["cava-container"]}
        $type="overlay"
        canTarget={false}
        visible={options["bar.modules.media.cava.enable"]}
      >
        <CavaDraw vexpand hexpand style={"circular"} />
      </box>
      <box
        $type="overlay"
        $={(self) => {
          measureBox = self;
        }}
      >
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
    </overlay>
  );
}

function Title({ player }) {
  const label = createBinding(
    player,
    "metadata",
  )(() => (player.title ? `${player.title} - ${player.artist}` : ""));

  let sourceId: number | null = null;

  onCleanup(() => {
    if (sourceId !== null) {
      GLib.source_remove(sourceId);
      sourceId = null;
    }
  });

  return (
    <scrolledwindow
      widthRequest={220}
      hscrollbarPolicy={Gtk.PolicyType.NEVER}
      vscrollbarPolicy={Gtk.PolicyType.NEVER}
      overflow={Gtk.Overflow.HIDDEN}
      $={(self) => {
        const adj = self.get_hadjustment();
        let direction = 1;
        let pause = 20;

        sourceId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 50, () => {
          const maxScroll = adj.get_upper() - adj.get_page_size();
          if (maxScroll <= 0) return true;

          if (pause > 0) {
            pause--;
            return true;
          }

          let value = adj.get_value() + direction * 1.2;
          if (value >= maxScroll) {
            value = maxScroll;
            direction = -1;
            pause = 20;
          } else if (value <= 0) {
            value = 0;
            direction = 1;
            pause = 20;
          }
          adj.set_value(value);
          return true;
        });
      }}
    >
      <label cssClasses={["title", "module"]} label={label} />
    </scrolledwindow>
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
