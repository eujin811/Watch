# Watch

-----------------


## 참고자료
- [Watch Document](https://developer.apple.com/documentation/watchos-apps/)
- [Design guidelines](https://developer.apple.com/design/human-interface-guidelines/platforms/designing-for-watchos/)
- [watch Forums](https://developer.apple.com/forums/tags/watchkit/)
- [WWDC 2022 WidgeKit](https://developer.apple.com/videos/play/wwdc2022/10051/)


### 기술
- 햅틱 커스텀 힘듬
  - CoreHaptics API 는 watchOS 지원 x
  - WatchKit haptic type (WKHapticType- I think it was Click) 사용해 loop 돌리면 가능하지만 클릭 사이에 100밀리초가 있어 해상도가 낮은편
  - https://developer.apple.com/forums/thread/681215
