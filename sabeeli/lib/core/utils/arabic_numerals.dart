/// Arabic-Indic digits (٠١٢…). The Quran font only draws its end-of-ayah ornament
/// around these, so ayah numbers always use them whatever the UI language.
String toArabicIndic(int n) =>
    String.fromCharCodes(n.toString().codeUnits.map((c) => 0x0660 + c - 0x30));
