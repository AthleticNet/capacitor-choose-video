declare module "@capacitor/core" {
  interface PluginRegistry {
    CapacitorChooseVideo: CapacitorChooseVideoPlugin;
  }
}

export interface CapacitorChooseVideoPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
  requestFilesystemAccess(): Promise<{hasPermission: boolean}>;
  getVideo(options: { value: string }): Promise<{path: any}>;
}
