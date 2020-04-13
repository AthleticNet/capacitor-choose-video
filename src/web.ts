import { WebPlugin } from '@capacitor/core';
import { CapacitorChooseVideoPlugin } from './definitions';

export class CapacitorChooseVideoWeb extends WebPlugin implements CapacitorChooseVideoPlugin {
  constructor() {
    super({
      name: 'CapacitorChooseVideo',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO: ', options);
    return options;
  }

  async requestFilesystemAccess(): Promise<{hasPermission: boolean}> {
    return Promise.resolve({'hasPermission': true});
  }

  async getVideo(options: { value: string }): Promise<{path: string}> {
    console.log(options);
    return Promise.resolve({'path': ''});
  }
}

const CapacitorChooseVideo = new CapacitorChooseVideoWeb();

export { CapacitorChooseVideo };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(CapacitorChooseVideo);
