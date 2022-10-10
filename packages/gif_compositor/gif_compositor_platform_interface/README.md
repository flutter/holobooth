# gif_compositor_platform_interface

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

A common platform interface for the `gif_compositor` plugin.

This interface allows platform-specific implementations of the `gif_compositor` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `gif_compositor`, extend `GifCompositorPlatform` with an implementation that performs the platform-specific behavior.

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis