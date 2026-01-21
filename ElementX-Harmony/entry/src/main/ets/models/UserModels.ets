/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - User Models
 */

/**
 * Represents the current user session
 */
@Observed
export class UserSession {
  userId: string;
  displayName: string | null;
  avatarUrl: string | null;
  homeserverUrl: string;
  accessToken: string;
  deviceId: string;
  isLoggedIn: boolean;

  constructor(params: UserSessionParams) {
    this.userId = params.userId;
    this.displayName = params.displayName ?? null;
    this.avatarUrl = params.avatarUrl ?? null;
    this.homeserverUrl = params.homeserverUrl;
    this.accessToken = params.accessToken;
    this.deviceId = params.deviceId;
    this.isLoggedIn = params.isLoggedIn ?? true;
  }

  /**
   * Get the user's display name or fallback to user ID
   */
  get effectiveDisplayName(): string {
    return this.displayName ?? this.userId;
  }

  /**
   * Get the localpart of the user ID (without @domain)
   */
  get localpart(): string {
    const match = this.userId.match(/@([^:]+):/);
    return match ? match[1] : this.userId;
  }
}

interface UserSessionParams {
  userId: string;
  displayName?: string | null;
  avatarUrl?: string | null;
  homeserverUrl: string;
  accessToken: string;
  deviceId: string;
  isLoggedIn?: boolean;
}

/**
 * Represents a Matrix user profile
 */
export interface UserProfile {
  userId: string;
  displayName: string | null;
  avatarUrl: string | null;
}

/**
 * Authentication state
 */
export enum AuthenticationState {
  UNKNOWN = 'unknown',
  SIGNED_OUT = 'signedOut',
  SIGNING_IN = 'signingIn',
  SIGNED_IN = 'signedIn',
  SIGNING_OUT = 'signingOut'
}

/**
 * Login credentials
 */
export interface LoginCredentials {
  homeserverUrl: string;
  username: string;
  password: string;
}

/**
 * Login result
 */
export interface LoginResult {
  success: boolean;
  session?: UserSession;
  error?: string;
}
