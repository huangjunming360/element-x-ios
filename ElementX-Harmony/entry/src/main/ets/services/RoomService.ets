/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Room Service
 * Handles room list and room operations
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { RoomListItem, RoomType, RoomListMode } from '../models/RoomModels';

const DOMAIN = 0x0000;
const TAG = 'RoomService';

/**
 * Service responsible for managing Matrix rooms.
 * This handles room list retrieval, room operations, and room state.
 */
export class RoomService {
  private static instance: RoomService | null = null;
  private roomList: RoomListItem[] = [];
  private roomListMode: RoomListMode = RoomListMode.LOADING;

  private constructor() {
    hilog.info(DOMAIN, TAG, 'RoomService initialized');
  }

  /**
   * Get the singleton instance of RoomService
   */
  static getInstance(): RoomService {
    if (!RoomService.instance) {
      RoomService.instance = new RoomService();
    }
    return RoomService.instance;
  }

  /**
   * Get the current room list
   */
  getRoomList(): RoomListItem[] {
    return this.roomList;
  }

  /**
   * Get the current room list mode
   */
  getRoomListMode(): RoomListMode {
    return this.roomListMode;
  }

  /**
   * Load the room list from the Matrix server
   */
  async loadRoomList(): Promise<void> {
    hilog.info(DOMAIN, TAG, 'Loading room list');
    this.roomListMode = RoomListMode.LOADING;

    try {
      // TODO: Implement actual Matrix SDK room list loading
      // This would use the SlidingSync or traditional sync endpoint
      
      // Mock implementation for demonstration
      await this.loadMockRoomList();
      
      this.roomListMode = this.roomList.length > 0 ? 
        RoomListMode.ROOMS : RoomListMode.EMPTY;
      
      hilog.info(DOMAIN, TAG, `Loaded ${this.roomList.length} rooms`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to load room list: ${error}`);
      this.roomListMode = RoomListMode.EMPTY;
    }
  }

  /**
   * Get a specific room by ID
   */
  getRoom(roomId: string): RoomListItem | undefined {
    return this.roomList.find(room => room.id === roomId);
  }

  /**
   * Mark a room as read
   */
  async markRoomAsRead(roomId: string): Promise<void> {
    hilog.info(DOMAIN, TAG, `Marking room as read: ${roomId}`);
    // TODO: Implement Matrix read receipt sending
    
    const room = this.getRoom(roomId);
    if (room) {
      room.unreadCount = 0;
      room.hasUnreadMentions = false;
      room.hasUnreadNotifications = false;
      room.isMarkedUnread = false;
    }
  }

  /**
   * Mark a room as unread
   */
  async markRoomAsUnread(roomId: string): Promise<void> {
    hilog.info(DOMAIN, TAG, `Marking room as unread: ${roomId}`);
    // TODO: Implement Matrix marker event sending
    
    const room = this.getRoom(roomId);
    if (room) {
      room.isMarkedUnread = true;
    }
  }

  /**
   * Toggle room favourite status
   */
  async toggleFavourite(roomId: string): Promise<void> {
    const room = this.getRoom(roomId);
    if (room) {
      room.isFavourite = !room.isFavourite;
      hilog.info(DOMAIN, TAG, `Room ${roomId} favourite: ${room.isFavourite}`);
      // TODO: Implement Matrix tag update
    }
  }

  /**
   * Leave a room
   */
  async leaveRoom(roomId: string): Promise<boolean> {
    hilog.info(DOMAIN, TAG, `Leaving room: ${roomId}`);
    
    try {
      // TODO: Implement Matrix room leave
      
      // Remove from local list
      const index = this.roomList.findIndex(room => room.id === roomId);
      if (index !== -1) {
        this.roomList.splice(index, 1);
      }
      
      if (this.roomList.length === 0) {
        this.roomListMode = RoomListMode.EMPTY;
      }
      
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to leave room: ${error}`);
      return false;
    }
  }

  /**
   * Accept an invite to a room
   */
  async acceptInvite(roomId: string): Promise<boolean> {
    hilog.info(DOMAIN, TAG, `Accepting invite: ${roomId}`);
    
    try {
      // TODO: Implement Matrix join room
      
      const room = this.getRoom(roomId);
      if (room) {
        room.roomType = RoomType.ROOM;
      }
      
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to accept invite: ${error}`);
      return false;
    }
  }

  /**
   * Decline an invite to a room
   */
  async declineInvite(roomId: string): Promise<boolean> {
    hilog.info(DOMAIN, TAG, `Declining invite: ${roomId}`);
    
    try {
      // TODO: Implement Matrix leave room (to decline invite)
      
      const index = this.roomList.findIndex(room => room.id === roomId);
      if (index !== -1) {
        this.roomList.splice(index, 1);
      }
      
      return true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to decline invite: ${error}`);
      return false;
    }
  }

  /**
   * Search rooms by name or alias
   */
  searchRooms(query: string): RoomListItem[] {
    if (!query.trim()) {
      return this.roomList;
    }
    
    const lowerQuery = query.toLowerCase();
    return this.roomList.filter(room => 
      room.name.toLowerCase().includes(lowerQuery) ||
      (room.canonicalAlias?.toLowerCase().includes(lowerQuery) ?? false)
    );
  }

  /**
   * Filter rooms by criteria
   */
  filterRooms(
    showFavouritesOnly: boolean = false,
    showDirectChatsOnly: boolean = false,
    showUnreadOnly: boolean = false
  ): RoomListItem[] {
    return this.roomList.filter(room => {
      if (showFavouritesOnly && !room.isFavourite) return false;
      if (showDirectChatsOnly && !room.isDirect) return false;
      if (showUnreadOnly && !room.shouldShowUnreadIndicator) return false;
      return true;
    });
  }

  /**
   * Load mock room list for demonstration
   */
  private async loadMockRoomList(): Promise<void> {
    // Simulate network delay
    await new Promise<void>(resolve => setTimeout(resolve, 500));
    
    this.roomList = [
      new RoomListItem({
        id: '!room1:matrix.org',
        roomId: '!room1:matrix.org',
        name: 'Element X Development',
        lastMessage: 'Great progress on the HarmonyOS port!',
        lastMessageTimestamp: '10:30',
        unreadCount: 3,
        hasUnreadNotifications: true,
        isDirect: false,
        isFavourite: true,
        roomType: RoomType.ROOM
      }),
      new RoomListItem({
        id: '!room2:matrix.org',
        roomId: '!room2:matrix.org',
        name: 'Alice',
        avatarUrl: null,
        lastMessage: 'See you tomorrow!',
        lastMessageTimestamp: '09:15',
        unreadCount: 0,
        isDirect: true,
        roomType: RoomType.ROOM
      }),
      new RoomListItem({
        id: '!room3:matrix.org',
        roomId: '!room3:matrix.org',
        name: 'Matrix HQ',
        lastMessage: 'Welcome to the Matrix community!',
        lastMessageTimestamp: 'Yesterday',
        unreadCount: 42,
        hasUnreadMentions: true,
        isMuted: false,
        roomType: RoomType.ROOM
      }),
      new RoomListItem({
        id: '!room4:matrix.org',
        roomId: '!room4:matrix.org',
        name: 'HarmonyOS Developers',
        lastMessage: 'ArkTS is quite powerful!',
        lastMessageTimestamp: 'Monday',
        unreadCount: 0,
        isFavourite: true,
        roomType: RoomType.ROOM
      }),
      new RoomListItem({
        id: '!invite1:matrix.org',
        roomId: '!invite1:matrix.org',
        name: 'New Project Discussion',
        roomType: RoomType.INVITE
      })
    ];
  }

  /**
   * Clear room list (used on logout)
   */
  clear(): void {
    this.roomList = [];
    this.roomListMode = RoomListMode.LOADING;
  }
}

/**
 * Export singleton instance
 */
export const roomService = RoomService.getInstance();
