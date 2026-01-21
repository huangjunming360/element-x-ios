/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Index Page (Entry Point)
 * This is the main entry point that handles navigation based on auth state
 */

import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { authService } from '../services/AuthenticationService';
import { AuthenticationState } from '../models/UserModels';

const DOMAIN = 0x0000;
const TAG = 'IndexPage';

/**
 * Index page serves as the entry point and router for the application.
 * It checks authentication state and navigates to the appropriate screen.
 */
@Entry
@Component
struct Index {
  @State isLoading: boolean = true;
  @State authState: AuthenticationState = AuthenticationState.UNKNOWN;

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, 'Index page appearing');
    this.checkAuthState();
  }

  /**
   * Check authentication state and navigate accordingly
   */
  async checkAuthState(): Promise<void> {
    try {
      // Try to restore existing session
      const restored = await authService.restoreSession();
      
      if (restored && authService.isLoggedIn()) {
        this.authState = AuthenticationState.SIGNED_IN;
        hilog.info(DOMAIN, TAG, 'Session restored, navigating to home');
        this.navigateToHome();
      } else {
        this.authState = AuthenticationState.SIGNED_OUT;
        hilog.info(DOMAIN, TAG, 'No session, navigating to login');
        this.navigateToLogin();
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Auth check error: ${error}`);
      this.authState = AuthenticationState.SIGNED_OUT;
      this.navigateToLogin();
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * Navigate to the home screen
   */
  navigateToHome(): void {
    router.replaceUrl({
      url: 'pages/HomePage'
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `Navigation error: ${error}`);
    });
  }

  /**
   * Navigate to the login screen
   */
  navigateToLogin(): void {
    router.replaceUrl({
      url: 'pages/LoginPage'
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `Navigation error: ${error}`);
    });
  }

  build() {
    Column() {
      // Splash screen while checking auth state
      Column() {
        // App Logo placeholder
        Column() {
          Text('Element X')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0DBD8B')
        }
        .width(120)
        .height(120)
        .borderRadius(24)
        .backgroundColor('#F0FDF9')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        
        Text('Element X')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17191C')
          .margin({ top: 24 })
        
        Text('Secure Matrix Messenger')
          .fontSize(14)
          .fontColor('#737D8C')
          .margin({ top: 8 })

        if (this.isLoading) {
          LoadingProgress()
            .width(48)
            .height(48)
            .margin({ top: 48 })
            .color('#0DBD8B')
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
