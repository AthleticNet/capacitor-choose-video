import { registerPlugin } from "@capacitor/core";
import { CapacitorChooseVideoPlugin } from "./definitions";

export * from './definitions';

const CapacitorChooseVideo = registerPlugin<CapacitorChooseVideoPlugin>('CapacitorChooseVideo', {
  web: () => import('./web').then(m => new m.CapacitorChooseVideoWeb()),
});

export * from './definitions';
export { CapacitorChooseVideo };
