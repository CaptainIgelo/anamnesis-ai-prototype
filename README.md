# Anamnesis AI Prototype

A Flutter/Dart prototype for automated nursing anamesis analysis. 

## Project Overview 

This project was build as part of a job interview task. 

The app analyzes a pasted nursing patient interview transcript with the OpanAI GPT-4.1 API  and returns structured anamnesis answers based on a provided FHIR-like questionnaire JSON.

## Features

- Paste a patiant interview transcript into a text field 
- Start the analysis with the check button 
- Send transcript and questionnaire data to OpenAI GPT-4.1 
- Receive structured JSON results 
- Display extructed answers in a clear list 
- Export the results as a CSV file 
- Support both mock mode and live API mode 

## Current Status 

The MVP is functional and has been tested succssefully.

Completed: 
- Flutter app structure implemented 
- Transcript input field implemented 
- Questionnaire JSON loading implemented 
- OpenAI API integration implemented 
- Mock mode for local testing implemented 
- Analysis result list implemented 
- CSV export implemented 
- `flutter analyze` passes 
- `flutter test` passes 
- Mock mode tested successfully 
- Live API mode tested successfully

## Tech Stack 

- Flutter 
- Dart
- OpenAI GPT-4.1 API 
- JSON / CSV 
 
## Project Structure

- `lib/main.dart` - app entry point
- `lib/screens/home_screen.dart` - main UI and export flow
- `lib/services/openai_service.dart` - OpenAI request handling
- `lib/services/questionnaire_service.dart` - asset loading for questionnaire and sample transcript
- `lib/models/analysis_result.dart` - analysis result model
- `lib/models/questionnaire_item.dart` - questionnaire item model
- `assets/questionnaire/` - questionnaire JSON file
- `assets/transcripts/` - sample transcript file
- `test/widget_test.dart` - basic widget test

## How to Run 

Install dependencies: 

```bash
flutter pub get
```
Run in mock mode: 
```bash
flutter run --dart-define=USE_MOCK_OPENAI=true
```
Run with the live OpenAI API: 
```bash
flutter run --dart-define=USE_MOCK_OPENAI=false --dart-define=OPENAI_API_KEY=YOUR_API_KEY
```

## Testing

Static analysis: 
```bash
flutter analyze
```

Run Test: 
```bash
flutter test
```

## Example Output

For the included sample transcript, the app currently returns results such as: 

- `NIT_SVAn_08` → `Notfall`
- `NIT_SVAn_11` → `liegend`
- `NIT_SVAn_103` → `Verwitwet`

## Notes 

This project focuses on funtionality and workflow rather than final productuion UI polish. 

It was built as a prototype to demonstrate structured problem solving, API integration, JSON handling, and CSV export in Flutter. 
