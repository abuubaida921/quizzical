class Assets {
  Assets._(); // prevent instantiation

  static const _imagesDir = 'assets/images';
  static const _iconsDir = 'assets/icons';
  static const _lottieDir = 'assets/lottie';

  static AssetImages get assetImages => const AssetImages();
  static AssetIcons get assetIcons => const AssetIcons();
  static AssetLottie get assetLottie => const AssetLottie();
}

class AssetImages {
  const AssetImages();

  // Welcome / onboarding
  final String welcomeIllustration = '${Assets._imagesDir}/ic_welcome_illustration.png';
  final String splashLogo = '${Assets._imagesDir}/splash_logo.png';

  // Generic placeholders
  final String placeholderAvatar = '${Assets._imagesDir}/placeholder_avatar.png';
  final String placeholderImage = '${Assets._imagesDir}/placeholder_image.png';

  // Feature-specific images
  final String categoryIllustration = '${Assets._imagesDir}/category_illustration.png';
  final String emptyState = '${Assets._imagesDir}/empty_state.png';
}

class AssetIcons {
  const AssetIcons();

  // PNG/SVG icon files (use SvgPicture.asset for svg)
  final String back = '${Assets._iconsDir}/ic_back.png';
  final String menu = '${Assets._iconsDir}/ic_menu.png';
  final String close = '${Assets._iconsDir}/ic_close.png';

  // semantic icon names for app domain
  final String question = '${Assets._iconsDir}/ic_question.svg';
  final String correct = '${Assets._iconsDir}/ic_correct.svg';
  final String incorrect = '${Assets._iconsDir}/ic_incorrect.svg';
}

class AssetLottie {
  const AssetLottie();

  final String confetti = '${Assets._lottieDir}/confetti.json';
  final String loading = '${Assets._lottieDir}/loading.json';
}