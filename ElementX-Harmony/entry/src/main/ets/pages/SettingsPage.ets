/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Settings Page
 * Equivalent to iOS Settings screens
 */

import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { authService } from '../services/AuthenticationService';
import { roomService } from '../services/RoomService';
import { timelineService } from '../services/TimelineService';

const DOMAIN = 0x0000;
const TAG = 'SettingsPage';

/**
 * Settings page displays user settings and app configuration.
 * Equivalent to the iOS Settings screens.
 */
@Entry
@Component
struct SettingsPage {
  @State userDisplayName: string = '';
  @State userId: string = '';
  @State userAvatarUrl: string | null = null;
  @State isLoggingOut: boolean = false;
  @State appVersion: string = '1.0.0';

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, 'SettingsPage appearing');
    this.loadUserInfo();
  }

  /**
   * Load current user info
   */
  loadUserInfo(): void {
    const session = authService.getCurrentSession();
    if (session) {
      this.userId = session.userId;
      this.userDisplayName = session.effectiveDisplayName;
      this.userAvatarUrl = session.avatarUrl;
    }
  }

  build() {
    Column() {
      // Navigation bar
      Row() {
        Button() {
          Text('←')
            .fontSize(24)
            .fontColor('#17191C')
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.back();
        })

        Text('Settings')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17191C')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // Spacer for alignment
        Column()
          .width(40)
          .height(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')

      // Content
      Scroll() {
        Column() {
          // User profile section
          Column() {
            Row() {
              // Avatar
              this.AvatarView(this.userDisplayName, this.userAvatarUrl, 64)

              Column() {
                Text(this.userDisplayName)
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#17191C')
                
                Text(this.userId)
                  .fontSize(14)
                  .fontColor('#737D8C')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .padding({ left: 16 })
              .layoutWeight(1)
            }
            .width('100%')
            .padding(16)
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ top: 16 })

          // Settings sections
          Column() {
            this.SettingsSection('Account', [
              { icon: '👤', title: 'Profile', subtitle: 'Edit your display name and avatar' },
              { icon: '🔐', title: 'Security', subtitle: 'Manage your sessions and keys' },
              { icon: '🔔', title: 'Notifications', subtitle: 'Configure notification settings' }
            ])

            this.SettingsSection('Preferences', [
              { icon: '🎨', title: 'Appearance', subtitle: 'Theme and display options' },
              { icon: '💬', title: 'Chat', subtitle: 'Message and room settings' },
              { icon: '🔊', title: 'Sounds', subtitle: 'Notification sounds' }
            ])

            this.SettingsSection('About', [
              { icon: '❓', title: 'Help & Feedback', subtitle: 'Get help or report issues' },
              { icon: 'ℹ️', title: 'About Element X', subtitle: `Version ${this.appVersion}` }
            ])
          }
          .width('100%')
          .margin({ top: 16 })

          // Sign out button
          Button() {
            if (this.isLoggingOut) {
              LoadingProgress()
                .width(24)
                .height(24)
                .color('#FF5252')
            } else {
              Text('Sign Out')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FF5252')
            }
          }
          .width('100%')
          .height(48)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ top: 24 })
          .enabled(!this.isLoggingOut)
          .onClick(() => {
            this.handleSignOut();
          })

          // Footer
          Column() {
            Text('Element X for HarmonyOS')
              .fontSize(12)
              .fontColor('#8D97A5')
            
            Text('Powered by Matrix')
              .fontSize(12)
              .fontColor('#8D97A5')
              .margin({ top: 4 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 32, bottom: 32 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F7F7F7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F7')
  }

  /**
   * Avatar view builder
   */
  @Builder
  AvatarView(name: string, avatarUrl: string | null, size: number) {
    if (avatarUrl) {
      Image(avatarUrl)
        .width(size)
        .height(size)
        .borderRadius(size / 2)
        .objectFit(ImageFit.Cover)
    } else {
      Column() {
        Text(this.getInitials(name))
          .fontSize(size * 0.4)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
      .width(size)
      .height(size)
      .borderRadius(size / 2)
      .backgroundColor(this.getAvatarColor(name))
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }

  /**
   * Settings section builder
   */
  @Builder
  SettingsSection(title: string, items: SettingItem[]) {
    Column() {
      Text(title)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor('#737D8C')
        .width('100%')
        .padding({ left: 16, bottom: 8 })

      Column() {
        ForEach(items, (item: SettingItem, index: number) => {
          Row() {
            Text(item.icon)
              .fontSize(24)
              .width(32)

            Column() {
              Text(item.title)
                .fontSize(16)
                .fontColor('#17191C')
              
              if (item.subtitle) {
                Text(item.subtitle)
                  .fontSize(13)
                  .fontColor('#737D8C')
                  .margin({ top: 2 })
              }
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
            .padding({ left: 12 })

            Text('›')
              .fontSize(20)
              .fontColor('#C4C4C4')
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            this.handleSettingTap(item.title);
          })

          if (index < items.length - 1) {
            Divider()
              .strokeWidth(0.5)
              .color('#E3E8F0')
              .margin({ left: 60 })
          }
        }, (item: SettingItem) => item.title)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  /**
   * Get initials from name
   */
  getInitials(name: string): string {
    if (!name) return '?';
    const parts = name.split(' ').filter(p => p.length > 0);
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  /**
   * Get consistent color for avatar based on name
   */
  getAvatarColor(name: string): string {
    const colors = ['#0DBD8B', '#7B61FF', '#FF5252', '#448AFF', '#FF9800', '#4CAF50'];
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
      hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    return colors[Math.abs(hash) % colors.length];
  }

  /**
   * Handle setting item tap
   */
  handleSettingTap(title: string): void {
    hilog.info(DOMAIN, TAG, `Setting tapped: ${title}`);
    // TODO: Navigate to specific setting screen
  }

  /**
   * Handle sign out
   */
  async handleSignOut(): Promise<void> {
    hilog.info(DOMAIN, TAG, 'Sign out tapped');
    this.isLoggingOut = true;

    try {
      // Clear services
      roomService.clear();
      timelineService.clearAll();
      
      // Logout
      await authService.logout();
      
      // Navigate to login
      router.replaceUrl({
        url: 'pages/LoginPage'
      }).catch((error: Error) => {
        hilog.error(DOMAIN, TAG, `Navigation error: ${error}`);
      });
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Sign out error: ${error}`);
    } finally {
      this.isLoggingOut = false;
    }
  }
}

/**
 * Setting item interface
 */
interface SettingItem {
  icon: string;
  title: string;
  subtitle?: string;
}
