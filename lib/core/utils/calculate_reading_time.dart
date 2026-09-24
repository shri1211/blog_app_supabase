int calculateReadingTime(String content) {
  final worldCount = content.split(RegExp(r'\s+')).length;
  // speed = d/t
  final readingTime = worldCount / 225;
  // average human reading speed is 200 -300 words/min , i have taken approximately  225
  return readingTime.ceil();
}
