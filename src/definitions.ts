declare module "@capacitor/core" {
  interface PluginRegistry {
    CapacitorChooseVideo: CapacitorChooseVideoPlugin;
  }
}

export interface CapacitorChooseVideoPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
  getVideo(options: { value: string }): Promise<{path: any}>;
}
