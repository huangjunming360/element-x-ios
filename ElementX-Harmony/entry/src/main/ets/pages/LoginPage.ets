/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Login Page
 * Equivalent to iOS Authentication screens
 */

import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { authService } from '../services/AuthenticationService';
import { LoginCredentials } from '../models/UserModels';

const DOMAIN = 0x0000;
const TAG = 'LoginPage';

/**
 * Login page handles user authentication.
 * Equivalent to the iOS Onboarding/Authentication flow.
 */
@Entry
@Component
struct LoginPage {
  @State homeserverUrl: string = 'matrix.org';
  @State username: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;
  @State errorMessage: string = '';
  @State showPassword: boolean = false;

  build() {
    Column() {
      // Scrollable content
      Scroll() {
        Column() {
          // Header
          Column() {
            // Logo placeholder
            Column() {
              Text('X')
                .fontSize(48)
                .fontWeight(FontWeight.Bold)
                .fontColor('#0DBD8B')
            }
            .width(80)
            .height(80)
            .borderRadius(16)
            .backgroundColor('#F0FDF9')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            
            Text('Sign in to your account')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#17191C')
              .margin({ top: 24 })
            
            Text('Enter your Matrix homeserver and credentials')
              .fontSize(14)
              .fontColor('#737D8C')
              .margin({ top: 8 })
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 48, bottom: 32 })

          // Form
          Column() {
            // Homeserver URL
            Column() {
              Text('Homeserver')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#17191C')
                .width('100%')
              
              TextInput({ placeholder: 'matrix.org', text: this.homeserverUrl })
                .width('100%')
                .height(48)
                .borderRadius(8)
                .backgroundColor('#F7F7F7')
                .padding({ left: 16, right: 16 })
                .margin({ top: 8 })
                .onChange((value: string) => {
                  this.homeserverUrl = value;
                  this.errorMessage = '';
                })
            }
            .width('100%')
            .margin({ bottom: 16 })

            // Username
            Column() {
              Text('Username')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#17191C')
                .width('100%')
              
              TextInput({ placeholder: 'Username', text: this.username })
                .width('100%')
                .height(48)
                .borderRadius(8)
                .backgroundColor('#F7F7F7')
                .padding({ left: 16, right: 16 })
                .margin({ top: 8 })
                .onChange((value: string) => {
                  this.username = value;
                  this.errorMessage = '';
                })
            }
            .width('100%')
            .margin({ bottom: 16 })

            // Password
            Column() {
              Text('Password')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#17191C')
                .width('100%')
              
              Stack({ alignContent: Alignment.End }) {
                TextInput({ placeholder: 'Password', text: this.password })
                  .width('100%')
                  .height(48)
                  .borderRadius(8)
                  .backgroundColor('#F7F7F7')
                  .padding({ left: 16, right: 48 })
                  .type(this.showPassword ? InputType.Normal : InputType.Password)
                  .onChange((value: string) => {
                    this.password = value;
                    this.errorMessage = '';
                  })
                
                Button() {
                  Text(this.showPassword ? '🙈' : '👁')
                    .fontSize(20)
                }
                .width(40)
                .height(40)
                .backgroundColor(Color.Transparent)
                .margin({ right: 4 })
                .onClick(() => {
                  this.showPassword = !this.showPassword;
                })
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .width('100%')
            .margin({ bottom: 24 })

            // Error message
            if (this.errorMessage.length > 0) {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor('#FF5252')
                .width('100%')
                .margin({ bottom: 16 })
            }

            // Sign In Button
            Button() {
              if (this.isLoading) {
                LoadingProgress()
                  .width(24)
                  .height(24)
                  .color(Color.White)
              } else {
                Text('Sign In')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.White)
              }
            }
            .width('100%')
            .height(48)
            .borderRadius(24)
            .backgroundColor(this.isFormValid() ? '#0DBD8B' : '#B0E5D8')
            .enabled(this.isFormValid() && !this.isLoading)
            .onClick(() => {
              this.handleLogin();
            })
          }
          .width('100%')
          .padding({ left: 24, right: 24 })

          // Footer links
          Column() {
            Text('By signing in, you agree to our Terms & Conditions')
              .fontSize(12)
              .fontColor('#8D97A5')
              .textAlign(TextAlign.Center)
              .margin({ top: 24 })
          }
          .width('100%')
          .padding({ left: 24, right: 24, bottom: 32 })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  /**
   * Check if the form is valid for submission
   */
  isFormValid(): boolean {
    return this.homeserverUrl.trim().length > 0 &&
           this.username.trim().length > 0 &&
           this.password.length > 0;
  }

  /**
   * Handle login button press
   */
  async handleLogin(): Promise<void> {
    if (!this.isFormValid()) return;

    hilog.info(DOMAIN, TAG, 'Attempting login');
    this.isLoading = true;
    this.errorMessage = '';

    const credentials: LoginCredentials = {
      homeserverUrl: this.homeserverUrl,
      username: this.username,
      password: this.password
    };

    try {
      const result = await authService.login(credentials);

      if (result.success) {
        hilog.info(DOMAIN, TAG, 'Login successful');
        this.navigateToHome();
      } else {
        this.errorMessage = result.error ?? 'Login failed. Please try again.';
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Login error: ${error}`);
      this.errorMessage = 'An error occurred. Please try again.';
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * Navigate to the home screen after successful login
   */
  navigateToHome(): void {
    router.replaceUrl({
      url: 'pages/HomePage'
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `Navigation error: ${error}`);
    });
  }
}
