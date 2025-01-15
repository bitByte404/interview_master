import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { fullScreen, logger } from '../commons/utils';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 将上下文对象存储起来
    AppStorage.setOrCreate('context', this.context)
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    logger.info('Ability onWindowStageCreate');

    windowStage.loadContent('pages/WordPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      // hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      logger.info('Succeeded in loading the content.');
      // 测试全屏效果
      fullScreen.enable()
      // setTimeout(() => {
      //   fullScreen.disable()
      // }, 5000)
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    logger.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    logger.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    logger.info('Ability onBackground');
  }
}