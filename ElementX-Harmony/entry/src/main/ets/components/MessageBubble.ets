/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Message Bubble Component
 * Equivalent to iOS Timeline message views
 */

import { TimelineEvent, TextMessageContent, SendState } from '../models/TimelineModels';

/**
 * Message bubble component for displaying a message in the timeline.
 */
@Component
export struct MessageBubble {
  @Prop event: TimelineEvent = new TimelineEvent({
    eventId: '',
    roomId: '',
    senderId: '',
    timestamp: Date.now(),
    content: { type: 'text', body: '' }
  });
  @Prop isFromCurrentUser: boolean = false;
  @Prop showSenderInfo: boolean = true;

  build() {
    Column() {
      // Sender info (for messages from others)
      if (this.showSenderInfo && !this.isFromCurrentUser) {
        Row() {
          this.AvatarView(
            this.event.senderDisplayName ?? this.event.senderId,
            this.event.senderAvatarUrl,
            28
          )
          
          Text(this.event.senderDisplayName ?? this.event.senderId)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#737D8C')
            .padding({ left: 8 })
        }
        .width('100%')
        .padding({ left: 12, bottom: 4 })
      }

      // Message bubble
      Row() {
        if (this.isFromCurrentUser) {
          Blank()
        }

        Column() {
          // Message content
          this.renderContent()

          // Timestamp and status
          Row() {
            Text(this.event.formattedTime)
              .fontSize(11)
              .fontColor(this.isFromCurrentUser ? '#FFFFFF99' : '#8D97A5')
            
            // Send status for own messages
            if (this.isFromCurrentUser) {
              Text(this.getSendStatusIcon())
                .fontSize(12)
                .fontColor(this.isFromCurrentUser ? '#FFFFFF99' : '#8D97A5')
                .margin({ left: 4 })
                .accessibilityText(this.getSendStatusDescription())
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ top: 4 })
        }
        .padding(12)
        .borderRadius(16)
        .backgroundColor(this.isFromCurrentUser ? '#0DBD8B' : '#FFFFFF')
        .constraintSize({ maxWidth: '75%' })
        .shadow(this.isFromCurrentUser ? undefined : { 
          radius: 2, 
          color: '#0000000D', 
          offsetY: 1 
        })

        if (!this.isFromCurrentUser) {
          Blank()
        }
      }
      .width('100%')
      .padding({ 
        left: this.isFromCurrentUser ? 48 : 12, 
        right: this.isFromCurrentUser ? 12 : 48 
      })
    }
    .width('100%')
    .padding({ top: 4, bottom: 4 })
    .alignItems(this.isFromCurrentUser ? HorizontalAlign.End : HorizontalAlign.Start)
  }

  /**
   * Render message content based on type
   */
  @Builder
  renderContent() {
    if (this.event.content.type === 'text') {
      Text((this.event.content as TextMessageContent).body)
        .fontSize(15)
        .fontColor(this.isFromCurrentUser ? Color.White : '#17191C')
        .lineHeight(20)
    } else if (this.event.content.type === 'image') {
      Column() {
        Text('🖼️ Image')
          .fontSize(15)
          .fontColor(this.isFromCurrentUser ? Color.White : '#17191C')
        // TODO: Display actual image
      }
    } else if (this.event.content.type === 'video') {
      Column() {
        Text('🎬 Video')
          .fontSize(15)
          .fontColor(this.isFromCurrentUser ? Color.White : '#17191C')
      }
    } else if (this.event.content.type === 'file') {
      Column() {
        Text('📎 File')
          .fontSize(15)
          .fontColor(this.isFromCurrentUser ? Color.White : '#17191C')
      }
    } else if (this.event.content.type === 'audio') {
      Column() {
        Text('🎵 Audio')
          .fontSize(15)
          .fontColor(this.isFromCurrentUser ? Color.White : '#17191C')
      }
    } else {
      Text('Unsupported message type')
        .fontSize(15)
        .fontColor(this.isFromCurrentUser ? '#FFFFFF99' : '#8D97A5')
        .fontStyle(FontStyle.Italic)
    }
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
   * Get send status text for accessibility
   */
  getSendStatusIcon(): string {
    switch (this.event.sendState) {
      case SendState.SENDING:
        return '...';
      case SendState.SENT:
        return '✓';
      case SendState.FAILED:
        return '!';
      default:
        return '';
    }
  }

  /**
   * Get send status description for accessibility
   */
  getSendStatusDescription(): string {
    switch (this.event.sendState) {
      case SendState.SENDING:
        return 'Message sending';
      case SendState.SENT:
        return 'Message sent';
      case SendState.FAILED:
        return 'Message failed to send';
      default:
        return '';
    }
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
}
