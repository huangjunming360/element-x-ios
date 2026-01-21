/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Home Page
 * Equivalent to iOS HomeScreen.swift - displays room list
 */

import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { authService } from '../services/AuthenticationService';
import { roomService } from '../services/RoomService';
import { RoomListItem, RoomType, RoomListMode, RoomListFiltersState } from '../models/RoomModels';
import { RoomCell } from '../components/RoomCell';
import { EmptyStateView } from '../components/EmptyStateView';

const DOMAIN = 0x0000;
const TAG = 'HomePage';

/**
 * Home page displays the list of rooms.
 * Equivalent to the iOS HomeScreen.
 */
@Entry
@Component
struct HomePage {
  @State rooms: RoomListItem[] = [];
  @State filteredRooms: RoomListItem[] = [];
  @State roomListMode: RoomListMode = RoomListMode.LOADING;
  @State searchQuery: string = '';
  @State isSearchFocused: boolean = false;
  @State filtersState: RoomListFiltersState = new RoomListFiltersState();
  @State selectedRoomId: string | null = null;
  @State showFilters: boolean = false;

  // User info from session
  @State userDisplayName: string = '';
  @State userAvatarUrl: string | null = null;
  @State userId: string = '';

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, 'HomePage appearing');
    this.loadUserInfo();
    this.loadRooms();
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

  /**
   * Load room list
   */
  async loadRooms(): Promise<void> {
    hilog.info(DOMAIN, TAG, 'Loading rooms');
    this.roomListMode = RoomListMode.LOADING;

    await roomService.loadRoomList();
    
    this.rooms = roomService.getRoomList();
    this.roomListMode = roomService.getRoomListMode();
    this.applyFilters();
  }

  /**
   * Apply current filters to room list
   */
  applyFilters(): void {
    let result = this.rooms;

    // Apply search filter
    if (this.searchQuery.trim().length > 0) {
      const query = this.searchQuery.toLowerCase();
      result = result.filter(room => 
        room.name.toLowerCase().includes(query) ||
        (room.canonicalAlias?.toLowerCase().includes(query) ?? false)
      );
    }

    // Apply category filters
    if (this.filtersState.isFiltering) {
      result = result.filter(room => {
        if (this.filtersState.showFavouritesOnly && !room.isFavourite) return false;
        if (this.filtersState.showDirectChatsOnly && !room.isDirect) return false;
        if (this.filtersState.showUnreadOnly && !room.shouldShowUnreadIndicator) return false;
        return true;
      });
    }

    this.filteredRooms = result;
  }

  build() {
    Column() {
      // Navigation bar
      Row() {
        // User avatar button (Settings)
        Button() {
          this.AvatarView(this.userDisplayName, this.userAvatarUrl, 40)
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.navigateToSettings();
        })

        // Title
        Text('All Chats')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17191C')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // New chat button
        Button() {
          Text('+')
            .fontSize(24)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .backgroundColor('#0DBD8B')
        .onClick(() => {
          this.handleStartChat();
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // Search bar
      Row() {
        TextInput({ placeholder: 'Search rooms...', text: this.searchQuery })
          .width('100%')
          .height(40)
          .borderRadius(20)
          .backgroundColor('#F7F7F7')
          .padding({ left: 16, right: 16 })
          .onFocus(() => {
            this.isSearchFocused = true;
          })
          .onBlur(() => {
            this.isSearchFocused = false;
          })
          .onChange((value: string) => {
            this.searchQuery = value;
            this.applyFilters();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor('#FFFFFF')

      // Filter chips (show only when not searching)
      if (!this.isSearchFocused && this.roomListMode === RoomListMode.ROOMS) {
        Row() {
          this.FilterChip('Favourites', this.filtersState.showFavouritesOnly, () => {
            this.filtersState.showFavouritesOnly = !this.filtersState.showFavouritesOnly;
            this.applyFilters();
          })
          
          this.FilterChip('People', this.filtersState.showDirectChatsOnly, () => {
            this.filtersState.showDirectChatsOnly = !this.filtersState.showDirectChatsOnly;
            this.applyFilters();
          })
          
          this.FilterChip('Unread', this.filtersState.showUnreadOnly, () => {
            this.filtersState.showUnreadOnly = !this.filtersState.showUnreadOnly;
            this.applyFilters();
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 8 })
        .backgroundColor('#FFFFFF')
      }

      // Content
      if (this.roomListMode === RoomListMode.LOADING) {
        // Loading state
        Column() {
          ForEach([1, 2, 3, 4, 5], (item: number) => {
            this.RoomPlaceholder()
          })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#FFFFFF')
      } else if (this.roomListMode === RoomListMode.EMPTY || 
                 (this.filteredRooms.length === 0 && this.rooms.length === 0)) {
        // Empty state
        EmptyStateView({
          title: 'No conversations yet',
          subtitle: 'Start a new chat to begin messaging',
          actionLabel: 'Start Chat',
          onAction: () => {
            this.handleStartChat();
          }
        })
      } else if (this.filteredRooms.length === 0 && this.filtersState.isFiltering) {
        // Empty filter state
        Column() {
          Text('No rooms match your filters')
            .fontSize(16)
            .fontColor('#737D8C')
            .margin({ top: 48 })
          
          Button('Clear Filters')
            .fontSize(14)
            .fontColor('#0DBD8B')
            .backgroundColor(Color.Transparent)
            .margin({ top: 16 })
            .onClick(() => {
              this.filtersState.reset();
              this.applyFilters();
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#FFFFFF')
      } else {
        // Room list
        List() {
          ForEach(this.filteredRooms, (room: RoomListItem) => {
            ListItem() {
              RoomCell({
                room: room,
                isSelected: this.selectedRoomId === room.id,
                onTap: () => {
                  this.handleRoomTap(room);
                },
                onLongPress: () => {
                  this.handleRoomLongPress(room);
                }
              })
            }
          }, (room: RoomListItem) => room.id)
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#FFFFFF')
        .divider({
          strokeWidth: 0.5,
          color: '#E3E8F0',
          startMargin: 72,
          endMargin: 16
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
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
      // Placeholder avatar with initials
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
   * Filter chip builder
   */
  @Builder
  FilterChip(label: string, isSelected: boolean, onTap: () => void) {
    Button(label)
      .fontSize(13)
      .fontColor(isSelected ? Color.White : '#17191C')
      .backgroundColor(isSelected ? '#0DBD8B' : '#F0F0F0')
      .borderRadius(16)
      .height(32)
      .padding({ left: 12, right: 12 })
      .margin({ right: 8 })
      .onClick(onTap)
  }

  /**
   * Room placeholder for loading state
   */
  @Builder
  RoomPlaceholder() {
    Row() {
      // Avatar placeholder
      Column()
        .width(48)
        .height(48)
        .borderRadius(24)
        .backgroundColor('#E8E8E8')
      
      Column() {
        // Name placeholder
        Column()
          .width('60%')
          .height(16)
          .borderRadius(4)
          .backgroundColor('#E8E8E8')
        
        // Message placeholder
        Column()
          .width('80%')
          .height(12)
          .borderRadius(4)
          .backgroundColor('#E8E8E8')
          .margin({ top: 8 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 12 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
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
   * Handle room tap
   */
  handleRoomTap(room: RoomListItem): void {
    hilog.info(DOMAIN, TAG, `Room tapped: ${room.id}`);
    
    if (room.roomType === RoomType.INVITE) {
      // Show invite options
      this.handleInviteTap(room);
    } else {
      this.selectedRoomId = room.id;
      this.navigateToRoom(room);
    }
  }

  /**
   * Handle room long press
   */
  handleRoomLongPress(room: RoomListItem): void {
    hilog.info(DOMAIN, TAG, `Room long pressed: ${room.id}`);
    // TODO: Show context menu
  }

  /**
   * Handle invite tap
   */
  async handleInviteTap(room: RoomListItem): Promise<void> {
    // TODO: Show invite dialog
    hilog.info(DOMAIN, TAG, `Invite tapped: ${room.id}`);
  }

  /**
   * Navigate to room
   */
  navigateToRoom(room: RoomListItem): void {
    router.pushUrl({
      url: 'pages/RoomPage',
      params: {
        roomId: room.roomId ?? room.id,
        roomName: room.name
      }
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `Navigation error: ${error}`);
    });
  }

  /**
   * Navigate to settings
   */
  navigateToSettings(): void {
    router.pushUrl({
      url: 'pages/SettingsPage'
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `Navigation error: ${error}`);
    });
  }

  /**
   * Handle start chat button
   */
  handleStartChat(): void {
    hilog.info(DOMAIN, TAG, 'Start chat tapped');
    // TODO: Navigate to start chat screen
  }
}
