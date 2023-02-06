abstract class Pages {
  static const String home = 'pages_home';
  static const String daily = 'pages_daily';
  static const String timeline = 'pages_timeline';
  static const String settings = 'pages_settings';
  static const String addChat = 'pages_add_chat';
  static const String editChat = 'pages_edit_chat';
  static const String tagsManage = 'settings_page_tags_title';
}

abstract class SettingsPage {
  static const String tagItem = 'settings_item_tags';
  static const String languageItem = 'settings_item_languages';
  static const String themeItem = 'settings_item_theme';
  static const String shareItem = 'settings_item_share';
  static const String shareAppText = 'settings_share_app_text';
  static const String securityItem = 'settings_item_security';
  static const String chatItem = 'settings_item_chat';
  static const String securityPageTitle = 'settings_page_security_title';

  static const String fontSizeItem = 'settings_item_font_size';
  static const String fontSizeSmall = 'settings_item_font_size_small';
  static const String fontSizeMedium = 'settings_item_font_size_medium';
  static const String fontSizeLarge = 'settings_item_font_size_large';

  static const String bubbleAlignmentItemTitle =
      'settings_item_bubble_alignment_title';
  static const String bubbleAlignmentItemSubtitle =
      'settings_item_bubble_alignment_subtitle';
  static const String centerDateBubbleItem =
      'settings_item_date_bubble_visibility';

  static const String resetItem = 'settings_item_reset';
  static const String resetConfirmationTitle =
      'settings_item_reset_confirmation_title';
  static const String resetConfirmationSubtitle =
      'settings_item_reset_confirmation_subtitle';

  static const String changeBackgroundImage =
      'settings_change_background_image';
  static const String removeBackgroundImage =
      'settings_remove_background_image';
}

abstract class Actions {
  static const String ok = 'action_ok';
  static const String yes = 'action_yes';
  static const String no = 'action_no';
  static const String cancel = 'action_cancel';
  static const String remove = 'action_remove';
  static const String add = 'action_add';
  static const String edit = 'action_edit';
  static const String delete = 'action_delete';
  static const String apply = 'action_apply';
  static const String move = 'action_move';
  static const String pin = 'action_pin';
  static const String unpin = 'action_unpin';
  static const String reset = 'action_reset';
  static const String switchToDayMode = 'action_switch_to_day_mode';
  static const String switchToNightMode = 'action_switch_to_night_mode';
}

abstract class Results {
  static const String textCopied = 'result_text_copied';
}

abstract class Hints {
  static const String inputChatName = 'input_hint_chat_name';
  static const String inputMessage = 'input_hint_message';

  static const String itemCreated = 'item_hint_created';
  static const String itemActive = 'item_hint_active';
  static const String itemMessages = 'item_hint_messages';
}

abstract class Info {
  static const String chatDeleteConfirmationTitle =
      'confirmation_chat_delete_title';
  static const String chatDeleteConfirmationContent =
      'confirmation_chat_delete_content';

  static const String messageDeleteConfirmationTitle =
      'confirmation_messages_delete_title';
  static const String messageDeleteConfirmationContent =
      'confirmation_messages_delete_content';

  static const String lastMessageRecently = 'info_last_message_recently';
  static const String lastMessageWithDays = 'info_last_message_days';
  static const String lastMessageWithDaysAndHours =
      'info_last_message_days_and_hours';

  static const String move = 'info_move';
  static const String movePlural = 'info_move_plural';
}

abstract class Other {
  static const String messageExampleText1 = 'message_example_text_1';
  static const String messageExampleText2 = 'message_example_text_2';
}
