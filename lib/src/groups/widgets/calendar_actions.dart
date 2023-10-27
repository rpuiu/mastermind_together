import 'dart:html' as html;

import 'package:mastermind_together/src/groups/group_model.dart';

class CalendarActions {
  void generateIcsFile(GroupModel group) {
    String meetingDayAbbrev = dayToTwoLetter(group.meetingDay);

    // Determine the first occurrence of the meeting
    DateTime firstMeetingDate = _getFirstMeetingDate(group.meetingDay);

    // Combine the date from firstMeetingDate with the time from meetingTimeUTC
    DateTime dtStartDateTime = DateTime(
      firstMeetingDate.year,
      firstMeetingDate.month,
      firstMeetingDate.day,
      group.meetingTimeUTC.hour,
      group.meetingTimeUTC.minute,
    );

    String dtStart = toIcsDateTime(dtStartDateTime);
    String dtEnd = toIcsDateTime(dtStartDateTime.add(const Duration(hours: 1))); // Assuming a 1-hour meeting

    String currentUrl = html.window.location.href;

    String icsFileContentTemplate = '''
BEGIN:VCALENDAR\r
VERSION:2.0\r
PRODID:-//Your Company//Your App//EN\r
CALSCALE:GREGORIAN\r
BEGIN:VTIMEZONE\r
TZID:UTC\r
BEGIN:STANDARD\r
TZOFFSETFROM:+0000\r
TZOFFSETTO:+0000\r
TZNAME:UTC\r
DTSTART:19700101T000000\r
END:STANDARD\r
END:VTIMEZONE\r
BEGIN:VEVENT\r
DTSTAMP:20231027T114444Z\r
SUMMARY:${group.name}\r
DTSTART;TZID=UTC:$dtStart\r
DTEND;TZID=UTC:$dtEnd\r
DESCRIPTION:${group.description}\nURL: $currentUrl\r
UID:${group.id}\r
SEQUENCE:0\r
STATUS:CONFIRMED\r
TRANSP:OPAQUE\r
RRULE:FREQ=WEEKLY;BYDAY=$meetingDayAbbrev;\r
BEGIN:VALARM\r
TRIGGER:-PT10M\r
DESCRIPTION:Reminder\r
ACTION:DISPLAY\r
END:VALARM\r
END:VEVENT\r
END:VCALENDAR\r
''';

    String icsFileContent = icsFileContentTemplate.replaceAll('{MEETING_DAY}', meetingDayAbbrev);

    final blob = html.Blob([icsFileContent]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "meeting.ics")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  String toIcsDateTime(DateTime dateTime) {
    String formattedDate = '${dateTime.year}'
        '${dateTime.month.toString().padLeft(2, '0')}'
        '${dateTime.day.toString().padLeft(2, '0')}T'
        '${dateTime.hour.toString().padLeft(2, '0')}'
        '${dateTime.minute.toString().padLeft(2, '0')}00Z';
    return formattedDate;
  }

  DateTime _getFirstMeetingDate(String weekday) {
    DateTime today = DateTime.now();
    int todayWeekday = today.weekday;
    int meetingWeekday = _weekdayStringToInt(weekday);

    int daysUntilMeeting = (meetingWeekday - todayWeekday + 7) % 7;
    daysUntilMeeting = daysUntilMeeting == 0 ? 7 : daysUntilMeeting; // If today is the meeting day, schedule for next week

    DateTime firstMeetingDate = today.add(Duration(days: daysUntilMeeting));
    return firstMeetingDate;
  }

  int _weekdayStringToInt(String weekday) {
    switch (weekday) {
      case 'Mon':
        return DateTime.monday;
      case 'Tue':
        return DateTime.tuesday;
      case 'Wed':
        return DateTime.wednesday;
      case 'Thu':
        return DateTime.thursday;
      case 'Fri':
        return DateTime.friday;
      case 'Sat':
        return DateTime.saturday;
      case 'Sun':
        return DateTime.sunday;
      default:
        throw Exception('Invalid weekday: $weekday');
    }
  }

  String dayToTwoLetter(String day) {
    if (day.length < 2) {
      throw Exception('Invalid day: $day');
    }
    return day.substring(0, 2).toUpperCase();
  }

  String generateGoogleCalendarLink(GroupModel group) {
    DateTime firstMeetingDate = _getFirstMeetingDate(group.meetingDay);

    // Combine the date from firstMeetingDate with the time from meetingTimeUTC
    DateTime dtStartDateTime = DateTime(
      firstMeetingDate.year,
      firstMeetingDate.month,
      firstMeetingDate.day,
      group.meetingTimeLocal.hour,
      group.meetingTimeLocal.minute,
    );
    DateTime dtEndDateTime = dtStartDateTime.add(Duration(hours: 1)); // Assuming a 1-hour meeting

    // Format dates to Google Calendar link standards
    String dtStart = _toGoogleDateTimeString(dtStartDateTime);
    String dtEnd = _toGoogleDateTimeString(dtEndDateTime);

    String meetingDayAbbrev = dayToTwoLetter(group.meetingDay);
    String currentUrl = html.window.location.href;
    String description = '${group.description}\nURL: $currentUrl';
    // Constructing Google Calendar event URL
    String googleCalendarURL = 'https://www.google.com/calendar/render'
        '?action=TEMPLATE'
        '&text=${Uri.encodeComponent(group.name)}'
        '&dates=$dtStart/$dtEnd'
        '&details=${Uri.encodeComponent(description ?? '')}'
        '&location=${Uri.encodeComponent(group.location ?? '')}'
        '&recur=RRULE:FREQ=WEEKLY;BYDAY=$meetingDayAbbrev'
        '&sf=true'
        '&output=xml';

    return googleCalendarURL;
  }

  String _toGoogleDateTimeString(DateTime dateTime) {
    return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0]}Z';
  }
}
