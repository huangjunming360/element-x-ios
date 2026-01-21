/**
 * Copyright 2025 Element Creations Ltd.
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
 *
 * Element X HarmonyOS - Empty State View Component
 * Equivalent to iOS HomeScreenEmptyStateView
 */

/**
 * Empty state view component for when there is no content to display.
 */
@Component
export struct EmptyStateView {
  @Prop title: string = '';
  @Prop subtitle: string = '';
  @Prop actionLabel: string = '';
  onAction: () => void = () => {};

  build() {
    Column() {
      // Illustration placeholder
      Column() {
        Text('💬')
          .fontSize(64)
      }
      .width(120)
      .height(120)
      .borderRadius(60)
      .backgroundColor('#F0FDF9')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // Title
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17191C')
        .margin({ top: 24 })
        .textAlign(TextAlign.Center)

      // Subtitle
      if (this.subtitle.length > 0) {
        Text(this.subtitle)
          .fontSize(14)
          .fontColor('#737D8C')
          .margin({ top: 8 })
          .textAlign(TextAlign.Center)
          .padding({ left: 32, right: 32 })
      }

      // Action button
      if (this.actionLabel.length > 0) {
        Button(this.actionLabel)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .backgroundColor('#0DBD8B')
          .borderRadius(24)
          .height(48)
          .padding({ left: 32, right: 32 })
          .margin({ top: 24 })
          .onClick(() => {
            this.onAction();
          })
      }
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
  }
}
