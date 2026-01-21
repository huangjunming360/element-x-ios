/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Common Constants and Theme
 */

/**
 * Element X color palette
 */
export const Colors = {
  // Primary colors
  primary: '#0DBD8B',
  primaryDark: '#0A9B72',
  primaryLight: '#B0E5D8',
  primaryBackground: '#F0FDF9',
  
  // Secondary colors
  secondary: '#0D0D0D',
  accent: '#7B61FF',
  
  // Semantic colors
  error: '#FF5252',
  warning: '#FF9800',
  success: '#4CAF50',
  info: '#448AFF',
  
  // Background colors
  background: '#FFFFFF',
  surface: '#F7F7F7',
  surfaceVariant: '#F0F0F0',
  
  // Text colors
  textPrimary: '#17191C',
  textSecondary: '#737D8C',
  textHint: '#8D97A5',
  textDisabled: '#C4C4C4',
  textOnPrimary: '#FFFFFF',
  
  // Border and divider
  divider: '#E3E8F0',
  border: '#E0E0E0',
  
  // Badge colors
  unreadBadge: '#FF5252',
  mentionBadge: '#0DBD8B',
  mutedBadge: '#8D97A5'
};

/**
 * Typography settings
 */
export const Typography = {
  // Heading sizes
  h1: 28,
  h2: 24,
  h3: 20,
  h4: 18,
  h5: 16,
  h6: 14,
  
  // Body sizes
  bodyLarge: 16,
  bodyMedium: 15,
  bodySmall: 14,
  
  // Caption and label
  caption: 12,
  label: 13,
  
  // Font weights
  weightLight: FontWeight.Light,
  weightRegular: FontWeight.Regular,
  weightMedium: FontWeight.Medium,
  weightBold: FontWeight.Bold
};

/**
 * Spacing values
 */
export const Spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  xxl: 32
};

/**
 * Border radius values
 */
export const BorderRadius = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  round: 9999
};

/**
 * Avatar sizes
 */
export const AvatarSize = {
  xs: 24,
  sm: 32,
  md: 40,
  lg: 48,
  xl: 64,
  xxl: 80
};

/**
 * Animation durations (ms)
 */
export const AnimationDuration = {
  fast: 150,
  normal: 250,
  slow: 400
};

/**
 * App configuration constants
 */
export const AppConfig = {
  // Default Matrix homeserver
  defaultHomeserver: 'matrix.org',
  
  // App identifiers
  bundleName: 'io.element.elementx.harmony',
  appName: 'Element X',
  
  // API versions
  matrixApiVersion: 'v3',
  
  // Pagination
  defaultPageSize: 30,
  roomListPageSize: 50,
  timelinePageSize: 50,
  
  // Timeouts (ms)
  networkTimeout: 30000,
  longPollTimeout: 30000,
  
  // Cache settings
  maxCachedRooms: 100,
  maxCachedMessages: 1000,
  
  // Media settings
  maxImageSize: 4096,
  thumbnailSize: 256,
  maxUploadSize: 100 * 1024 * 1024, // 100MB
  
  // Search debounce
  searchDebounceMs: 300
};

/**
 * Accessibility identifiers for testing
 */
export const A11yIdentifiers = {
  homeScreen: {
    userAvatar: 'home_user_avatar',
    startChat: 'home_start_chat',
    roomList: 'home_room_list',
    searchField: 'home_search_field'
  },
  loginScreen: {
    homeserverField: 'login_homeserver',
    usernameField: 'login_username',
    passwordField: 'login_password',
    signInButton: 'login_sign_in'
  },
  roomScreen: {
    messageList: 'room_message_list',
    composer: 'room_composer',
    sendButton: 'room_send_button'
  },
  settingsScreen: {
    signOutButton: 'settings_sign_out'
  }
};
