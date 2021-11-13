# Cool datepicker

<div align="center">
<a href="https://pub.dev/packages/cool_dropdown/changelog" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/pub-v0.0.1-orange.svg"></a>
<a href="https://pub.dev/packages/cool_dropdown" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/build-passing-6FCC76.svg"></a>
<a href="https://opensource.org/licenses/MIT" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-MIT-blueviolet.svg"></a>
<a href="https://flutter.dev/" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg"></a>
</div>

## Features

- It's the best datepicker ui ever. (at least for me 😅)
- It's possible to set all colors of datepicker
- Support selected date list at the bottom. User can move selected date to selected year and month.
- "COOL"

## Samples

<div style="display: flex;">
<img src="https://github.com/joo6077/cool_datepicker/blob/master/screenshots/sample_01.gif?raw=true" height="500">
<img src="https://github.com/joo6077/cool_datepicker/blob/master/screenshots/sample_02.gif?raw=true" height="500"/>
<img src="https://github.com/joo6077/cool_datepicker/blob/master/screenshots/sample_03.gif?raw=true" height="500"/>
<img src="https://github.com/joo6077/cool_datepicker/blob/master/screenshots/sample_04.gif?raw=true" height="500"/>
</div>

<!-- ## Options map

<img src="https://github.com/joo6077/cool_dropdown/blob/master/screenshots/dropdown_description.png?raw=true" height="500"/> -->

## Installing

command:

```dart
 $ flutter pub add cool_datepicker
```

pubspec.yaml:

```dart
dependencies:
  cool_datepicker: ^(latest)
```

## Usage

```dart
import 'package:cool_datepicker/cool_datepicker.dart';


    CoolDatepicker(onSelected: (_) {})

```

## Important options

| option       | Type      |  Default | Description                                                                                                                                                                                            |
| ------------ | --------- | -------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| onSelected     | Function  | required | when user selects dates and then click the ok button, it's triggered. You must put one parameter in the Function. (ex. onChange: (a) {}).Then, you will get return List&lt;DateTime> / Map&lt;String, DateTime>|
| defaultValue            | List&lt;DateTime> / Map<String, DateTime>|                    null | Default selected  dates. It will automatically detects single/range depends on which type you use |
| disabledList            | List&lt;DateTime>                        |                    null | disabled dates list. You must pass List&lt;DateTime>    |
| disabledRangeList       | List&lt;Map<String, DateTime>>                    |                    null | disabled dates range map. You must use 'start' and 'end' key on the Map&lt;String, DateTime> |
| isRange       | bool                  |                    false | datepicker for single/range |
```dart

    CoolDatepicker(
        defaultValue: [DateTime(2020, 8, 24)], // single select
        onSelected: (_) {},
        disabledList: [DateTime(2021, 10, 22), DateTime(2021, 10, 12)],
        disabledRangeList: [
            {
            'start': DateTime(2021, 11, 1),
            'end': DateTime(2021, 11, 13)
            },
        ],
    )
    CoolDatepicker(
        defaultValue: { // range select
        'start': DateTime(2020, 9, 25),
        'end': DateTime(2021, 11, 24)
        },
        onSelected: (_) {},
    )
```


## Result options

| option                  | Type              |                 Default | Description                                |
| ----------------------- | ----------------- | ----------------------: | ------------------------------------------ |
| iconSize         | double            |  20|  Datepicker icon size                                   |
| resultWidth             | double            |                     220 |                                            |
| resultHeight            | double            |                      50 |                                            |
| resultBD                | BoxDecoration     |              below code | BoxDecoration of the result                |
| resultTS                | TextStyle         |              below code | TextStyle of the result                    |
| resultPadding           | EdgeInsets        |              below code | Padding of the result                      |
| isResultIconLabelReverse| bool              |                   false | Reverse order of the result by row         |
| labelIconGap            | double            |                      10 | Gap between the label and icon             |
| isResultLabel           | bool              |                    true | Show/hide the label of the result          |
| placeholder             | String            |                    null |                                            |
| placeholderTS           | TextStyle         |              below code |                                            |
| iconSize                | double            |                      20 | the size of the calendar icon in resultBox |

```dart
resultBD = BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        );
```

```dart
resultTS = TextStyle(
            fontSize: 20,
            color: Colors.black,
          );
```

```dart
resultPadding = const EdgeInsets.only(left: 10, right: 10);
```

```dart
placeholderTS = TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
```

## Datepicker options

| option                | Type              |                 Default | Description                                           |
| --------------------- | ----------------- | ----------------------: | ----------------------------------------------------- |
| calendarSize         | double            |  400|  Datepicker size                                   |
| minYear         | double            |  DateTime.now().year - 100|  Datepicker minimum year                                   |
| maxYear         | double            |  DateTime.now().year + 100|  Datepicker maximum year                                   |
| format         | string            |  'yyyy-mm-dd'| Format to show as result and bottom selected dates                       |
| limitCount         | int            |  1| Set how many dates can be picked                       |
| weekLabelList         | List<String>            |  below code| Set week words on the datepicker                       |
| monthLabelList         | List<String>            |  below code| Set month dropdown label on the datepicker datepicker        |
| isYearMonthDropdownReverse         | bool            |  false| Reverse order of dropdowns on the datepicker        |
| headerColor         | Color            |  Color(0XFF6771e4)| Reverse order of dropdowns on the datepicker        |
| arrowIconAreaColor         | Color            |  Color(0XFF4752e0)| Reverse order of dropdowns on the datepicker        |
| selectedCircleColor         | Color            |  Color(0XFF6771e4)| Reverse order of dropdowns on the datepicker        |
| selectedBetweenAreaColor         | Color            |  Color(0XFFe2e4fa)| Reverse order of dropdowns on the datepicker        |
| cancelFontColor         | Color            |  Color(0XFF4a54c5)| Reverse order of dropdowns on the datepicker        |
| okButtonColor         | LinearGradient            |  below code| Reverse order of dropdowns on the datepicker        |
| bottomSelectedBorderColor         | Color            |  Color(0XFF6771e4)| Reverse order of dropdowns on the datepicker        |
| isDark         | bool            |  false| dark mode        |
| cancelBtnLabel         | String            |  'CANCEL'| Cancel button label        |
| okBtnLabel         | String            |  'OK'| Ok button label        |


```dart
weekLabelList = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
```

```dart
monthLabelList = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
```

```dart
okButtonColor = const LinearGradient(colors: [
    Color(0XFF4a54c5),
    Color(0XFF6771e4),
]);
```

