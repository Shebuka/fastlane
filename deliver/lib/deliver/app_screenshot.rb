require 'fastimage'

require_relative 'module'
require 'spaceship/connect_api/models/app_screenshot_set'

module Deliver
  # AppScreenshot represents one screenshots for one specific locale and
  # device type.
  class AppScreenshot
    # Updated to reflect current requirements listed in https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications
    module ScreenSize
      # iPhone 4S, iPhone 4
      IOS_35 = "iOS-3.5-in"
      # iPhone SE (1st generation), iPhone 5S, iPhone 5C, iPhone 5
      IOS_40 = "iOS-4-in"
      # iPhone SE (3rd generation, 2nd generation), iPhone 8, iPhone 7, iPhone 6S, iPhone 6
      IOS_47 = "iOS-4.7-in"
      # iPhone 8 Plus, iPhone 7 Plus, iPhone 6S Plus, iPhone 6 Plus
      IOS_55 = "iOS-5.5-in"
      # iPhone 16e, iPhone 14, iPhone 13 Pro, iPhone 13, iPhone 13 mini, iPhone 12 Pro, iPhone 12, iPhone 12 mini, iPhone 11 Pro, iPhone XS, iPhone X
      IOS_61 = "iOS-6.1-in"
      # iPhone 16 Pro, iPhone 16, iPhone 15 Pro, iPhone 15, iPhone 14 Pro
      IOS_63 = "iOS-6.3-in"
      # iPhone 14 Plus, iPhone 13 Pro Max, iPhone 12 Pro Max, iPhone 11 Pro Max, iPhone 11, iPhone XS Max, iPhone XR
      IOS_65 = "iOS-6.5-in"
      # iPhone 16 Pro Max, iPhone 16 Plus, iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
      IOS_69 = "iOS-6.9-in"

      # iPad Pro, iPad Air, iPad Air 2, iPad, iPad 2, iPad (6th generation, 5th generation, 4th generation, 3rd generation), iPad mini (5th generation), iPad mini 4, iPad mini 3, iPad mini 2
      IOS_IPAD_9_7 = "iOS-iPad-9.7-in"
      # iPad Pro, iPad Air (3rd generation), iPad (9th generation, 8th generation, 7th generation)
      IOS_IPAD_10_5 = "iOS-iPad-10.5-in"
      # iPad Pro (M4), iPad Pro (4th generation, 3rd generation, 2nd generation, 1st generation), iPad Air (M3, M2), iPad Air (5th generation, 4th generation), iPad (A16), iPad (10th generation), iPad mini (A17 Pro), iPad mini (6th generation)
      IOS_IPAD_11 = "iOS-iPad-11-in"
      # iPad Pro (2nd generation)
      IOS_IPAD_12_9 = "iOS-iPad-12.9-in"
      # iPad Pro (M4), iPad Pro (6th generation, 5th generation, 4th generation, 3rd generation, 1st generation), iPad Air (M3, M2)
      IOS_IPAD_13 = "iOS-iPad-13-in"

      # iPhone 4S, iPhone 4
      IOS_35_MESSAGES = "iOS-3.5-in-messages"
      # iPhone SE (1st generation), iPhone 5S, iPhone 5C, iPhone 5
      IOS_40_MESSAGES = "iOS-4-in-messages"
      # iPhone SE (3rd generation, 2nd generation), iPhone 8, iPhone 7, iPhone 6S, iPhone 6
      IOS_47_MESSAGES = "iOS-4.7-in-messages"
      # iPhone 8 Plus, iPhone 7 Plus, iPhone 6S Plus, iPhone 6 Plus
      IOS_55_MESSAGES = "iOS-5.5-in-messages"
      # iPhone 16e, iPhone 14, iPhone 13 Pro, iPhone 13, iPhone 13 mini, iPhone 12 Pro, iPhone 12, iPhone 12 mini, iPhone 11 Pro, iPhone XS, iPhone X
      IOS_61_MESSAGES = "iOS-6.1-in-messages"
      # iPhone 16 Pro, iPhone 16, iPhone 15 Pro, iPhone 15, iPhone 14 Pro
      IOS_63_MESSAGES = "iOS-6.3-in-messages"
      # iPhone 14 Plus, iPhone 13 Pro Max, iPhone 12 Pro Max, iPhone 11 Pro Max, iPhone 11, iPhone XS Max, iPhone XR
      IOS_65_MESSAGES = "iOS-6.5-in-messages"
      # iPhone 16 Pro Max, iPhone 16 Plus, iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
      IOS_69_MESSAGES = "iOS-6.9-in-messages"

      # iPad Pro, iPad Air, iPad Air 2, iPad, iPad 2, iPad (6th generation, 5th generation, 4th generation, 3rd generation), iPad mini (5th generation), iPad mini 4, iPad mini 3, iPad mini 2
      IOS_IPAD_9_7_MESSAGES = "iOS-iPad-9.7-in-messages"
      # iPad Pro, iPad Air (3rd generation), iPad (9th generation, 8th generation, 7th generation)
      IOS_IPAD_10_5_MESSAGES = "iOS-iPad-10.5-in-messages"
      # iPad Pro (M4), iPad Pro (4th generation, 3rd generation, 2nd generation, 1st generation), iPad Air (M3, M2), iPad Air (5th generation, 4th generation), iPad (A16), iPad (10th generation), iPad mini (A17 Pro), iPad mini (6th generation)
      IOS_IPAD_11_MESSAGES = "iOS-iPad-11-in-messages"
      # iPad Pro (2nd generation)
      IOS_IPAD_12_9_MESSAGES = "iOS-iPad-12.9-in-messages"
      # iPad Pro (M4), iPad Pro (6th generation, 5th generation, 4th generation, 3rd generation, 1st generation), iPad Air (M3, M2)
      IOS_IPAD_13_MESSAGES = "iOS-iPad-13-in-messages"

      # Apple Watch Series 3
      IOS_APPLE_WATCH_SERIES_3 = "iOS-Apple-Watch-Series-3"
      # Apple Watch Series 4
      IOS_APPLE_WATCH_SERIES_4 = "iOS-Apple-Watch-Series-4"
      # Apple Watch Series 7
      IOS_APPLE_WATCH_SERIES_7 = "iOS-Apple-Watch-Series-7"
      # Apple Watch Series 10
      IOS_APPLE_WATCH_SERIES_10 = "iOS-Apple-Watch-Series-10"
      # Apple Watch Ultra
      IOS_APPLE_WATCH_ULTRA = "iOS-Apple-Watch-Ultra"

      # Apple TV
      APPLE_TV = "Apple-TV"

      # Mac
      MAC = "Mac"

      # Apple Vision Pro
      VISION_PRO = "Vision-Pro"
    end

    # @return [Deliver::ScreenSize] the screen size (device type)
    #  specified at {Deliver::ScreenSize}
    attr_accessor :screen_size

    attr_accessor :path

    attr_accessor :language

    # @param path (String) path to the screenshot file
    # @param language (String) Language of this screenshot (e.g. English)
    # @param screen_size (Deliver::AppScreenshot::ScreenSize) the screen size, which
    #  will automatically be calculated when you don't set it. (Deprecated)
    def initialize(path, language, screen_size = nil)
      UI.deprecated('`screen_size` for Deliver::AppScreenshot.new is deprecated in favor of the default behavior to calculate size automatically. Passed value is no longer validated.') if screen_size
      self.path = path
      self.language = language
      self.screen_size = screen_size || self.class.calculate_screen_size(path)
    end

    # The iTC API requires a different notation for the device
    def device_type
      matching = {
        ScreenSize::IOS_35 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_35,
        ScreenSize::IOS_40 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_40,
        ScreenSize::IOS_47 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_47, # also 7 & 8
        ScreenSize::IOS_55 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_55, # also 7 Plus & 8 Plus
        ScreenSize::IOS_61 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_61,
        ScreenSize::IOS_63 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_63,
        ScreenSize::IOS_65 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_65,
        ScreenSize::IOS_69 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPHONE_69,
        ScreenSize::IOS_IPAD_9_7 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_97,
        ScreenSize::IOS_IPAD_10_5 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_105,
        ScreenSize::IOS_IPAD_11 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_11,
        ScreenSize::IOS_IPAD_12_9 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_129,
        ScreenSize::IOS_IPAD_13 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_IPAD_13,
        ScreenSize::IOS_40_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_40,
        ScreenSize::IOS_47_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_47, # also 7 & 8
        ScreenSize::IOS_55_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_55, # also 7 Plus & 8 Plus
        ScreenSize::IOS_61_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_61,
        ScreenSize::IOS_63_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_63,
        ScreenSize::IOS_65_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_65,
        ScreenSize::IOS_69_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPHONE_69,
        ScreenSize::IOS_IPAD_9_7_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_97,
        ScreenSize::IOS_IPAD_10_5_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_105,
        ScreenSize::IOS_IPAD_11_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_11,
        ScreenSize::IOS_IPAD_12_9_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_129,
        ScreenSize::IOS_IPAD_13_MESSAGES => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::IMESSAGE_APP_IPAD_13,
        ScreenSize::MAC => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_DESKTOP,
        ScreenSize::IOS_APPLE_WATCH_SERIES_3 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_3,
        ScreenSize::IOS_APPLE_WATCH_SERIES_4 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_4,
        ScreenSize::IOS_APPLE_WATCH_SERIES_7 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_7,
        ScreenSize::IOS_APPLE_WATCH_SERIES_10 => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_SERIES_10,
        ScreenSize::IOS_APPLE_WATCH_ULTRA => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_WATCH_ULTRA,
        ScreenSize::APPLE_TV => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_APPLE_TV,
        ScreenSize::VISION_PRO => Spaceship::ConnectAPI::AppScreenshotSet::DisplayType::APP_VISION_PRO
      }
      return matching[self.screen_size]
    end

    # Nice name
    def formatted_name
      matching = {
        ScreenSize::IOS_35 => "iPhone 4S",
        ScreenSize::IOS_40 => "iPhone SE (1st generation)",
        ScreenSize::IOS_47 => "iPhone SE (3rd generation)",
        ScreenSize::IOS_55 => "iPhone 8 Plus",
        ScreenSize::IOS_61 => "iPhone 16e",
        ScreenSize::IOS_63 => "iPhone 16 Pro",
        ScreenSize::IOS_65 => "iPhone 14 Plus",
        ScreenSize::IOS_69 => "iPhone 16 Pro Max",
        ScreenSize::IOS_IPAD_9_7 => "iPad Pro 9.7",
        ScreenSize::IOS_IPAD_10_5 => "iPad Pro 10.5",
        ScreenSize::IOS_IPAD_11 => "iPad Pro 11 (M4)",
        ScreenSize::IOS_IPAD_12_9 => "iPad Pro (2nd generation)",
        ScreenSize::IOS_IPAD_13 => "iPad Pro 13 (M4)",
        ScreenSize::IOS_35_MESSAGES => "iPhone 4S (iMessage)",
        ScreenSize::IOS_40_MESSAGES => "iPhone SE (1st generation) (iMessage)",
        ScreenSize::IOS_47_MESSAGES => "iPhone SE (3rd generation) (iMessage)",
        ScreenSize::IOS_55_MESSAGES => "iPhone 8 Plus (iMessage)",
        ScreenSize::IOS_61_MESSAGES => "iPhone 16e (iMessage)",
        ScreenSize::IOS_63_MESSAGES => "iPhone 16 Pro (iMessage)",
        ScreenSize::IOS_65_MESSAGES => "iPhone 14 Plus (iMessage)",
        ScreenSize::IOS_69_MESSAGES => "iPhone 16 Pro Max (iMessage)",
        ScreenSize::IOS_IPAD_9_7_MESSAGES => "iPad Pro 9.7 (iMessage)",
        ScreenSize::IOS_IPAD_10_5_MESSAGES => "iPad Pro 10.5 (iMessage)",
        ScreenSize::IOS_IPAD_11_MESSAGES => "iPad Pro 11 (M4) (iMessage)",
        ScreenSize::IOS_IPAD_12_9_MESSAGES => "iPad Pro (2nd generation) (iMessage)",
        ScreenSize::IOS_IPAD_13_MESSAGES => "iPad Pro 13 (M4) (iMessage)",
        ScreenSize::MAC => "Mac",
        ScreenSize::IOS_APPLE_WATCH_SERIES_3 => "Watch Series-3",
        ScreenSize::IOS_APPLE_WATCH_SERIES_4 => "Watch Series-4",
        ScreenSize::IOS_APPLE_WATCH_SERIES_7 => "Watch Series-7",
        ScreenSize::IOS_APPLE_WATCH_SERIES_10 => "Watch Series-10",
        ScreenSize::IOS_APPLE_WATCH_ULTRA => "Watch Ultra",
        ScreenSize::APPLE_TV => "Apple TV",
        ScreenSize::VISION_PRO => "Vision Pro"
      }
      return matching[self.screen_size]
    end

    # Validates the given screenshots (size and format)
    def is_valid?
      UI.deprecated('Deliver::AppScreenshot#is_valid? is deprecated in favor of Deliver::AppScreenshotValidator')
      return false unless ["png", "PNG", "jpg", "JPG", "jpeg", "JPEG"].include?(self.path.split(".").last)

      return self.screen_size == self.class.calculate_screen_size(self.path)
    end

    def is_messages?
      return [
        ScreenSize::IOS_40_MESSAGES,
        ScreenSize::IOS_47_MESSAGES,
        ScreenSize::IOS_55_MESSAGES,
        ScreenSize::IOS_61_MESSAGES,
        ScreenSize::IOS_63_MESSAGES,
        ScreenSize::IOS_65_MESSAGES,
        ScreenSize::IOS_69_MESSAGES,
        ScreenSize::IOS_IPAD_9_7_MESSAGES,
        ScreenSize::IOS_IPAD_10_5_MESSAGES,
        ScreenSize::IOS_IPAD_11_MESSAGES,
        ScreenSize::IOS_IPAD_12_9_MESSAGES,
        ScreenSize::IOS_IPAD_13_MESSAGES
      ].include?(self.screen_size)
    end

    def self.device_messages
      # This list does not include iPad Pro 12.9-inch (2nd generation)
      # because it has same resolution as IOS_IPAD_13 and will clobber
      return {
        ScreenSize::IOS_35_MESSAGES => [
          [640, 920],
          [640, 960],
          [960, 600],
          [960, 640]
        ],
        ScreenSize::IOS_40_MESSAGES => [
          [640, 1096],
          [640, 1136],
          [1136, 600],
          [1136, 640]
        ],
        ScreenSize::IOS_47_MESSAGES => [
          [750, 1334],
          [1334, 750]
        ],
        ScreenSize::IOS_55_MESSAGES => [
          [1242, 2208],
          [2208, 1242]
        ],
        ScreenSize::IOS_61_MESSAGES => [
          [1170, 2532],
          [2532, 1170],
          [1125, 2436],
          [2436, 1125],
          [1080, 2340],
          [2340, 1080]
        ],
        ScreenSize::IOS_63_MESSAGES => [
          [1179, 2556],
          [2556, 1179],
          [1206, 2622],
          [2622, 1206]
        ],
        ScreenSize::IOS_65_MESSAGES => [
          [1242, 2688],
          [2688, 1242],
          [1284, 2778],
          [2778, 1284]
        ],
        ScreenSize::IOS_69_MESSAGES => [
          [1290, 2796],
          [2796, 1290],
          [1320, 2868],
          [2868, 1320]
        ],
        ScreenSize::IOS_IPAD_9_7_MESSAGES => [
          [1536, 2008],
          [1536, 2048],
          [2048, 1496],
          [2048, 1536],
          [768, 1004],
          [768, 1024],
          [1024, 748],
          [1024, 768]
        ],
        ScreenSize::IOS_IPAD_10_5_MESSAGES => [
          [1668, 2224],
          [2224, 1668]
        ],
        ScreenSize::IOS_IPAD_11_MESSAGES => [
          [1488, 2266],
          [2266, 1488],
          [1668, 2420],
          [2420, 1668],
          [1668, 2388],
          [2388, 1668],
          [1640, 2360],
          [2360, 1640]
        ],
        ScreenSize::IOS_IPAD_13_MESSAGES => [
          [2732, 2048],
          [2048, 2732],
          [2752, 2064],
          [2064, 2752]
        ]
      }
    end

    # reference: https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications
    def self.devices
      # This list does not include iPad Pro 12.9-inch (2nd generation)
      # because it has same resolution as IOS_IPAD_13 and will clobber
      return {
        ScreenSize::IOS_35 => [
          [640, 920],
          [640, 960],
          [960, 600],
          [960, 640]
        ],
        ScreenSize::IOS_40 => [
          [640, 1096],
          [640, 1136],
          [1136, 600],
          [1136, 640]
        ],
        ScreenSize::IOS_47 => [
          [750, 1334],
          [1334, 750]
        ],
        ScreenSize::IOS_55 => [
          [1242, 2208],
          [2208, 1242]
        ],
        ScreenSize::IOS_61 => [
          [1170, 2532],
          [2532, 1170],
          [1125, 2436],
          [2436, 1125],
          [1080, 2340],
          [2340, 1080]
        ],
        ScreenSize::IOS_63 => [
          [1179, 2556],
          [2556, 1179],
          [1206, 2622],
          [2622, 1206]
        ],
        ScreenSize::IOS_65 => [
          [1284, 2778],
          [2778, 1284],
          [1242, 2688],
          [2688, 1242]
        ],
        ScreenSize::IOS_69 => [
          [1290, 2796],
          [2796, 1290],
          [1320, 2868],
          [2868, 1320]
        ],
        ScreenSize::IOS_IPAD_9_7 => [
          [1536, 2008],
          [1536, 2048],
          [2048, 1496],
          [2048, 1536],
          [768, 1004],
          [768, 1024],
          [1024, 748],
          [1024, 768]
        ],
        ScreenSize::IOS_IPAD_10_5 => [
          [1668, 2224],
          [2224, 1668]
        ],
        ScreenSize::IOS_IPAD_11 => [
          [1488, 2266],
          [2266, 1488],
          [1668, 2420],
          [2420, 1668],
          [1668, 2388],
          [2388, 1668],
          [1640, 2360],
          [2360, 1640]
        ],
        ScreenSize::IOS_IPAD_13 => [
          [2064, 2752],
          [2752, 2064],
          [2048, 2732],
          [2732, 2048]
        ],
        ScreenSize::MAC => [
          [1280, 800],
          [1440, 900],
          [2560, 1600],
          [2880, 1800]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_3 => [
          [312, 390]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_4 => [
          [368, 448]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_7 => [
          [396, 484]
        ],
        ScreenSize::IOS_APPLE_WATCH_SERIES_10 => [
          [416, 496]
        ],
        ScreenSize::IOS_APPLE_WATCH_ULTRA => [
          [410, 502]
        ],
        ScreenSize::APPLE_TV => [
          [1920, 1080],
          [3840, 2160]
        ],
        ScreenSize::VISION_PRO => [
          [3840, 2160]
        ]
      }
    end

    def self.resolve_ipadpro_conflict_if_needed(screen_size, filename)
      is_3rd_gen = [
        "iPad Pro (12.9-inch) (3rd generation)", # Default simulator has this name
        "iPad Pro (12.9-inch) (4th generation)", # Default simulator has this name
        "iPad Pro (12.9-inch) (5th generation)", # Default simulator has this name
        "iPad Pro (12.9-inch) (6th generation)", # Default simulator has this name
        "IPAD_PRO_3GEN_129", # Screenshots downloaded from App Store Connect has this name
        "ipadPro129" # Legacy: screenshots downloaded from iTunes Connect used to have this name
      ].any? { |key| filename.include?(key) }
      if is_3rd_gen
        if screen_size == ScreenSize::IOS_IPAD_13
          return ScreenSize::IOS_IPAD_12_9
        elsif screen_size == ScreenSize::IOS_IPAD_13_MESSAGES
          return ScreenSize::IOS_IPAD_12_9_MESSAGES
        end
      end
      screen_size
    end

    def self.calculate_screen_size(path)
      size = FastImage.size(path)

      UI.user_error!("Could not find or parse file at path '#{path}'") if size.nil? || size.count == 0

      # iMessage screenshots have same resolution as app screenshots so we need to distinguish them
      path_component = Pathname.new(path).each_filename.to_a[-3]
      devices = path_component.eql?("iMessage") ? self.device_messages : self.devices

      devices.each do |screen_size, resolutions|
        if resolutions.include?(size)
          filename = Pathname.new(path).basename.to_s
          return resolve_ipadpro_conflict_if_needed(screen_size, filename)
        end
      end

      nil
    end
  end

  ScreenSize = AppScreenshot::ScreenSize
end
