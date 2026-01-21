/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Timeline/Message Models
 */

/**
 * Represents a message in a room timeline
 */
@Observed
export class TimelineEvent {
  eventId: string;
  roomId: string;
  senderId: string;
  senderDisplayName: string | null;
  senderAvatarUrl: string | null;
  timestamp: number;
  content: EventContent;
  isLocalEcho: boolean;
  sendState: SendState;

  constructor(params: TimelineEventParams) {
    this.eventId = params.eventId;
    this.roomId = params.roomId;
    this.senderId = params.senderId;
    this.senderDisplayName = params.senderDisplayName ?? null;
    this.senderAvatarUrl = params.senderAvatarUrl ?? null;
    this.timestamp = params.timestamp;
    this.content = params.content;
    this.isLocalEcho = params.isLocalEcho ?? false;
    this.sendState = params.sendState ?? SendState.SENT;
  }

  /**
   * Get formatted timestamp
   */
  get formattedTime(): string {
    const date = new Date(this.timestamp);
    return date.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' });
  }

  /**
   * Whether this message is from the current user
   */
  isFromUser(userId: string): boolean {
    return this.senderId === userId;
  }
}

interface TimelineEventParams {
  eventId: string;
  roomId: string;
  senderId: string;
  senderDisplayName?: string | null;
  senderAvatarUrl?: string | null;
  timestamp: number;
  content: EventContent;
  isLocalEcho?: boolean;
  sendState?: SendState;
}

/**
 * Event content types
 */
export type EventContent = TextMessageContent | ImageMessageContent | 
                           VideoMessageContent | FileMessageContent | 
                           AudioMessageContent | StateEventContent;

export interface TextMessageContent {
  type: 'text';
  body: string;
  formattedBody?: string;
}

export interface ImageMessageContent {
  type: 'image';
  body: string;
  url: string;
  thumbnailUrl?: string;
  width?: number;
  height?: number;
  mimeType?: string;
  size?: number;
}

export interface VideoMessageContent {
  type: 'video';
  body: string;
  url: string;
  thumbnailUrl?: string;
  width?: number;
  height?: number;
  duration?: number;
  mimeType?: string;
  size?: number;
}

export interface FileMessageContent {
  type: 'file';
  body: string;
  url: string;
  mimeType?: string;
  size?: number;
}

export interface AudioMessageContent {
  type: 'audio';
  body: string;
  url: string;
  duration?: number;
  mimeType?: string;
  size?: number;
}

export interface StateEventContent {
  type: 'state';
  stateKey: string;
  body: string;
}

/**
 * Message send state
 */
export enum SendState {
  NOT_SENT = 'notSent',
  SENDING = 'sending',
  SENT = 'sent',
  FAILED = 'failed'
}

/**
 * Reaction to a message
 */
export interface Reaction {
  key: string;
  count: number;
  isFromCurrentUser: boolean;
}

/**
 * Read receipt information
 */
export interface ReadReceipt {
  userId: string;
  displayName: string | null;
  avatarUrl: string | null;
  timestamp: number;
}
