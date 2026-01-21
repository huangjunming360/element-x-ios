/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Common Utilities
 */

/**
 * Format a timestamp to a human-readable string
 */
export function formatTimestamp(timestamp: number): string {
  const date = new Date(timestamp);
  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
  
  if (diffDays === 0) {
    // Today - show time
    return date.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' });
  } else if (diffDays === 1) {
    return 'Yesterday';
  } else if (diffDays < 7) {
    // This week - show day name
    return date.toLocaleDateString(undefined, { weekday: 'long' });
  } else {
    // Older - show date
    return date.toLocaleDateString(undefined, { month: 'short', day: 'numeric' });
  }
}

/**
 * Format a Matrix user ID to display name
 */
export function formatUserId(userId: string): string {
  // Extract localpart from @user:domain.com
  const match = userId.match(/@([^:]+):/);
  return match ? match[1] : userId;
}

/**
 * Parse Matrix content URI (mxc://) to HTTP URL
 */
export function mxcToHttp(mxcUri: string, homeserverUrl: string): string {
  if (!mxcUri || !mxcUri.startsWith('mxc://')) {
    return mxcUri;
  }
  
  // mxc://server.name/media-id -> https://homeserver/_matrix/media/v3/download/server.name/media-id
  const parts = mxcUri.replace('mxc://', '').split('/');
  if (parts.length < 2) {
    return mxcUri;
  }
  
  const serverName = parts[0];
  const mediaId = parts.slice(1).join('/');
  
  return `${homeserverUrl}/_matrix/media/v3/download/${serverName}/${mediaId}`;
}

/**
 * Get thumbnail URL for an mxc URI
 */
export function mxcToThumbnail(
  mxcUri: string, 
  homeserverUrl: string, 
  width: number = 256, 
  height: number = 256,
  method: 'crop' | 'scale' = 'crop'
): string {
  if (!mxcUri || !mxcUri.startsWith('mxc://')) {
    return mxcUri;
  }
  
  const parts = mxcUri.replace('mxc://', '').split('/');
  if (parts.length < 2) {
    return mxcUri;
  }
  
  const serverName = parts[0];
  const mediaId = parts.slice(1).join('/');
  
  return `${homeserverUrl}/_matrix/media/v3/thumbnail/${serverName}/${mediaId}?width=${width}&height=${height}&method=${method}`;
}

/**
 * Validate a Matrix user ID
 */
export function isValidUserId(userId: string): boolean {
  return /^@[a-zA-Z0-9._=\-/]+:[a-zA-Z0-9.\-]+$/.test(userId);
}

/**
 * Validate a Matrix room ID
 */
export function isValidRoomId(roomId: string): boolean {
  return /^![a-zA-Z0-9]+:[a-zA-Z0-9.\-]+$/.test(roomId);
}

/**
 * Validate a Matrix room alias
 */
export function isValidRoomAlias(alias: string): boolean {
  return /^#[a-zA-Z0-9._=\-]+:[a-zA-Z0-9.\-]+$/.test(alias);
}

/**
 * Debounce function for search input
 */
export function debounce<T extends (...args: Parameters<T>) => void>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeoutId: number | null = null;
  
  return (...args: Parameters<T>) => {
    if (timeoutId !== null) {
      clearTimeout(timeoutId);
    }
    timeoutId = setTimeout(() => {
      func(...args);
    }, wait);
  };
}

/**
 * Generate a unique local ID for optimistic updates
 */
export function generateLocalId(): string {
  return `local_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
}

/**
 * Truncate text with ellipsis
 */
export function truncateText(text: string, maxLength: number): string {
  if (text.length <= maxLength) {
    return text;
  }
  return text.substring(0, maxLength - 3) + '...';
}

/**
 * Format file size in human-readable format
 */
export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 B';
  
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  const k = 1024;
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(1))} ${units[i]}`;
}

/**
 * Format duration in human-readable format (for audio/video)
 */
export function formatDuration(seconds: number): string {
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const secs = Math.floor(seconds % 60);
  
  if (hours > 0) {
    return `${hours}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
  return `${minutes}:${secs.toString().padStart(2, '0')}`;
}
