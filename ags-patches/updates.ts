import { createPoll } from "ags/time";
import { execAsync } from "ags/process";

const CHECK_INTERVAL = 30 * 60 * 1000; // 30 minutos

export interface UpdateCounts {
  official: number;
  aur: number;
  flatpak: number;
  total: number;
}

export const updateCounts = createPoll<UpdateCounts>(
  { official: 0, aur: 0, flatpak: 0, total: 0 },
  CHECK_INTERVAL,
  async () => {
    const [officialRes, aurRes, flatpakRes] = await Promise.allSettled([
      execAsync(["bash", "-c", "checkupdates 2>/dev/null | wc -l"]),
      execAsync(["bash", "-c", "yay -Qua 2>/dev/null | wc -l"]),
      execAsync(["bash", "-c", "flatpak remote-ls --updates 2>/dev/null | wc -l"]),
    ]);

    const parse = (r: PromiseSettledResult<string>) =>
      r.status === "fulfilled" ? parseInt(r.value.trim()) || 0 : 0;

    const official = parse(officialRes);
    const aur = parse(aurRes);
    const flatpak = parse(flatpakRes);

    return { official, aur, flatpak, total: official + aur + flatpak };
  },
);
