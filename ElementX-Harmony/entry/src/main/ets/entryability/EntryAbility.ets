/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Entry Ability
 * Equivalent to iOS AppDelegate - handles application lifecycle
 */

import { UIAbility, AbilityConstant, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;
const TAG = 'EntryAbility';

/**
 * EntryAbility is the main entry point for the Element X application.
 * It manages the application lifecycle and window creation.
 * 
 * This is equivalent to the AppDelegate in the iOS version.
 */
export default class EntryAbility extends UIAbility {
  /**
   * Called when the ability is created.
   * Initialize application-level resources and services here.
   */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, 'Element X HarmonyOS - onCreate');
    hilog.info(DOMAIN, TAG, `LaunchParam: ${JSON.stringify(launchParam)}`);
    
    // Initialize global application state
    this.initializeApplication();
  }

  /**
   * Called when the ability is destroyed.
   * Clean up resources here.
   */
  onDestroy(): void {
    hilog.info(DOMAIN, TAG, 'Element X HarmonyOS - onDestroy');
  }

  /**
   * Called when the main window is created.
   * Set up the UI content here.
   */
  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, 'Element X HarmonyOS - onWindowStageCreate');

    // Load the main content page
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, `Failed to load content: ${JSON.stringify(err)}`);
        return;
      }
      hilog.info(DOMAIN, TAG, 'Content loaded successfully');
    });
  }

  /**
   * Called when the main window is destroyed.
   * Release UI-related resources here.
   */
  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, 'Element X HarmonyOS - onWindowStageDestroy');
  }

  /**
   * Called when the ability comes to the foreground.
   * Resume any paused operations here.
   */
  onForeground(): void {
    hilog.info(DOMAIN, TAG, 'Element X HarmonyOS - onForeground');
  }

  /**
   * Called when the ability goes to the background.
   * Save state and pause operations here.
   */
  onBackground(): void {
    hilog.info(DOMAIN, TAG, 'Element X HarmonyOS - onBackground');
  }

  /**
   * Initialize application-level services and configuration.
   * This is similar to the ServiceLocator setup in the iOS version.
   */
  private initializeApplication(): void {
    hilog.info(DOMAIN, TAG, 'Initializing Element X application services');
    
    // TODO: Initialize Matrix SDK
    // TODO: Initialize notification service
    // TODO: Initialize analytics service
    // TODO: Initialize secure storage (Keychain equivalent)
  }
}
