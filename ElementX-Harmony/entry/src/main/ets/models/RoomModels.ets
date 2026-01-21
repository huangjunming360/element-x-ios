/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Room Models
 * Equivalent to iOS HomeScreenModels.swift
 */

/**
 * Represents a room in the room list.
 * This is equivalent to HomeScreenRoom in the iOS version.
 */
@Observed
export class RoomListItem {
  id: string;
  roomId: string | null;
  name: string;
  avatarUrl: string | null;
  lastMessage: string | null;
  lastMessageTimestamp: string | null;
  unreadCount: number;
  hasUnreadMentions: boolean;
  hasUnreadNotifications: boolean;
  isMarkedUnread: boolean;
  isMuted: boolean;
  isDirect: boolean;
  isFavourite: boolean;
  hasOngoingCall: boolean;
  roomType: RoomType;
  canonicalAlias: string | null;

  constructor(params: RoomListItemParams) {
    this.id = params.id;
    this.roomId = params.roomId ?? null;
    this.name = params.name;
    this.avatarUrl = params.avatarUrl ?? null;
    this.lastMessage = params.lastMessage ?? null;
    this.lastMessageTimestamp = params.lastMessageTimestamp ?? null;
    this.unreadCount = params.unreadCount ?? 0;
    this.hasUnreadMentions = params.hasUnreadMentions ?? false;
    this.hasUnreadNotifications = params.hasUnreadNotifications ?? false;
    this.isMarkedUnread = params.isMarkedUnread ?? false;
    this.isMuted = params.isMuted ?? false;
    this.isDirect = params.isDirect ?? false;
    this.isFavourite = params.isFavourite ?? false;
    this.hasOngoingCall = params.hasOngoingCall ?? false;
    this.roomType = params.roomType ?? RoomType.ROOM;
    this.canonicalAlias = params.canonicalAlias ?? null;
  }

  /**
   * Whether the room should show an unread indicator
   */
  get shouldShowUnreadIndicator(): boolean {
    return this.unreadCount > 0 || this.hasUnreadMentions || 
           this.hasUnreadNotifications || this.isMarkedUnread;
  }

  /**
   * Whether the room should be highlighted (has important unread content)
   */
  get isHighlighted(): boolean {
    return this.isMarkedUnread || 
           (!this.isMuted && (this.hasUnreadNotifications || this.hasUnreadMentions));
  }

  /**
   * Create a placeholder room for loading states
   */
  static placeholder(): RoomListItem {
    return new RoomListItem({
      id: `placeholder_${Date.now()}_${Math.random()}`,
      roomId: null,
      name: 'Loading...',
      roomType: RoomType.PLACEHOLDER
    });
  }
}

/**
 * Parameters for creating a RoomListItem
 */
interface RoomListItemParams {
  id: string;
  roomId?: string | null;
  name: string;
  avatarUrl?: string | null;
  lastMessage?: string | null;
  lastMessageTimestamp?: string | null;
  unreadCount?: number;
  hasUnreadMentions?: boolean;
  hasUnreadNotifications?: boolean;
  isMarkedUnread?: boolean;
  isMuted?: boolean;
  isDirect?: boolean;
  isFavourite?: boolean;
  hasOngoingCall?: boolean;
  roomType?: RoomType;
  canonicalAlias?: string | null;
}

/**
 * Room type enumeration
 */
export enum RoomType {
  PLACEHOLDER = 'placeholder',
  ROOM = 'room',
  INVITE = 'invite',
  KNOCK = 'knock'
}

/**
 * Represents an inviter in a room invite
 */
export interface RoomInviterDetails {
  userId: string;
  displayName: string | null;
  avatarUrl: string | null;
}

/**
 * Room list display mode
 */
export enum RoomListMode {
  LOADING = 'loading',
  EMPTY = 'empty',
  ROOMS = 'rooms'
}

/**
 * Room list filter state
 */
@Observed
export class RoomListFiltersState {
  showFavouritesOnly: boolean = false;
  showDirectChatsOnly: boolean = false;
  showUnreadOnly: boolean = false;

  get isFiltering(): boolean {
    return this.showFavouritesOnly || this.showDirectChatsOnly || this.showUnreadOnly;
  }

  reset(): void {
    this.showFavouritesOnly = false;
    this.showDirectChatsOnly = false;
    this.showUnreadOnly = false;
  }
}
