# Anamnesis AI Prototype

A Flutter/Dart prototype for automated nursing anamesis analysis. 

## Project Overview 

This project is a prototype moblie application biult for a job interview task.
It analyzes a pasted nursin patient interview transcript woth the OpanAI GPT-4.1 API and returns structured anamnesis answers based on provided FHIR-like quarstionnaire. 

## Goal 

The app should: 

- accept a pasted interview transcript, 
- send the transcript together with a quastionnaire and promt to GPT-4.1,
- receive structured JSON answers, 
- display the extracted answers in a clear list, 
- export the results as CSV. 

## Current Status 

Current phase: project setup and technical foundation. 

Completed: 
- GitHub repository created 
- Github Codespaces created 
- Flutter SDK installed in Codespaces 
- Flutter web support enabled 
- Project folder structure initialized 

Next: 
- create Flutter project 
- define MVP data model 
- implement basic UI 
- integrate OpenAI request flow 
- render results 
- export CSV 

## Tech Stack 

- Flutter 
- Dart
- OpenAI GPT-4.1 API 
- GitHub Codespaces 
- JSON / CSV 

Repository Structure 

Planned structure: 

- `assets/questionnaire/` - questionnaire JSON
- `assets/transcripts/` - interview input example
- `assets/examples` - sample output data
- `docs/notes.md` - working notes and decisions 
- `exports/` - generated CSV exports

## Notes 

This repository is intentionally documented step by step during development. 