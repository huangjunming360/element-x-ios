/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Room Cell Component
 * Equivalent to iOS HomeScreenRoomCell
 */

import { RoomListItem, RoomType } from '../models/RoomModels';

/**
 * Room cell component for displaying a room in the room list.
 * Equivalent to HomeScreenRoomCell in the iOS version.
 */
@Component
export struct RoomCell {
  @Prop room: RoomListItem = RoomListItem.placeholder();
  @Prop isSelected: boolean = false;
  onTap: () => void = () => {};
  onLongPress: () => void = () => {};

  build() {
    Row() {
      // Avatar
      Stack({ alignContent: Alignment.BottomEnd }) {
        this.AvatarView(this.room.name, this.room.avatarUrl, 48)
        
        // Call indicator
        if (this.room.hasOngoingCall) {
          Column() {
            Text('📞')
              .fontSize(12)
          }
          .width(20)
          .height(20)
          .borderRadius(10)
          .backgroundColor('#0DBD8B')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width(48)
      .height(48)

      // Room info
      Column() {
        Row() {
          // Room name
          Text(this.room.name)
            .fontSize(16)
            .fontWeight(this.room.isHighlighted ? FontWeight.Bold : FontWeight.Medium)
            .fontColor('#17191C')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
          
          // Mute indicator
          if (this.room.isMuted) {
            Text('🔇')
              .fontSize(14)
              .margin({ left: 4 })
          }
          
          // Favourite indicator
          if (this.room.isFavourite) {
            Text('⭐')
              .fontSize(14)
              .margin({ left: 4 })
          }
          
          // Timestamp
          if (this.room.lastMessageTimestamp) {
            Text(this.room.lastMessageTimestamp)
              .fontSize(12)
              .fontColor(this.room.isHighlighted ? '#0DBD8B' : '#8D97A5')
              .margin({ left: 8 })
          }
        }
        .width('100%')

        Row() {
          // Last message or invite info
          if (this.room.roomType === RoomType.INVITE) {
            Text('Invitation')
              .fontSize(14)
              .fontColor('#0DBD8B')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)
          } else if (this.room.roomType === RoomType.KNOCK) {
            Text('Knock pending')
              .fontSize(14)
              .fontColor('#FF9800')
              .layoutWeight(1)
          } else if (this.room.lastMessage) {
            Text(this.room.lastMessage)
              .fontSize(14)
              .fontColor('#737D8C')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
          } else {
            Text('No messages yet')
              .fontSize(14)
              .fontColor('#8D97A5')
              .fontStyle(FontStyle.Italic)
              .layoutWeight(1)
          }

          // Badges
          Row() {
            // Mention badge
            if (this.room.hasUnreadMentions && !this.room.isMuted) {
              this.Badge('@', '#0DBD8B')
            }
            
            // Unread count badge
            if (this.room.unreadCount > 0) {
              this.Badge(
                this.room.unreadCount > 99 ? '99+' : `${this.room.unreadCount}`,
                this.room.isHighlighted ? '#FF5252' : '#8D97A5'
              )
            } else if (this.room.shouldShowUnreadIndicator) {
              // Just show a dot
              Column()
                .width(10)
                .height(10)
                .borderRadius(5)
                .backgroundColor(this.room.isHighlighted ? '#FF5252' : '#8D97A5')
                .margin({ left: 8 })
            }
          }
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 12 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(this.isSelected ? '#F0FDF9' : Color.Transparent)
    .onClick(() => {
      this.onTap();
    })
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => {
          this.onLongPress();
        })
    )
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
   * Badge builder
   */
  @Builder
  Badge(text: string, color: string) {
    Text(text)
      .fontSize(12)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Medium)
      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
      .borderRadius(10)
      .backgroundColor(color)
      .margin({ left: 8 })
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
