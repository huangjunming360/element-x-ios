/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Avatar Component
 * Reusable avatar component with initials fallback
 */

/**
 * Avatar component for displaying user/room avatars with initials fallback.
 */
@Component
export struct Avatar {
  @Prop name: string = '';
  @Prop avatarUrl: string | null = null;
  @Prop size: number = 40;
  @Prop contentId: string = '';

  build() {
    if (this.avatarUrl && this.avatarUrl.length > 0) {
      Image(this.avatarUrl)
        .width(this.size)
        .height(this.size)
        .borderRadius(this.size / 2)
        .objectFit(ImageFit.Cover)
    } else {
      Column() {
        Text(this.getInitials())
          .fontSize(this.size * 0.4)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
      .width(this.size)
      .height(this.size)
      .borderRadius(this.size / 2)
      .backgroundColor(this.getColor())
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }

  /**
   * Get initials from name
   */
  private getInitials(): string {
    const name = this.name || this.contentId;
    if (!name) return '?';
    
    // Remove @ prefix if present (for Matrix IDs)
    const cleanName = name.startsWith('@') ? name.substring(1) : name;
    
    const parts = cleanName.split(/[\s:]+/).filter(p => p.length > 0);
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return cleanName.substring(0, 2).toUpperCase();
  }

  /**
   * Get consistent color based on content ID or name
   */
  private getColor(): string {
    const colors = [
      '#0DBD8B', // Element green
      '#7B61FF', // Purple
      '#FF5252', // Red
      '#448AFF', // Blue
      '#FF9800', // Orange
      '#4CAF50', // Green
      '#9C27B0', // Deep purple
      '#00BCD4', // Cyan
      '#795548', // Brown
      '#607D8B'  // Blue grey
    ];
    
    const input = this.contentId || this.name;
    let hash = 0;
    for (let i = 0; i < input.length; i++) {
      hash = input.charCodeAt(i) + ((hash << 5) - hash);
    }
    return colors[Math.abs(hash) % colors.length];
  }
}

/**
 * Room avatar specific component
 */
@Component
export struct RoomAvatar {
  @Prop roomId: string = '';
  @Prop roomName: string = '';
  @Prop avatarUrl: string | null = null;
  @Prop size: number = 48;
  @Prop isDirect: boolean = false;

  build() {
    Avatar({
      name: this.roomName,
      avatarUrl: this.avatarUrl,
      size: this.size,
      contentId: this.roomId
    })
  }
}

/**
 * User avatar specific component
 */
@Component
export struct UserAvatar {
  @Prop userId: string = '';
  @Prop displayName: string = '';
  @Prop avatarUrl: string | null = null;
  @Prop size: number = 40;

  build() {
    Avatar({
      name: this.displayName || this.userId,
      avatarUrl: this.avatarUrl,
      size: this.size,
      contentId: this.userId
    })
  }
}
