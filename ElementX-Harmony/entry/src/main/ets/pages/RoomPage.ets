/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Room Page
 * Equivalent to iOS RoomScreen - displays room timeline and composer
 */

import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { authService } from '../services/AuthenticationService';
import { timelineService } from '../services/TimelineService';
import { TimelineEvent, TextMessageContent, SendState } from '../models/TimelineModels';
import { MessageBubble } from '../components/MessageBubble';

const DOMAIN = 0x0000;
const TAG = 'RoomPage';

interface RoomParams {
  roomId: string;
  roomName: string;
}

/**
 * Room page displays the chat timeline and message composer.
 * Equivalent to the iOS RoomScreen.
 */
@Entry
@Component
struct RoomPage {
  @State roomId: string = '';
  @State roomName: string = '';
  @State timeline: TimelineEvent[] = [];
  @State isLoading: boolean = true;
  @State messageText: string = '';
  @State isSending: boolean = false;
  @State userId: string = '';

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, 'RoomPage appearing');
    
    // Get room params
    const params = router.getParams() as RoomParams;
    if (params) {
      this.roomId = params.roomId;
      this.roomName = params.roomName;
    }
    
    // Get current user ID
    const session = authService.getCurrentSession();
    if (session) {
      this.userId = session.userId;
    }
    
    this.loadTimeline();
  }

  /**
   * Load room timeline
   */
  async loadTimeline(): Promise<void> {
    hilog.info(DOMAIN, TAG, `Loading timeline for room: ${this.roomId}`);
    this.isLoading = true;

    try {
      this.timeline = await timelineService.loadTimeline(this.roomId);
      hilog.info(DOMAIN, TAG, `Loaded ${this.timeline.length} events`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to load timeline: ${error}`);
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // Navigation bar
      Row() {
        // Back button
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

        // Room info
        Column() {
          Text(this.roomName)
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor('#17191C')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          
          Text('Tap for room info')
            .fontSize(12)
            .fontColor('#737D8C')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 8 })
        .onClick(() => {
          this.handleRoomInfoTap();
        })

        // Room menu button
        Button() {
          Text('⋮')
            .fontSize(24)
            .fontColor('#17191C')
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.handleMenuTap();
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 2, color: '#0000001A', offsetY: 1 })

      // Timeline
      if (this.isLoading) {
        // Loading state
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#0DBD8B')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#F7F7F7')
      } else if (this.timeline.length === 0) {
        // Empty timeline
        Column() {
          Text('No messages yet')
            .fontSize(16)
            .fontColor('#737D8C')
          
          Text('Be the first to send a message!')
            .fontSize(14)
            .fontColor('#8D97A5')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#F7F7F7')
      } else {
        // Message list
        List() {
          ForEach(this.timeline, (event: TimelineEvent) => {
            ListItem() {
              MessageBubble({
                event: event,
                isFromCurrentUser: event.isFromUser(this.userId),
                showSenderInfo: !event.isFromUser(this.userId)
              })
            }
          }, (event: TimelineEvent) => event.eventId)
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F7F7F7')
        .padding({ top: 8, bottom: 8 })
      }

      // Message composer
      Row() {
        // Attachment button
        Button() {
          Text('+')
            .fontSize(24)
            .fontColor('#737D8C')
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.handleAttachmentTap();
        })

        // Text input
        TextInput({ placeholder: 'Send a message', text: this.messageText })
          .layoutWeight(1)
          .height(40)
          .borderRadius(20)
          .backgroundColor('#F0F0F0')
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.messageText = value;
          })
          .onSubmit(() => {
            this.sendMessage();
          })

        // Send button
        Button() {
          if (this.isSending) {
            LoadingProgress()
              .width(20)
              .height(20)
              .color(Color.White)
          } else {
            Text('➤')
              .fontSize(18)
              .fontColor(Color.White)
          }
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .backgroundColor(this.messageText.trim().length > 0 ? '#0DBD8B' : '#B0E5D8')
        .enabled(this.messageText.trim().length > 0 && !this.isSending)
        .onClick(() => {
          this.sendMessage();
        })
        .margin({ left: 8 })
      }
      .width('100%')
      .padding({ left: 8, right: 8, top: 8, bottom: 8 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 4, color: '#0000001A', offsetY: -1 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F7')
  }

  /**
   * Send a message
   */
  async sendMessage(): Promise<void> {
    const text = this.messageText.trim();
    if (text.length === 0) return;

    hilog.info(DOMAIN, TAG, 'Sending message');
    this.isSending = true;
    const sentText = text;
    this.messageText = ''; // Clear input immediately for better UX

    try {
      const event = await timelineService.sendTextMessage(this.roomId, sentText, this.userId);
      
      if (event) {
        // Update local timeline
        this.timeline = timelineService.getTimeline(this.roomId);
        hilog.info(DOMAIN, TAG, 'Message sent successfully');
      } else {
        // Restore text if failed
        this.messageText = sentText;
        hilog.error(DOMAIN, TAG, 'Failed to send message');
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Send error: ${error}`);
      this.messageText = sentText;
    } finally {
      this.isSending = false;
    }
  }

  /**
   * Handle room info tap
   */
  handleRoomInfoTap(): void {
    hilog.info(DOMAIN, TAG, 'Room info tapped');
    // TODO: Navigate to room details
  }

  /**
   * Handle menu tap
   */
  handleMenuTap(): void {
    hilog.info(DOMAIN, TAG, 'Menu tapped');
    // TODO: Show room menu
  }

  /**
   * Handle attachment tap
   */
  handleAttachmentTap(): void {
    hilog.info(DOMAIN, TAG, 'Attachment tapped');
    // TODO: Show attachment picker
  }
}
